//
//  ChiaraApp.swift
//  Chiara
//
//  Created by Eom Chanwoo on 8/10/24.
//

import SwiftUI

@main
struct ChiaraApp: App {
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .onAppear {
                    // 위치 정보 접근 권한 요청을 합니다.
                    locationManager.requestLocation()
                }
        }
    }
}
