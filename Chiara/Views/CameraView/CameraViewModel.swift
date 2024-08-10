//
//  CameraViewModel.swift
//  Chiara
//
//  Created by Lee Sihyeong on 8/10/24.
//

import AVFoundation
import SwiftUI

class CameraViewModel: ObservableObject {
    private let model: Camera
    private let session: AVCaptureSession
    let cameraPreview: AnyView
    var photoData: Data = Data()
    
    init() {
        model = Camera()
        session = model.session
        cameraPreview = AnyView(CameraPreviewView(session: session))
    }
    
    @Published var isFlashOn = false
    @Published var isSilentModeOn = false
    
    func configure() {
        model.requestAndCheckPermissions()
    }
    
    func switchFlash() {
        isFlashOn.toggle()
    }
    
    func switchSilent() {
        isSilentModeOn.toggle()
    }
    
    func capturePhoto() {
        model.capturePhoto()
    }
    
    func changeCamera() {
        
    }
}
