//
//  CameraPreviewView.swift
//  Chiara
//
//  Created by Lee Sihyeong on 8/11/24.
//

import AVFoundation
import SwiftUI

struct CameraPreviewView: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
             AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    let session: AVCaptureSession
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()

        view.backgroundColor = .black
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.cornerRadius = 40
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.connection?.videoOrientation = .portrait

        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {

    }
}
