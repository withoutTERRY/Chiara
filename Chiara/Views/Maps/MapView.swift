//
//  MapView.swift
//  Chiara
//
//  Created by sseungwonnn on 8/10/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var streetDrainList: [StreetDrain]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4996213, longitude: 126.5311884),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var selectedStreetDrain: StreetDrain?
    
    @State private var selectedCleanHouse = true
    @State private var selectedRecycleCenter = true
    @State private var selectedGarbageRequest = true
    
    @State private var isSheetDisplaying: Bool = false
    
    var body: some View {
        ZStack {
            MapViewRepresentable(streetDrainList: $streetDrainList,
                                 region: $region,
                                 selectedStreetDrain: $selectedStreetDrain,
                                 isSheetDisplaying: $isSheetDisplaying)
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $isSheetDisplaying) {
                if #available(iOS 16.4, *) {
                    StreetDrainSheetView()
                        .presentationDetents([.large])
                        .presentationCornerRadius(15)
                } else {
                    StreetDrainSheetView()
                        .presentationDetents([.large])
                }
            }
            
            // 화면 그리기
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: 0) {
                        // MARK: - 하수구 추가 버튼
                        Button {
                            // TODO: Route 추가
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "trash.fill")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.gray)
                                
                                Text("Add New")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                                
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                            }
                            .padding(.all, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 90)
                                    .fill(.black)
                            }
                            // TODO: sheet 크기만큼 바텀 패딩 주기
                        }
                        
                        Spacer()
                        
                        // MARK: - 내 위치로 이동 버튼
                        Button {
                            // TODO: 내 위치로 이동
                        } label: {
                            Image(systemName: "scope")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundStyle(.black)
                                .background {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 42, height: 42)
                                }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    MapView(streetDrainList: .constant([]))
}
