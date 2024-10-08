//
//  StreetDrain.swift
//  Chiara
//
//  Created by sseungwonnn on 8/10/24.
//

import Foundation

struct StreetDrain: Identifiable, Codable, Hashable {
    let id: String
    
    // 도로명 주소 받아오기
    var address: String
    
    // 위도, 경도
    var latitude: Double
    var longitude: Double
    
    // 막혀 있는 쓰레기 종류
    var trashType: TrashType
    
    // 청소 되었는지
    var isCleaned: Bool
}

enum TrashType: String, Codable {
    case cigarette
    case leaf
}
