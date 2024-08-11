//
//  StreetDrainSheetView.swift
//  Chiara
//
//  Created by sseungwonnn on 8/10/24.
//

import SwiftUI
import MapKit

struct StreetDrainSheetView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var routerManager: RouterManager
    var streetDrain: StreetDrain?
    
    @Binding var isSheetDisplaying: Bool

    var body: some View {
        VStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 30)
                .fill(.darkGray)
                .frame(width: 80, height: 5)
                .padding(.top, 12)
            HStack {
                Text("\(locationManager.currentPlace)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            // TODO: 이미지 추가 예정
            Rectangle()
                .frame(width: 250, height: 150)
            
            Spacer().frame(height: 25)
            
            Button {
                isSheetDisplaying = false
                if let streetDrain = streetDrain {
                    routerManager.push(view: .cleanCameraView(streetDrain: streetDrain))
                }
                
            } label: {
                Text("Clean It Up")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 20)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.accent)
                    }
            }
            Spacer()
        }
        .frame(height: 480)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .navigationBarBackButtonHidden()
        .onAppear {
            if let streetDrain = streetDrain {
                let location = CLLocation(latitude: streetDrain.latitude, longitude: streetDrain.longitude)
                locationManager.convertLocationToAddress(location: location)
            }
        }
    }
}
