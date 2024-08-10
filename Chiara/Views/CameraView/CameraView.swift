//
//  CameraView.swift
//  Chiara
//
//  Created by Lee Sihyeong on 8/11/24.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject var cameraViewModel: CameraViewModel
    
    @State var isShuttered: Bool = false
    @State private var showModelProcessView: Bool = false
    
    var body: some View {
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
                        isShuttered = true
                    }
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 67, height: 67)
                            .foregroundStyle(.accent)
                        Circle()
                            .frame(width: 61, height: 61)
                            .foregroundStyle(.black)
                        Circle()
                            .frame(width: 53, height: 53)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.bottom, 135 + 16)
                //.padding(.bottom, 55)
                
                Text("Take a photo of the street drain")
                    .fontWeight(.semibold)
                    .foregroundStyle(.darkGray)
                    .padding(.bottom, 250)
                
            } else {
                if let recentImage = cameraViewModel.model.recentImage {
                    Image(uiImage: recentImage)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 135)
                }
                
                Button {
                    isShuttered = false
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 67, height: 67)
                            .foregroundStyle(.accent)
                        Circle()
                            .frame(width: 61, height: 61)
                            .foregroundStyle(.black)
                        Circle()
                            .frame(width: 53, height: 53)
                            .foregroundStyle(.white)
                        Image(systemName: "arrow.circlepath")
                            .foregroundStyle(.black)
                    }
                }
                .padding(.bottom, 135 + 16)
                
                Text("Go to next step")
                    .fontWeight(.semibold)
                    .foregroundStyle(.darkGray)
                    .padding(.bottom, 250)
                
                
                NavigationLink(
                    destination: ModelProcessView(image: cameraViewModel.model.recentImage),
                    isActive: $showModelProcessView
                ) {
                    EmptyView()
                }
                
                
            }
        }
        .navigationTitle("Upload")
        .ignoresSafeArea()
        .navigationBarItems(trailing: Button("Next") {
            if cameraViewModel.model.recentImage != nil {
                showModelProcessView = true
            }
        })
    }
}
