//
//  ModelProcessView.swift
//  Chiara
//
//  Created by 추서연 on 8/11/24.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let model = try! StreetDrainCleanness_1(configuration: MLModelConfiguration()) // 모델 로드
    
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraPreview()
    }
    
    // 카메라 프리뷰 설정
    func setupCameraPreview() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            print("Failed to access the camera.")
            return
        }
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        
        if let captureSession = captureSession,
           captureSession.canAddInput(input),
           captureSession.canAddOutput(capturePhotoOutput!) {
            captureSession.addInput(input)
            captureSession.addOutput(capturePhotoOutput!)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = cameraPreviewView.bounds
            cameraPreviewView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
        }
    }
    
    // 사진 촬영 버튼 클릭 시 호출
    @IBAction func selectPhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        settings.isHighResolutionPhotoEnabled = true
        
        capturePhotoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    // 촬영된 사진을 처리하는 메서드
    func processPhoto(_ image: UIImage) {
        imageView.image = image
        
        if let ciImage = CIImage(image: image) {
            classifyImage(image: ciImage)
        }
    }
    
    // 이미지를 전처리하고 모델에 넣어 결과를 예측하는 함수
    func classifyImage(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: model.model) else {
            resultLabel.text = "Model loading failed."
            return
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                self.resultLabel.text = "Failed to get results."
                return
            }
            
            if let topResult = results.first {
                DispatchQueue.main.async {
                    self.resultLabel.text = "Result: \(topResult.identifier) (\(topResult.confidence * 100)%)"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

// 카메라 사진 촬영 후 호출되는 delegate 메서드
extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Error capturing photo: \(error!)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Error processing photo data.")
            return
        }
        
        processPhoto(image)
    }
}
