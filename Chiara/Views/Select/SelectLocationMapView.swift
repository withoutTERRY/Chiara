//
//  SelectLocationMapView.swift
//  Chiara
//
//  Created by Eom Chanwoo on 8/11/24.
//

import SwiftUI
import MapKit

struct SelectLocationMapView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var routerManager: RouterManager
    
    @Binding var address: String
    @Binding var location: CLLocationCoordinate2D
    
    var body: some View {
        ZStack {
            // MARK: - 메인으로 표시될 지도
            LocationMapViewRepresentable(address: $address, location: $location)
            
            VStack {
                HereAnnotation()
                Spacer().frame(height: 52)
            }

            // MARK: - 지도위에 나타날 화면
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    // MARK: - 내 위치로 이동 버튼
                    Button {
                        locationManager.mapViewFocusChange()
                    } label: {
                        Image(systemName: "scope")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 42, height: 42)
                            }
                    }
                }
            }
            .padding(20)
        }
    }
}
