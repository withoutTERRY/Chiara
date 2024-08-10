//
//  ContentView.swift
//  Chiara
//
//  Created by Eom Chanwoo on 8/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    NavigationLink {
//                        CameraView()
                    } label: {
                        RoundedRectangle(cornerRadius: 90)
                            .frame(width: 170, height: 42)
                            .padding(.leading, 20)
                            .padding(.bottom, 30)
                            .foregroundStyle(.black)
                    }
                    Spacer()
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
