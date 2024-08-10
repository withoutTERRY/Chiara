//
//  CoreModelProcessView.swift
//  Chiara
//
//  Created by 추서연, sseungwonnn on 8/11/24.



import SwiftUI
import CoreML
import Vision

struct CoreModelProcessView: View {
    @EnvironmentObject var routerManager: RouterManager
    
    let image: UIImage
    
    @State private var showAlert: Bool = false
    
    @State private var imageStatus: ImageStatus = .notYet
    
    enum ImageStatus {
        case notYet
        case inProgress
        case cigarret
        case leaf
        case clean
        case error
    }

    var isImageProcessingDone: Bool {
        imageStatus == .clean
        || imageStatus == .leaf
        || imageStatus == .cigarret
        || imageStatus == .error
    }
    
    var buttonText: String {
        switch imageStatus {
        case .notYet:
            "Process Image"
        case .inProgress:
            "In progress"
        case .cigarret:
            "Add To Map"
        case .leaf:
            "Add To Map"
        case .clean:
            "Finish"
        case .error:
            "Try Again"
        }
    }
    
    // Image Classification 진행
    private var model: VNCoreMLModel? {
        // Ensure the model file name matches the name in your project
        guard let modelURL = Bundle.main.url(forResource: "StreetDrainCleanness_1", withExtension: "mlmodelc") else {
            print("Model file not found.")
            return nil
        }
        
        do {
            let coreMLModel = try MLModel(contentsOf: modelURL)
            return try VNCoreMLModel(for: coreMLModel)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            
            ZStack(alignment: .bottom) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                
                if isImageProcessingDone {
                    resultView()
                        .padding(.horizontal, 30)
                        .padding(.bottom, 40)
                }
            }
            
            Button {
                switch imageStatus {
                case .notYet:
                    self.processImage(image)
                    self.imageStatus = .inProgress
                case .inProgress:
                    self.imageStatus = .inProgress
                case .cigarret:
                    routerManager.push(view: .newLocationView)
                case .leaf:
                    routerManager.push(view: .newLocationView)
                case .clean:
                    self.showAlert = true
                case .error:
                    routerManager.pop()
                }
            } label: {
                ButtonLabel(buttonText: buttonText, isDisabled: false)
            }
        } // VStack
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Finish"),
                message: Text("The drain is clean and cannot be added to the map."),
                primaryButton: .default(Text("Go to Map")) {
                    routerManager.backToMap()
                },
                secondaryButton: .cancel()
            )       
        }
        .navigationTitle("Process Image")
        .navigationBarTitleDisplayMode(.inline)
    }
}


fileprivate extension CoreModelProcessView {
    @ViewBuilder
    private func resultView() -> some View {
        var resultText: String {
            switch imageStatus {
            case .notYet, .inProgress, .error:
                "Try again"
            
            case .cigarret, .leaf:
                "The drain is clogged!"
                
            case .clean:
                "The drain is already clean"
            }
        }
        
        var resultEmojiName: String {
            switch imageStatus {
            case .notYet, .inProgress, .error:
                "exclamationmark.triangle"
            case .cigarret:
                "pencil.fill"
            case .leaf:
                "leaf.fill"
            case .clean:
                "hand.thumbsup.fill"
            }
        }
        
        var resultEmojiColor: Color {
            switch imageStatus {
            case .notYet, .inProgress, .error:
                    .yellow
            case .cigarret:
                    .red
            case .leaf:
                    .green
            case .clean:
                    .accent
            }
        }
        
        var resultDescription: String {
            switch imageStatus {
            case .notYet, .inProgress, .error:
                ""
            case .cigarret:
                "cigarret"
            case .leaf:
                "leaves"
            case .clean:
                ""
            }
        }
        
        HStack {
            Spacer()
            
            VStack(alignment: .center, spacing: 14) {
                Text("\(resultText)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: resultEmojiName)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(resultEmojiColor)
                    
                    Text("\(resultDescription)")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.darkGray)
                }
                
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 22)
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
        }
        
    }
    
    private func processImage(_ image: UIImage) {
        guard let model = model else {
            self.imageStatus = .error
            
            return
        }
        
        // Convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else {
            self.imageStatus = .error
            
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                self.imageStatus = .error
                
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                
                self.imageStatus = .error
                return
            }
            
            let classification = topResult.identifier
            DispatchQueue.main.async {
                switch classification {
                case "CleanDrain":
                    self.imageStatus = .clean
                    
                case "CigaDrain":
                    self.imageStatus = .cigarret
                    
                case "LeavesDrain":
                    self.imageStatus = .cigarret
                    
                default:
                    self.imageStatus = .error
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                self.imageStatus = .error
            }
        }
    }
}
