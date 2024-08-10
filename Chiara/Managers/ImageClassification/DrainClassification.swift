//
//  DrainClassification.swift
//  Chiara
//
//  Created by 추서연 on 8/11/24.
//
import CoreML
import Vision
import UIKit

// Assuming you have a UIImage captured from the camera
func classifyImage(_ image: UIImage) {
    guard let model = try? VNCoreMLModel(for: StreetDrainCleanness_1().model) else {
        fatalError("Failed to load model")
    }
    
    let request = VNCoreMLRequest(model: model) { (request, error) in
        if let results = request.results as? [VNClassificationObservation] {
            if let topResult = results.first {
                print("Classification: \(topResult.identifier)")
            }
        }
    }
    
    guard let ciImage = CIImage(image: image) else {
        fatalError("Could not convert UIImage to CIImage")
    }
    
    let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
    
    do {
        try handler.perform([request])
    } catch {
        print("Failed to perform classification: \(error.localizedDescription)")
    }
}
