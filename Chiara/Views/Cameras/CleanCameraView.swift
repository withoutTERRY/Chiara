//
//  CleanCameraView.swift
//  Chiara
//
//  Created by Lee Sihyeong, sseungwonnn on 8/11/24.
//

import SwiftUI

struct CleanCameraView: View {
    @EnvironmentObject var cameraViewModel: CameraViewModel
    @EnvironmentObject var routerManager: RouterManager
    
    @State var isShuttered: Bool = false
    
    let streetDrain: StreetDrain
    
    var bottomText: String {
        if !isShuttered { // 셔터 누르기 전
            return "Upload the photo after cleaning"
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
                }
            }
            Spacer().frame(height: 30)
            
            HStack {
                Spacer()
                Text("\(bottomText)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .navigationTitle("Check")
        .navigationBarItems(
            trailing: Button {
                if let image = cameraViewModel.model.recentImage {
                    routerManager.push(view: .coreModelCheckView(streetDrain: streetDrain, image: image))
                } else {
                    
                }
            } label: {
                Text("Done")
            }
        )
        .onAppear {
            cameraViewModel.configure()
        }
    }
}
