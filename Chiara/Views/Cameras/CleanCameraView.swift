//
//  CleanCameraView.swift
//  Chiara
//
//  Created by Lee Sihyeong on 8/11/24.
//

import SwiftUI

<<<<<<<< HEAD:Chiara/Views/CameraView/CameraView.swift
struct CameraView: View {
========
struct CleanCameraView: View {
>>>>>>>> b26768df0a83f99a555d8528ad6de7bde96d9734:Chiara/Views/Cameras/CleanCameraView.swift
    @EnvironmentObject var cameraViewModel: CameraViewModel
    @EnvironmentObject var routerManager: RouterManager
    
    @State var isShuttered: Bool = false
    
    var bottomText: String {
        if !isShuttered { // 셔터 누르기 전
<<<<<<<< HEAD:Chiara/Views/CameraView/CameraView.swift
            return "Check the state of the street drain!"
========
            return "Upload the photo after cleaning"
>>>>>>>> b26768df0a83f99a555d8528ad6de7bde96d9734:Chiara/Views/Cameras/CleanCameraView.swift
        } else if self.cameraViewModel.model.recentImage == nil { // 셔터는 눌렀으나 사진이 없는 경우
            return "please take a photo again!"
        } else { // 성공
            return "Go to the next step!"
        }
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            
            ZStack(alignment: .bottom) {
                // MARK: - 아직 사진을 찍기 전
                if !isShuttered {
                    cameraViewModel.cameraPreview
                    
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
                    .padding(.bottom, 16)
                    
//                    Text("Take a photo of the street drain")
//                        .fontWeight(.semibold)
//                        .foregroundStyle(.darkGray)
//                        .padding(.bottom, 250)
                    
                }
                // MARK: - 사진을 찍은 뒤
                else {
                    if let recentImage = cameraViewModel.model.recentImage {
                        Image(uiImage: recentImage)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 40))
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
                    .padding(.bottom, 16)
                    
//                    Text("Go to next step")
//                        .fontWeight(.semibold)
//                        .foregroundStyle(.darkGray)
//                        .padding(.bottom, 250)
                }
            }
<<<<<<<< HEAD:Chiara/Views/CameraView/CameraView.swift
========
            
>>>>>>>> b26768df0a83f99a555d8528ad6de7bde96d9734:Chiara/Views/Cameras/CleanCameraView.swift
            Spacer().frame(height: 30)
            
            HStack {
                Spacer()
                Text("\(bottomText)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                Spacer()
            }
<<<<<<<< HEAD:Chiara/Views/CameraView/CameraView.swift
            Spacer().frame(height: 10)
========
>>>>>>>> b26768df0a83f99a555d8528ad6de7bde96d9734:Chiara/Views/Cameras/CleanCameraView.swift
        }
        .padding(.horizontal, 20)
        .navigationTitle("Upload")
        .navigationBarItems(
            trailing:  Button {
<<<<<<<< HEAD:Chiara/Views/CameraView/CameraView.swift
                if let image = cameraViewModel.model.recentImage {
                    routerManager.push(view: .coreModelProcessView(image: image))
                } else {
                    // TODO: 예외처리
                }
            } label: {
                Text("Next")
========
                if cameraViewModel.model.recentImage != nil {
//                    routerManager.push(view: .coreModelProcessView(image: cameraViewModel.model.recentImage))
                } else {
                    
                }
            } label: {
                Text("Done")
>>>>>>>> b26768df0a83f99a555d8528ad6de7bde96d9734:Chiara/Views/Cameras/CleanCameraView.swift
            }
        )
        .onAppear {
            cameraViewModel.configure()
        }
    }
}
