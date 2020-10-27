//
//  Deck.swift
//  King
//
//  Created by Dylan Elliott on 27/10/20.
//

import SwiftUI

protocol DeckCard: Identifiable, Equatable {
    var text: String { get }
    var color: Color { get }
}

struct Deck<CardType: DeckCard> {

    var topCardOffset: CGSize = .zero
    var activeCard: CardType? = nil
    
    var cards: [CardType]
    
//    init(cards: Binding<[CardType]>) {
//        self._cards = cards
//    }
    
    var topCard: CardType {
        return cards[0]
    }
    
    var count: Int {
        return cards.count
    }
    
    func position(of card: CardType) -> Int {
        return cards.firstIndex(of: card) ?? 0
    }
    
    func scale(of card: CardType) -> CGFloat {
        let deckPosition = position(of: card)
        let scale = CGFloat(deckPosition) * 0.02
        return CGFloat(1 - scale)
    }
    
    func deckOffset(of card: CardType) -> CGFloat {
        let deckPosition = position(of: card)
        let offset = deckPosition * -10
        return CGFloat(offset)
    }
    
    func zIndex(of card: CardType) -> Double {
        return Double(count - position(of: card))
    }
    
    func rotation(for card: CardType, offset: CGSize = .zero) -> Angle {
        return .degrees(Double(offset.width) / 20.0)
    }
    
    mutating func moveToBack(_ state: CardType) {
        let topCard = cards.remove(at: position(of: state))
        cards.append(topCard)
    }
    
    mutating func moveToFront(_ state: CardType) {
        let topCard = cards.remove(at: position(of: state))
        cards.insert(topCard, at: 0)
    }
}
