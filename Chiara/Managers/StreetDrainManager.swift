//
//  StreetDrainManager.swift
//  Chiara
//
//  Created by Eom Chanwoo on 8/10/24.
//

import Foundation
import SwiftUI
import FirebaseDatabase

// TODO: 코드 최적화

class StreetDrainManager: ObservableObject {
    static let shared: StreetDrainManager = StreetDrainManager()
    
    let ref: DatabaseReference? = Database.database().reference()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {}
    
    @Published var streetDrainList: [StreetDrain] = []
}

// MARK: - 배수구 관리 함수
extension StreetDrainManager {
    /// 데이터베이스 연결
    func listenToRealtimeDatabase() {
        guard let databasePath = ref?.child("streetDrains") else {
            return
        }
        
        // 데이터 추가 추적
        databasePath
            .observe(.childAdded) { [weak self] snapshot, _ in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else {
                    return
                }
                do {
                    let data = try JSONSerialization.data(withJSONObject: json)
                    let drain = try self.decoder.decode(StreetDrain.self, from: data)
                    if !drain.isCleaned {
                        self.streetDrainList.append(drain)
                    }
                } catch {
                    print("an error occurred", error)
                }
            }
        
        // 데이터 변경 추적
        databasePath
            .observe(.childChanged) { [weak self] snapshot, _ in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else {
                    return
                }
                do {
                    let data = try JSONSerialization.data(withJSONObject: json)
                    let updatedDrain = try self.decoder.decode(StreetDrain.self, from: data)

                    if let index = self.streetDrainList.firstIndex(where: { $0.id == updatedDrain.id }), !updatedDrain.isCleaned {
                        self.streetDrainList.remove(at: index)
                    }
                } catch {
                    print("an error occurred", error)
                }
            }

        // 데이터 삭제 추적
        databasePath
            .observe(.childRemoved) { [weak self] snapshot in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else {
                    return
                }
                do {
                    let data = try JSONSerialization.data(withJSONObject: json)
                    let removedDrain = try self.decoder.decode(StreetDrain.self, from: data)

                    if let index = self.streetDrainList.firstIndex(where: { $0.id == removedDrain.id }) {
                        self.streetDrainList.remove(at: index)
                    }
                } catch {
                    print("an error occurred", error)
                }
            }
    }
    
    /// 데이터베이스 연결 해제
    func stopListening() {
        guard let ref = ref else {
            return
        }
        
        ref.removeAllObservers()
        print("stop listening!!")
    }
    
    /// 막힌 배수구 신고하기
    func reportCloggedDrain(_ drain: StreetDrain) {
        guard let ref = ref else {
            return
        }
        
        let data: [String: Any] = [
            "id": drain.id,
            "address": drain.address,
            "latitude": drain.latitude,
            "longitude": drain.longitude,
            "trashType": drain.trashType.rawValue,
            "isCleaned": drain.isCleaned
        ]

        ref.child("streetDrains").child(drain.id).setValue(data)
    }
    
    /// 막힌 배수구 청소하기
    func cleanCloggedDrain(_ drain: StreetDrain) {
        guard let ref = ref else {
            return
        }
        
        let data: [String: Any] = [
            "isCleaned": true
        ]
        
        ref.child("streetDrains").child(drain.id).updateChildValues(data)
    }
}
