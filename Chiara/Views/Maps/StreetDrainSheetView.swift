//
//  StreetDrainSheetView.swift
//  Chiara
//
//  Created by sseungwonnn on 8/10/24.
//

import SwiftUI

struct StreetDrainSheetView: View {
    @EnvironmentObject var locationManager: LocationManager

    var streetDrain: StreetDrain?
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("\(streetDrain?.address ?? "경상북도 포항시")")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(height: 60)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            // TODO: 이미지 추가 예정
            Rectangle()
                .frame(width: 200, height: 300)
            
            Button {
                // TODO: 이동 동작 추가
            } label: {
                Text("Clean It Up")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 20)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.teal)
                    }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}


#Preview {
    StreetDrainSheetView(streetDrain: StreetDrain(id: UUID().uuidString,
                                                  address: "77, Cheongam-ro, Nam-gu, Pohang-si, Gyeongsangbuk-do, Republic of Korea", latitude: 36.01403209698482, longitude: 129.32589456302887, trashType: .cigarette, isCleaned: false))
}
