import SwiftUI
import MapKit
import CoreLocation

struct LocationMapViewRepresentable: UIViewRepresentable {
    @Binding var address: String
    @Binding var location: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.isRotateEnabled = false
        mapView.showsCompass = false
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) { }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: LocationMapViewRepresentable
        var locationManager = CLLocationManager()
        
        init(_ parent: LocationMapViewRepresentable) {
            self.parent = parent
            super.init()
            locationManager.delegate = self
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let center = mapView.centerCoordinate
            let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
            parent.location = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
            convertLocationToAddress(location: location)
        }

        private func convertLocationToAddress(location: CLLocation) {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Error converting coordinates to address: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    if let thoroughfare = placemark.thoroughfare, let locality = placemark.locality {
                        DispatchQueue.main.async {
                            self.parent.address = "\(placemark.locality ?? "") \(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? "")"
                        }
                    } else if let name = placemark.name {
                        DispatchQueue.main.async {
                            self.parent.address = name
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.parent.address = "주소를 찾을 수 없습니다."
                        }
                    }
                }
            }
        }
    }
}
