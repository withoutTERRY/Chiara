//
//  RouterManager.swift
//  Chiara
//
//  Created by sseungwonnn on 8/11/24.
//


import SwiftUI

class RouterManager: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    @ViewBuilder func view(for route: ChiaraView) -> some View {
        switch route {
        case .mapView:
            MapView()
//        case .cameraView:
//            CameraView()
        }
    }
    
    func push(view: ChiaraView){
        path.append(view)
    }
    
    func pop(){
        path.removeLast()
    }
    
    func backToHome(){
        //        self.path = NavigationPath()
        path.append(ChiaraView.mapView)
    }
}

enum ChiaraView: Hashable {
    case mapView
//    case cameraView
}

