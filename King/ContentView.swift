//
//  ContentView.swift
//  King
//
//  Created by Dylan Elliott on 27/10/20.
//

import SwiftUI

enum CardValue: Int, CaseIterable, Comparable {
    static func < (lhs: CardValue, rhs: CardValue) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    case king
    case queen
    case jack
    case ten
    case nine
    case eight
    case seven
    case six
    case five
    case four
    case three
    case two
    case ace
    
    var title: String {
        switch self {
        case .king: return "King"
        case .queen: return "Queen"
        case .jack: return "Jacks"
        case .ten: return "10"
        case .nine: return "9"
        case .eight: return "8"
        case .seven: return "7"
        case .six: return "6"
        case .five: return "5"
        case .four: return "4"
        case .three: return "3"
        case .two: return "2"
        case .ace: return "A"
        }
    }
}

enum Suit: Int, CaseIterable {
    case hearts
    case diamonts
    case clubs
    case spades
    
    var color: Color {
        switch self {
        case .hearts: return .red
        case .clubs: return .black
        case .diamonts: return .blue
        case .spades: return .white
        }
    }
}

struct Card: Equatable {
    let suit: Suit
    let value: CardValue
    
    static var allCases: [Card] = Suit.allCases.flatMap { suit in
        CardValue.allCases.map { value in
            Card(suit: suit, value: value)
        }
    }
}

enum Rule {
    case floor
    case heaven
    case dicks
    case chicks
    case guys
    case lizard
    case kingsCup
    case makeARule
    case rhyme
    case categories
    case mate
    case you
    case me
    case waterfall
    case todo
    case questionMaster
    case thumbMaster
    
    var title: String {
        switch self {
        case .floor: return "Floors"
        case .lizard: return "Lizard"
        case .kingsCup: return "King's Cup"
        case .makeARule: return "Make A Rule"
        case .todo: return "TODO"
        case .heaven: return "Heaven"
        case .dicks: return "Dicks"
        case .chicks: return "Chicks"
        case .guys: return "Guys"
        case .categories: return "Categories"
        case .rhyme: return "Rhyme"
        case .mate: return "Choose A Mate"
        case .you: return "You"
        case .me: return "Me"
        case .waterfall: return "Waterfall"
        case .questionMaster: return "Question Master"
        case .thumbMaster: return "Thumb Master"
        }
    }
    
    var ruleDescription: String {
        switch self {
        case .floor:
            return "Last person to touch the floor has to drink"
        case .lizard:
            return "Last person to stick to the wall like a lizard has to drink"
        case .kingsCup:
            return """
            The first three people to draw this card must pour a third of a drink into the cup in the center

            The final person to draw the card must drink the entire cup
            """
        case .makeARule:
            return "Make a new rule, to be followed by everyone (including the person who drew the card) for the rest of the game"
        case .todo:
            return "Get of your arse, Dylan!"
        case .heaven:
            return "Last person to put their hands in the air has to drink"
        case .dicks:
            return "Guys have to drink"
        case .chicks:
            return "Girls have to drink"
        case .guys:
            return "Guys have to drink"
        case .rhyme:
            return """
            Person who drew the card chooses a word
               
            Everyone in the circle after them must take turns to come up with a rhyming word within three seconds
            
            First person to make a mistake drinks
            """
        case .categories:
            return """
            Person who drew the card chooses a category
               
            Everyone in the circle after them must take turns to come up with a word in that category within three seconds
            
            First person to make a mistake drinks
            """
        case .mate:
            return """
            The person who drew this card must choose another person who must drink every time they do
            """
        case .you:
            return "The person who drew this card must choose someone to take a drink"
        case .me:
            return "The person who drew this card must drink"
        case .waterfall:
            return "Everyone starts drinking at the same time. You are only allowed to stop drinking once the person to your left stops. Only the person who drew the card may stop before anyone else."
        case .questionMaster:
            return """
            If anyone is asked a question by the person who drew this card, they must reply with \"Fuck you\", or they must drink

            The person who drew this card keeps it until the next one is drawn
            """
        case .thumbMaster:
            return """
            If the person who drew this card places their thumb on the table, everyone must follow and the last person to do so must drink

            The person who drew this card keeps it until the next one is drawn
            """
        }
    }
}

struct CardRule: Identifiable, Comparable {
    static func < (lhs: CardRule, rhs: CardRule) -> Bool {
        return lhs.card < rhs.card
    }
    
    static func == (lhs: CardRule, rhs: CardRule) -> Bool {
        return lhs.card == rhs.card && lhs.rule == rhs.rule
    }
    
    var color: Color = .blue
    
    let card: CardValue
    let rule: Rule
    let id: UUID = .init()
    
    init(_ card: CardValue, _ rule: Rule) {
        self.card = card
        self.rule = rule
    }
    
    var text: String {
        return """
        \(card.title): \(rule.title)

        \(rule.ruleDescription)
        """
    }
    
    
}

func ruleForCard(_ card: CardValue) -> Rule {
    switch card {
    case .king: return .kingsCup
    case .queen: return .questionMaster
    case .jack: return .thumbMaster
    case .ten: return .makeARule
    case .nine: return .lizard
    case .eight: return .mate
    case .seven: return .heaven
    case .six: return .chicks
    case .five: return .guys
    case .four: return .floor
    case .three: return .me
    case .two: return .you
    case .ace: return .waterfall
    }
}

struct SuitedCardRule: DeckCard {
    var text: String = ""
    
    var color: Color { suit.color }
    
    var id = UUID()
    
    static func == (lhs: SuitedCardRule, rhs: SuitedCardRule) -> Bool {
        return lhs.rule == rhs.rule && lhs.suit == rhs.suit
    }
    
    private let cardRule: CardRule
    let suit: Suit
    
    var rule: Rule {
        return cardRule.rule
    }
    
    var value: CardValue {
        return cardRule.card
    }
    
    init(rule: CardRule, suit: Suit) {
        self.cardRule = rule
        self.suit = suit
    }
}

var gameRules: [CardRule] = CardValue.allCases.map {
    CardRule($0, ruleForCard($0))
}.shuffled()

struct ContentView: View {
    @State var showRules: Bool = false
    
    let rules: [CardRule]
    @State var deck: Deck<SuitedCardRule>
    
    init() {
        rules = gameRules
        let cards = Suit.allCases.flatMap { suit in
            gameRules.map { rule in
                SuitedCardRule(rule: rule, suit: suit)
            }
        }.shuffled()
        _deck = State(initialValue: Deck(cards: cards))
    }
    
    var body: some View {
        if showRules {
            KingRuleView(showRules: $showRules, rules: rules)
        } else {
            KingCardView(showRules: $showRules, deck: $deck)
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
