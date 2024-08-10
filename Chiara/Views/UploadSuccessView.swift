//
//  UploadSuccessView.swift
//  Chiara
//
//  Created by Lee Sihyeong on 8/11/24.
//

import SwiftUI

struct UploadSuccessView: View {
    var body: some View {
        VStack(spacing: 0) {
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
            
            // TODO: 버튼 구현해야함
            Button {
                
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
        }
    }
}

#Preview {
    UploadSuccessView()
}
