//
//  CameraView.swift
//  Chiara
//
//  Created by Lee Sihyeong on 8/10/24.
//

import SwiftUI

struct CameraView: View {
    
    @ObservedObject var cameraViewModel: CameraViewModel
    @State var isShuttered: Bool = false
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if !isShuttered {
                    cameraViewModel.cameraPreview
                        .onAppear {
                            cameraViewModel.configure()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 135)
                    
                    Button {
                        cameraViewModel.capturePhoto()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                          // 1초 후 실행될 부분
                            isShuttered = true
                        }

                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 67, height: 67)
                                .foregroundStyle(.color)
                            Circle()
                                .frame(width: 61, height: 61)
                                .foregroundStyle(.black)
                            Circle()
                                .frame(width: 53, height: 53)
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.bottom, 135 + 16)
                } else {
                    Button {
                        isShuttered = false
                    } label: {
                        Text("다시찍기")
                    }
                }
            }
            .navigationTitle("Upload")
            .ignoresSafeArea()
        }
    }
}

//#Preview {
//    CameraView()
//}
