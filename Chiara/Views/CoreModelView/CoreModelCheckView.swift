//
//  CoreModelProcessView.swift
//  Chiara
//
//  Created by 추서연, sseungwonnn on 8/11/24.

import SwiftUI
import CoreML
import Vision

struct CoreModelCheckView: View {
    @EnvironmentObject var routerManager: RouterManager
    @EnvironmentObject var streetDrainManager: StreetDrainManager
    
    let streetDrain: StreetDrain
    let image: UIImage
    
    @State private var showAlert: Bool = false
    
    @State private var imageStatus: ImageStatus = .notYet
    
    enum ImageStatus {
        case notYet
        case inProgress
        case cigarette
        case leaf
        case clean
        case error
    }

    var isCleaned: Bool {
        imageStatus == .clean
    }
    
    var buttonText: String {
        switch imageStatus {
        case .notYet:
            "Check Image"
        case .inProgress:
            "In progress"
        case .cigarette:
            "Try Again"
        case .leaf:
            "Try Again"
        case .clean:
            "Submit"
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
                
                if isCleaned {
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
                case .cigarette:
                    self.showAlert = true
                case .leaf:
                    self.showAlert = true
                case .clean:
                    streetDrainManager.cleanCloggedDrain(streetDrain)
                    
                    routerManager.push(view: .cleanSuccessView)
                case .error:
                    self.showAlert = true
                }
            } label: {
                ButtonLabel(buttonText: buttonText, isDisabled: false)
            }
        } // VStack
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Not Enough"),
                message: Text("The drain is not clean yet. please try again"),
                primaryButton: .default(Text("Try Again")) {
                    routerManager.pop()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle("Check")
        .navigationBarTitleDisplayMode(.inline)
    }
}


fileprivate extension CoreModelCheckView {
    @ViewBuilder
    private func resultView() -> some View {
        HStack {
            Spacer()
            
            VStack(alignment: .center, spacing: 14) {
                Text("You've done well")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                
                Image(systemName: "hand.thumbsup.fill")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.accent)
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
                    self.imageStatus = .cigarette
                    
                case "LeavesDrain":
                    self.imageStatus = .cigarette
                    
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
