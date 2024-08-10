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
    
    var streetDrain: StreetDrain?
    
    @Binding var isSheetDisplaying: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
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
                    .frame(width: 300, height: 200)
                
                Spacer()
                
                NavigationLink {
                    // TODO: 이동 동작 추가
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
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 38)
            .navigationBarBackButtonHidden()
            .onAppear {
                if let streetDrain = streetDrain {
                    let location = CLLocation(latitude: streetDrain.latitude, longitude: streetDrain.longitude)
                    locationManager.convertLocationToAddress(location: location)
                }
            }
        }
    }
}
