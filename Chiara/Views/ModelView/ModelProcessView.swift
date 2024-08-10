//
//  ModelProcessView.swift
//  Chiara
//
//  Created by 추서연 on 8/11/24.



import SwiftUI
import CoreML
import Vision

struct ModelProcessView: View {
    let image: UIImage?
    @State private var result: AnyView = AnyView(Text(""))
    @State private var buttonTitle: String = "Process Image"
    @State private var isButtonDisabled: Bool = false
    @State private var isNavigating: Bool = false
    @State private var showAlert: Bool = false // To handle navigation for invalid state

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
        NavigationView {
            ZStack {
                VStack {
                    if let image = image {
                        ZStack(alignment: .bottom) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                                .padding(.horizontal, 20)
                                                            .padding(.vertical, 30)
                            
                            result
                                .padding()
                            
                        }
                        
                        NavigationLink(
                            destination: SelectLocationView(),
                            isActive: $isNavigating
                        ) {
                            Button(buttonTitle) {
                                if buttonTitle == "Process Image" {
                                    processImage(image)
                                } else {
                                    if !isButtonDisabled {
                                        isNavigating = true
                                    } else {
                                        showAlert = true
                                    }
                                }
                            }
                            .padding(15)
                            .background(isButtonDisabled ? Color.gray : Color.black)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Action Not Allowed"),
                                    message: Text("The drain is clean and cannot be added to the map."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        }
                    } else {
                        Text("No Image Available")
                            .font(.system(size: 20, weight: .semibold))
                            .padding()
                    }
                }

            }
        }
        .navigationTitle("Process Image")
       .navigationBarTitleDisplayMode(.inline)
    }
    
    private func processImage(_ image: UIImage) {
        guard let model = model else {
            result = AnyView(Text("Model is not available.").font(.system(size: 20, weight: .semibold)))
            return
        }
        
        // Convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else {
            result = AnyView(Text("Failed to convert image.").font(.system(size: 20, weight: .semibold)))
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                DispatchQueue.main.async {
                    result = AnyView(Text("Error: \(error.localizedDescription)").font(.system(size: 20, weight: .semibold)))
                }
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                DispatchQueue.main.async {
                    result = AnyView(Text("No results found.").font(.system(size: 20, weight: .semibold)))
                }
                return
            }
            
            let classification = topResult.identifier
            DispatchQueue.main.async {
                switch classification {
                case "CleanDrain":
                    result = AnyView(
                        ZStack {
                            VStack {
                                Text("The drain is already clean")
                                    .font(.system(size: 20, weight: .semibold))
                                    .padding(.bottom, 15)
                                HStack {
                                    Image(systemName: "hand.thumbsup.fill")
                                        .foregroundColor(.accentColor)
                                    Text("Clean Drain")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.darkGray)
                                }
                                .offset(y: -10)
                            }
                            .padding(.horizontal, 40)
                            .padding(15)
                            .background(Color.white.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .padding(.bottom, 30)
                        }
                    )
                    buttonTitle = "Add to Map"
                    isButtonDisabled = true
                case "CigaDrain":
                    result = AnyView(
                        ZStack {
                            VStack {
                                Text("The drain is clogged!")
                                    .font(.system(size: 20, weight: .semibold))
                                    .padding(.bottom, 15)
                                HStack {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.red)
                                    Text("Cigarette")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.darkGray)
                                }
                                .offset(y: -10)
                            }
                            .padding(.horizontal, 40)
                            .padding(15)
                            .background(Color.white.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .padding(.bottom, 30)
                        }
                    )
                    buttonTitle = "Add to Map"
                    isButtonDisabled = false
                case "LeavesDrain":
                    result = AnyView(
                        ZStack {
                            VStack {
                                Text("The drain is clogged!")
                                    .font(.system(size: 20, weight: .semibold))
                                    .padding(.bottom, 15)
                                HStack {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.green)
                                    Text("Leaves")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.darkGray)
                                }
                                .offset(y: -10)
                            }
                            .padding(.horizontal, 40)
                            .padding(15)
                            .background(Color.white.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .padding(.bottom, 30)
                        }
                    )
                    buttonTitle = "Add to Map"
                    isButtonDisabled = false
                default:
                    result = AnyView(Text("Unknown result: \(classification)").font(.system(size: 20, weight: .semibold)))
                    buttonTitle = "Add to Map"
                    isButtonDisabled = false
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    result = AnyView(Text("Failed to perform request: \(error.localizedDescription)").font(.system(size: 20, weight: .semibold)))
                }
            }
        }
    }
}
