//
//  DeckView.swift
//  King
//
//  Created by Dylan Elliott on 27/10/20.
//

import SwiftUI

struct DeckView<CardType: DeckCard, CardView: View>: View {
    
    @Binding var deck: Deck<CardType>
    let content: (CardType) -> CardView
    

    var body: some View {
        ZStack {
            ForEach(deck.cards) { card in
                content(card)
                    .zIndex(self.deck.zIndex(of: card))
                    .shadow(radius: 2)
                    .offset(x: self.offset(for: card).width, y: self.offset(for: card).height)
                    .offset(y: self.deck.deckOffset(of: card))
                    .scaleEffect(x: self.deck.scale(of: card), y: self.deck.scale(of: card))
                    .rotationEffect(self.rotation(for: card))
                    .gesture(
                        DragGesture()
                            .onChanged({ (drag) in
                                if self.deck.activeCard == nil {
                                    self.deck.activeCard = card
                                }
                                if card != self.deck.activeCard {return}

                                withAnimation(.spring()) {
                                    self.deck.topCardOffset = drag.translation
                                    if
                                        drag.translation.width < -200 ||
                                            drag.translation.width > 200 ||
                                            drag.translation.height < -250 ||
                                            drag.translation.height > 250 {
                                        self.deck.moveToBack(card)
                                    } else {
                                        self.deck.moveToFront(card)
                                    }
                                }
                            })
                            .onEnded({ (drag) in
                                withAnimation(.spring()) {
                                    self.deck.activeCard = nil
                                    self.deck.topCardOffset = .zero
                                }
                            })
                )
            }
        }
    }
    
    func offset(for card: CardType) -> CGSize {
        if card != self.deck.activeCard {return .zero}
        
        return deck.topCardOffset
    }
    
    func rotation(for card: CardType) -> Angle {
        guard let activeCard = self.deck.activeCard
            else {return .degrees(0)}
        
        if card != activeCard {return .degrees(0)}
        
        return deck.rotation(for: activeCard, offset: deck.topCardOffset)
    }
}
