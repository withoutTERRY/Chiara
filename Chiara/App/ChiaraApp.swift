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
    
    var body: some Scene {
        WindowGroup {
            MapView()
                .environmentObject(locationManager)
                .environmentObject(streetDrainManager)
                .onAppear {
                    // 위치 정보 접근 권한 요청을 합니다.
                    locationManager.requestLocation()
                    
                    // 실시간 배수구 정보를 받아옵니다.
                    streetDrainManager.listenToRealtimeDatabase()
                }
        }
    }
}
