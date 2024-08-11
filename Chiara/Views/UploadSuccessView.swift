//
//  UploadSuccessView.swift
//  Chiara
//
//  Created by Lee Sihyeong on 8/11/24.
//

import SwiftUI

struct UploadSuccessView: View {
    @EnvironmentObject var routerManager: RouterManager
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("Upload Succesful")
                .font(.system(size: 24, weight: .semibold))
                .padding(.bottom, 40)
            
            Image(.uploadSuccess)
                .resizable()
                .scaledToFit()
                .frame(width: 234)
                .padding(.bottom, 120)
            
            Text("Plogger will get the information soon")
                .foregroundStyle(.gray)
                .font(.system(size: 17, weight: .medium))
                .padding(.bottom, 120)
            
            Button {
                routerManager.backToMap()
            } label: {
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: 54)
                    .padding(.horizontal, 110)
                    .foregroundStyle(.black)
                    .overlay {
                        Text("Done")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                    }
            }
            .padding(.bottom, 44)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    UploadSuccessView()
}
