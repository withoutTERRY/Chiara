//
//  LocationManager.swift
//  Chiara
//
//  Created by sseungwonnn on 8/10/24.
//

import Foundation
import MapKit

// MARK: - 지도에서 필요한 위치 정보를 관리하는 매니저
class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    // 앱 전반에서 사용될 지도
    @Published var mapView: MKMapView = .init()
    
    // 지도의 움직임 여부를 저장하는 프로퍼티
    @Published var isChanging: Bool = false
    
    // 현재 위치의 도로명 주소를 저장하는 프로퍼티
    @Published var currentPlace: String = "위치를 선택해주세요"
    
    // 현재 위치의 좌표를 저장하는 프로퍼티
    @Published var currentGeoPoint: CLLocationCoordinate2D?
    
    // 현재 위치의 장소를 저장하는 프로퍼티
    @Published var currentLocation: CLLocation? = nil
    
    // 위치 정보 활용 권한을 나타내는 프로퍼티
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    
    var locationManager: CLLocationManager = .init()
    
    
    override init() {
        super.init()
        
        self.configureLocationManager()
    }
    
    // MARK: - 사용자의 위치 권한 여부를 확인하고 요청하거나 현재 위치 MapView를 이동하는 메서드
    func configureLocationManager() {
        mapView.delegate = self
        locationManager.delegate = self
        
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            mapView.showsUserLocation = true // 사용자의 현재 위치를 확인할 수 있도록
        }
    }
    
    // MARK: - MapView에서 화면이 이동하면 호출되는 메서드
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        DispatchQueue.main.async {
            self.isChanging = true
        }
    }
    
    // MARK: - MapView에서 화면 이동이 종료되면 호출되는 메서드
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        let location: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        self.convertLocationToAddress(location: location)
        
        DispatchQueue.main.async {
            self.isChanging = false
        }
    }
    
    // MARK: - 특정 위치로 MapView의 Focus를 이동하는 메서드
    func mapViewFocusChange() {
        print("[SUCCESS] Map Focus Changed")
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: self.currentGeoPoint ??  CLLocationCoordinate2D(latitude: 37.394776, longitude: 127.11116), span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - 사용자에게 위치 권한이 변경되면 호출되는 메서드 (LocationManager 인스턴스가 생성될 때도 호출)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            guard let location = manager.location else {
                print("[ERROR] No Location")
                return
            }
            
            self.currentGeoPoint = location.coordinate // 현재 위치를 저장하고
            self.mapViewFocusChange() // 현재 위치로 MapView를 이동
            self.convertLocationToAddress(location: location)
        }
    }
    
    // MARK: - 사용자의 위치가 변경되면 호출되는 메서드
    /// startUpdatingLocation 메서드 또는 requestLocation 메서드를 호출했을 때에만 이 메서드가 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("[SUCCESS] Did Update Locations")
        if let location = locations.last {
            self.currentLocation = location
        }
    }
    
    // MARK: - 사용자의 현재 위치를 가져오는 것을 실패했을 때 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // MARK: - location을 도로명 주소로 변환해주는 메서드
    func convertLocationToAddress(location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if error != nil {
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            
            self.currentPlace = "\(placemark.country ?? "") \(placemark.locality ?? "") \(placemark.name ?? "")"
        }
    }
    
    // MARK: - location을 통해 도로명 주소를 받아오는 메서드
    func getAddress(with location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error in reverseGeocodeLocation: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            
            let address = "\(placemark.country ?? "") \(placemark.locality ?? "") \(placemark.name ?? "")"
            
            completion(address)
        }
    }
    
    // MARK: - 도로명 주소를 좌표로 변환해주는 메서드
    func getCoordinateFrom(address: String, completion: @escaping (_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(nil, error)
            } else if let placemarks = placemarks, let placemark = placemarks.first {
                let location = placemark.location
                completion(location?.coordinate, nil)
            } else {
                completion(nil, nil)
            }
        }
    }

    func requestLocation() {
        locationManager.startUpdatingLocation()
        
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        return currentLocation?.coordinate
    }
    
    func openDirections(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, for name: String) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destinationMapItem
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { response, error in
            guard (response?.routes.first) != nil else { return }
            
            let mapItem = MKMapItem(placemark: destinationPlacemark)
            mapItem.name = name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
}

