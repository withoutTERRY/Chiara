//
//  HereComponent.swift
//  Chiara
//
//  Created by Eom Chanwoo on 8/11/24.
//

import SwiftUI

struct HereAnnotation: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                Text("Here")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
            }
            .frame(width: 70, height: 35)
            Rectangle()
                .frame(width: 2, height: 12)
            Circle()
                .frame(width: 5)
        }
    }
}

#Preview {
    HereAnnotation()
}
