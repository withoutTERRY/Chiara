//
//  SelectLocationView.swift
//  Chiara
//
//  Created by 추서연, Eom Chanwoo on 8/11/24.
//

import SwiftUI
import MapKit

struct SelectLocationView: View {
    @EnvironmentObject var routerManager: RouterManager
    @EnvironmentObject var streetDrainManager: StreetDrainManager
    @EnvironmentObject var locationManager: LocationManager
    
    let trashType: TrashType
    
    @State private var address: String = ""
    @State private var location: CLLocationCoordinate2D = .init()
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            SelectLocationMapView(address: $address, location: $location)
            Spacer().frame(height: 30)
            Text(address)
                .font(.system(size: 17))
            Spacer().frame(height: 50)
            Button {
                streetDrainManager.reportCloggedDrain(
                    StreetDrain(id: UUID().uuidString,
                                address: address,
                                latitude: location.latitude,
                                longitude: location.longitude,
                                trashType: trashType,
                                isCleaned: false))
                routerManager.push(view: .uploadSuccessView)
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

