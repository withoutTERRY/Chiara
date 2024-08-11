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
            
            
            
        case .cleanCameraView(let streetDrain):
            CleanCameraView(streetDrain: streetDrain)
        case .coreModelCheckView(let streetDrain, let image):
            CoreModelCheckView(streetDrain: streetDrain,
                               image: image)
        case .cleanSuccessView:
            CleanSuccessView()
            
         
            
        case .cameraView:
            CameraView()
        case .coreModelProcessView(let image):
            CoreModelProcessView(image: image)
        case .selectLocationView(let trashType):
            SelectLocationView(trashType: trashType)
        case .uploadSuccessView:
            UploadSuccessView()
            
        }
    }
    
    func push(view: ChiaraView){
        path.append(view)
    }
    
    func pop(){
        path.removeLast()
    }
    
    func backToMap(){
        self.path = NavigationPath()
        path.append(ChiaraView.mapView)
    }
}

enum ChiaraView: Hashable {
    case mapView
    
    case cleanCameraView(streetDrain: StreetDrain)
    case coreModelCheckView(streetDrain: StreetDrain, image: UIImage)
    case cleanSuccessView
    
    
    
    case cameraView
    case coreModelProcessView(image: UIImage)
    case selectLocationView(trashType: TrashType)
    
    case uploadSuccessView
    
}

