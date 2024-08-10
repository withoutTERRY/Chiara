//
//  CustomAnnotation.swift
//  Chiara
//
//  Created by sseungwonnn on 8/10/24.
//

import SwiftUI
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
    }
}

class CustomAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? CustomAnnotation else { return }
            
            let pinConfig = (superview?.superview as? MapViewRepresentable)?.ImageFromCenterType() ?? ("", CGSize.zero, CGRect.zero)
            
            if let pinImage = UIImage(named: pinConfig.0) {
                let size = pinConfig.1
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                pinImage.draw(in: CGRect(origin: .zero, size: size))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                self.image = resizedImage
            }
            
            self.frame = pinConfig.2
            self.centerOffset = CGPoint(x: 0, y: -self.frame.size.height / 2)
        }
    }
}
