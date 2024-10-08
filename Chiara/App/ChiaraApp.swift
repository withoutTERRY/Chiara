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
    @StateObject private var routerManager = RouterManager()
    @StateObject private var cameraViewModel = CameraViewModel()
    
    @State private var isLoading: Bool = false
    @State private var showSplashView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routerManager.path) {
                if showSplashView {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showSplashView = false
                                }
                            }
                        }
                } else {
                    if isLoading {
                        ProgressView("loading data...")
                            .progressViewStyle(DefaultProgressViewStyle())
                    } else {
                        MapView()
                            .navigationDestination(for: ChiaraView.self){ chiaraView in
                                routerManager.view(for: chiaraView)
                            }
                    }
                }
            }
            .onAppear {
                // 위치 정보 접근 권한 요청을 합니다.
                locationManager.requestLocation()
                
                // 실시간 배수구 정보를 받아옵니다.
                streetDrainManager.listenToRealtimeDatabase()
            }
            .environmentObject(locationManager)
            .environmentObject(streetDrainManager)
            .environmentObject(routerManager)
            .environmentObject(cameraViewModel)
            .tint(.black)
        }
    }
}
