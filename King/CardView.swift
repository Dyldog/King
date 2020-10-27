//
//  CardView.swift
//  King
//
//  Created by Dylan Elliott on 27/10/20.
//

import SwiftUI

struct CardView<Content: View>: View {
    var color: Color
    var content: () -> Content
    
    var body: some View {
        VStack {
            VStack {
                content()
            }
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(color)
        )
    }
}
