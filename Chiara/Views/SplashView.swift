//
//  SplashView.swift
//  Chiara
//
//  Created by sseungwonnn on 8/11/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
            LottieView(jsonName: "chiara")
                .padding(.bottom, 90)
    }
}

#Preview {
    SplashView()
}
