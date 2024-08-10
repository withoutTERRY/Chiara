//
//  MapViewRepresentable.swift
//  Chiara
//
//  Created by sseungwonnn on 8/10/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapViewRepresentable: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    
    @Binding var streetDrainList: [StreetDrain]
    @Binding var region: MKCoordinateRegion
    @Binding var selectedStreetDrain: StreetDrain?
    @Binding var isSheetDisplaying: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.isRotateEnabled = false
        mapView.showsCompass = false
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKPointAnnotation.self))
        
        context.coordinator.checkLocationAuthorization()
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if uiView.annotations.isEmpty {
            let annotations = streetDrainList.compactMap { streetDrain -> CustomAnnotation in
                CustomAnnotation(title: streetDrain.address, coordinate: CLLocationCoordinate2D(latitude: streetDrain.latitude, longitude: streetDrain.longitude))
            }
            uiView.addAnnotations(annotations)
        } else {
            uiView.removeAnnotations(uiView.annotations)
            let resultAnnotation = streetDrainList.compactMap { streetDrain -> CustomAnnotation in
                CustomAnnotation(title: streetDrain.address, coordinate: CLLocationCoordinate2D(latitude: streetDrain.latitude, longitude: streetDrain.longitude))
            }
            
            uiView.addAnnotations(resultAnnotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func ImageFromCenterType() -> (String, CGSize, CGRect) {
        return ("StreetDrainMapPin", CGSize(width: 41, height: 31), CGRect(x: 0, y: 0, width: 41, height: 31))
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapViewRepresentable
        var locationManager = CLLocationManager()
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
            locationManager.delegate = self
        }
        
        func checkLocationAuthorization() {
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            parent.region = region
            locationManager.stopUpdatingLocation()
            
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            guard let customAnnotation = annotation as? CustomAnnotation else { return nil }
            
            let identifier = "CustomAnnotation"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if view == nil {
                view = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            } else {
                view?.annotation = customAnnotation
            }
            
            view?.canShowCallout = false
            view?.isEnabled = true
            
            let pinConfig = parent.ImageFromCenterType()
            
            if let pinImage = UIImage(named: pinConfig.0) {
                let size = pinConfig.1
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                pinImage.draw(in: CGRect(origin: .zero, size: size))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                view?.image = resizedImage
            }
            
            view?.frame = pinConfig.2
            view?.centerOffset = CGPoint(x: 0, y: -view!.frame.size.height / 2)
            view?.isUserInteractionEnabled = true
            
            return view
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let customAnnotation = view.annotation as? CustomAnnotation {
                if let streetDrain = parent.streetDrainList.first(where: {$0.address == customAnnotation.title}) {
                    parent.selectedStreetDrain = streetDrain
                    parent.isSheetDisplaying = true
                    
                    // Update currentLocation and currentAddress using LocationManager
                   let location = CLLocation(latitude: streetDrain.latitude, longitude: streetDrain.longitude)
//                   parent.locationManager.convertLocationToAddress(location: location) { [weak self] address in
//                       guard let self = self else { return }
//                       DispatchQueue.main.async {
//                           self.parent.locationManager.currentLocation = location
//                           self.parent.locationManager.currentPlace = address ?? "Address not found"
//                       }
//                   }
                    parent.locationManager.convertLocationToAddress(location: location)
                }
                
                UIView.animate(withDuration: 0.3) {
                    view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    view.zPriority = .max
                }
                
                mapView.setCenter(customAnnotation.coordinate, animated: true)
            }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            UIView.animate(withDuration: 0.3) {
                view.transform = .identity
                view.zPriority = .defaultUnselected
            }
            
            parent.isSheetDisplaying = false
        }
        
        // MARK: - 제주도 밖으로 지도가 이동하지 않게 하는 메소드
        //        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //            let jejuCenter = CLLocationCoordinate2D(latitude: 33.3628, longitude: 126.5334)
        //            let jejuRegionRadius: CLLocationDistance = 75000
        //            let jejuRegion = MKCoordinateRegion(center: jejuCenter, latitudinalMeters: jejuRegionRadius * 2, longitudinalMeters: jejuRegionRadius * 2)
        //
        //            if !jejuRegion.contains(mapView.centerCoordinate) {
        //                mapView.setRegion(jejuRegion, animated: true)
        //            }
        //        }
    }
}

extension Color {
    func uiColor() -> UIColor {
        let components = self.cgColor?.components
        return UIColor(red: components?[0] ?? 0, green: components?[1] ?? 0, blue: components?[2] ?? 0, alpha: components?[3] ?? 1)
    }
}

extension MKCoordinateRegion {
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let spanHalfLat = self.span.latitudeDelta / 2.0
        let spanHalfLon = self.span.longitudeDelta / 2.0
        
        let minLat = self.center.latitude - spanHalfLat
        let maxLat = self.center.latitude + spanHalfLat
        let minLon = self.center.longitude - spanHalfLon
        let maxLon = self.center.longitude + spanHalfLon
        
        return (minLat...maxLat).contains(coordinate.latitude) && (minLon...maxLon).contains(coordinate.longitude)
    }
}
