//
//  CameraViewModel.swift
//  Chiara
//
//  Created by Lee Sihyeong on 8/10/24.
//

import AVFoundation
import SwiftUI

class CameraViewModel: ObservableObject {
    let model: Camera
    let session: AVCaptureSession
    let cameraPreview: AnyView
    
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
    
    func capturePhoto() {
        model.capturePhoto()
    }
}
