//
//  SelectLocationView.swift
//  Chiara
//
//  Created by 추서연, Eom Chanwoo on 8/11/24.
//

import SwiftUI
import MapKit

struct SelectLocationView: View {
    @State private var address: String = ""
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            SelectLocationMapView(address: $address)
            Spacer().frame(height: 30)
            Text(address)
                .font(.system(size: 17))
            Spacer().frame(height: 50)
            Button {
                // TODO: 완료 뷰로 네비게이트
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                    Text("Set as clogged")
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                        .bold()
                }
                .frame(width: 194, height: 54)
            }
        }
        .navigationTitle("Select the location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

