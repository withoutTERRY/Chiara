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
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4996213, longitude: 126.5311884),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var selectedStreetDrain: StreetDrain?
    
    @State private var isSheetDisplaying: Bool = false
    
    @State private var currentSheetHeight: CGFloat = 0.05 // 초기 높이 설정
        
    let initialSheetHeight: CGFloat = 0.05 // 초기 높이 값 설정
    let sheetHeightsArray = Array(stride(from: 0.45, through: 0.8, by: 0.001))
    let sheetHeights = Set(stride(from: 0.45, through: 0.8, by: 0.001).map { PresentationDetent.fraction($0) })
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
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
                                     isSheetDisplaying: $isSheetDisplaying)
                .edgesIgnoringSafeArea(.all)
                .sheet(isPresented: $isSheetDisplaying, onDismiss: {
                    // Sheet가 닫힐 때 HStack을 초기 상태로 복귀
                    withAnimation {
                        currentSheetHeight = initialSheetHeight
                    }
                }) {
                    if #available(iOS 16.4, *) {
                        StreetDrainSheetView(isSheetDisplaying: $isSheetDisplaying)
                            .presentationDetents(sheetHeights,
                                                 selection: Binding(get: {
                                                        PresentationDetent.fraction(currentSheetHeight)
                                                    },
                                                    set: { newDetent in
                                                        // 부드러운 애니메이션 추가
                                                        withAnimation {
                                                            if let fractionValue = sheetHeightsArray.first(where: {
                                                                PresentationDetent.fraction($0) == newDetent
                                                            }) {
                                                                currentSheetHeight = fractionValue
                                                            }
                                                        }
                                                    }
                                                ))
                            .presentationDragIndicator(.visible)
                            .presentationCornerRadius(15)
                            .onAppear {
                                // Sheet가 나타날 때 초기 위치로 설정
                                withAnimation {
                                    currentSheetHeight = 0.45
                                }
                            }
                    } else {
                        StreetDrainSheetView(isSheetDisplaying: $isSheetDisplaying)
                            .presentationDragIndicator(.visible)
                            .presentationDetents([.medium])
                    }
                }
                
                // 화면 그리기
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
                .padding(.bottom, geo.size.height * currentSheetHeight + 5) // sheetHeight에 따른 bottom padding 조정
                .padding(.horizontal, 20)
                .animation(.easeInOut, value: currentSheetHeight) // 애니메이션 적용
            }
        }
    }
}

