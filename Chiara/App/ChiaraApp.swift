//
//  ChiaraApp.swift
//  Chiara
//
//  Created by Eom Chanwoo on 8/10/24.
//

import SwiftUI

@main
struct ChiaraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var streetDrainManager = StreetDrainManager.shared
    
    @State private var streetDrainList: [StreetDrain] = [StreetDrain(id: UUID().uuidString,
                                                                     address: "77, Cheongam-ro, Nam-gu, Pohang-si, Gyeongsangbuk-do, Republic of Korea", latitude: 36.01403209698482, longitude: 129.32589456302887, trashType: .cigarette, isCleaned: false)]
    var body: some Scene {
        WindowGroup {
            MapView(streetDrainList: $streetDrainList)
                .environmentObject(locationManager)
                .environmentObject(streetDrainManager)
                .onAppear {
                    // 위치 정보 접근 권한 요청을 합니다.
                    locationManager.requestLocation()
                    streetDrainManager.listenToRealtimeDatabase()
                }
        }
    }
}
