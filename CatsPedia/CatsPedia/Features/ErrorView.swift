//
//  ErrorView.swift
//  CatsPedia
//
//  Created by José Marques on 08/11/2024.
//

import SwiftUI

struct ErrorView: View {
    let retryAction: () -> Void
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            SwiftUI.Image(systemName: "exclamationmark.triangle")
                .font(.system(size: .symbolSize))
            Text("Oops! Something went wrong 😟")

            Button("Try again") {
                retryAction()
            }
            .padding(.internalButtonPadding)
            .foregroundColor(.gray)
            .overlay(RoundedRectangle(cornerRadius: .cornerRadius)
                .stroke(.gray, lineWidth: 1)
            )

        }
        .frame(alignment: .top)
    }
}

private extension CGFloat {
    static let symbolSize = 70.0
    static let internalButtonPadding = 8.0
    static let cornerRadius = 10.0
}

#Preview {
    ErrorView(retryAction: { })
}
