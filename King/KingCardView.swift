//
//  KingCardView.swift
//  King
//
//  Created by Dylan Elliott on 27/10/20.
//

import SwiftUI

struct KingCardView: View {
    @Binding var showRules: Bool
    @Binding var deck: Deck<SuitedCardRule>
    
    var body: some View {
        VStack {
            Spacer()
            DeckView(deck: $deck) { card in
//                Text(card.text)
//                CardView(color: .blue, content: Text("Hello"))
//
                CardView(color: card.suit.color) {
                    VStack {
                        Text(card.value.title)
                            .font(.title)
                            .foregroundColor(.white)
                            .bold()
                        Divider()
                        Spacer()
                        VStack(spacing: 20) {
                            Text(card.rule.title)
                                .font(.system(size: 20))
                                .bold()
                            Text(card.rule.ruleDescription)
                        }
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        Spacer()
                    }
                }
            }
            Spacer()
            Button(action: { showRules = true }) {
                HStack {
                    Spacer()
                    Text("Rules")
                        .padding()
                    Spacer()
                }
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
        }
    }
}
//
//struct KingCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        KingCardView()
//    }
//}
