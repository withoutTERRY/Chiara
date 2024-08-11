//
//  MapView.swift
//  Chiara
//
//  Created by sseungwonnn on 8/10/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var routerManager: RouterManager
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4996213, longitude: 126.5311884),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var selectedStreetDrain: StreetDrain?
    @State private var isSheetDisplaying: Bool = false
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: - 메인으로 표시될 지도
                MapViewRepresentable(
                    region: Binding(
                        get: {
                            MKCoordinateRegion(
                                center: locationManager.currentGeoPoint ?? CLLocationCoordinate2D(latitude: 33.4996213, longitude: 126.5311884),
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        },
                        set: { newRegion in
                            locationManager.mapView.setRegion(newRegion, animated: true)
                        }
                    ),
                    selectedStreetDrain: $selectedStreetDrain,
                    isSheetDisplaying: $isSheetDisplaying,
                    dragOffset: $dragOffset
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // 상단 버튼
                    HStack(spacing: 0) {
                        Button {
                            routerManager.push(view: .cameraView)
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
                        }
                        
                        Spacer()
                        
                        // MARK: - 내 위치로 이동 버튼
                        Button {
                            locationManager.mapViewFocusChange()
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
                    .padding(.horizontal, 20)
                    .offset(y: isSheetDisplaying ? dragOffset.height : 0)
                    
                    // 시트
                    if isSheetDisplaying {
                        StreetDrainSheetView(streetDrain: selectedStreetDrain, isSheetDisplaying: $isSheetDisplaying)
                            .background(Color.white)
                            .cornerRadius(30)
                            .offset(y: dragOffset.height) // 시트의 초기 위치를 설정하고, 드래그에 따른 오프셋 적용
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let translation = value.translation.height
                                        
                                        if translation > 0 {
                                            dragOffset.height += translation / 10
                                        } else if translation < 0 && translation > -200 {
                                            dragOffset.height = 200
                                        }
                                    }
                                    .onEnded { value in
                                        withAnimation(.spring()) {
                                            // 드래그가 일정 거리 이상이면 시트 닫기, 그렇지 않으면 제자리로
                                            if dragOffset.height > 200 {
                                                isSheetDisplaying = false
                                            }
                                            dragOffset = .zero // 오프셋 초기화
                                        }
                                    }
                            )
                            .transition(.move(edge: .bottom)) // 시트가 나타날 때의 애니메이션
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}
