//
//  CoreModelLoadingView.swift
//  Chiara
//
//  Created by 추서연 on 8/11/24.
//

import SwiftUI

struct CoreModelLoadingView: View {
    var body: some View {
            VStack(alignment: .leading) {
                Image(systemName:"Loading")
                    .padding(.bottom,50)
                Text("Checking In Progress")
                    .fontWeight(.semibold)
            }
            .ignoresSafeArea()
    }
}

#Preview {
    CoreModelLoadingView()
}
