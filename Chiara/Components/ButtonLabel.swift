//
//  ButtonLabel.swift
//  Chiara
//
//  Created by sseungwonnn on 8/11/24.
//

import SwiftUI

struct ButtonLabel: View {
    var buttonText: String
    
    var isDisabled: Bool
    
    var body: some View {
        Text("\(buttonText)")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.horizontal, 26)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(isDisabled ? .lightGray : .black)
            )
    }
}

//#Preview {
//    ButtonLabel()
//}
