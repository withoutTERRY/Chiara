//
//  CleanSuccessView.swift
//  Chiara
//
//  Created by Lee Sihyeong on 8/11/24.
//

import SwiftUI

struct CleanSuccessView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("Succesfully Cleaned")
                .font(.system(size: 24, weight: .semibold))
                .padding(.horizontal, 80)
                .padding(.bottom, 28)
            
            Image(.cleanSuccess)
                .resizable()
                .scaledToFit()
                .frame(width: 234)
                .padding(.bottom, 20)
            
            Text("Your work has brought these in Pohang")
                .foregroundStyle(.gray)
                .font(.system(size: 17, weight: .medium))
                .padding(.bottom, 20)
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.lightGray)
                .overlay {
                    HStack {
                        VStack(alignment: .leading, spacing: 37) {
                            Circle()
                                .frame(width: 10, height: 10)
                            Circle()
                                .frame(width: 10, height: 10)
                            Circle()
                                .frame(width: 10, height: 10)
                        }
                        
                        VStack(alignment: .leading, spacing: 18) {
                            Text("Improve water drainage")
                                .font(.system(size: 24))
                            Text("Revitalized the city")
                                .font(.system(size: 24))
                            Text("Eliminate odors")
                                .font(.system(size: 24))
                        }
                        .padding(.leading, 5)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 176)
                .padding(.horizontal, 20)
                .padding(.bottom, 58)
            
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
            .padding(.bottom, 44)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CleanSuccessView()
}
