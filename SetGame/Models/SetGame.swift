//
//  SetGame.swift
//  SetGame
//
//  Created by Matthew Braniff on 3/27/24.
//

import Foundation

enum ShapeType: CaseIterable {
    case squiggle
    case diamond
    case capsule
}

enum ShapeColor: String, CaseIterable {
    case green = "Green"
    case blue = "Blue"
    case pink = "Pink"
}

enum ShapeStyle: CaseIterable {
    case blank
    case striped
    case filled
}

struct SetGame {
    private(set) var cards: [Card] = []
    private(set) var deck: [Card]
    private(set) var matches: [Card] = []
    private(set) var score = 0

    private var selectedCards: Set<Card> = []
    
    var cardsSelectable = true
    var resetCards: (([Card]) -> Void)?
    
    init() {
        deck = ShapeType.allCases
                .distribute([1,2,3])
                .distribute(ShapeColor.allCases)
                .distribute(ShapeStyle.allCases)
                .map { args in
                    let (((shapeType, shapeCount), shapeColor), shapeStyle) = args
                    return Card(shape: shapeType, shapeCount: shapeCount, color: shapeColor, style: shapeStyle, id: UUID().hashValue)
                }
        startNewGame()
    }
    
    // MARK: - Intents
    
    mutating func startNewGame() {
        score = 0
        selectedCards.forEach {
            guard let index = cards.firstIndex(of: $0) else { return }
            
            cards[index].selected = false
        }
        selectedCards.removeAll()
        
        deck.append(contentsOf: cards)
        deck.append(contentsOf: matches)
        
        
        cards.removeAll()
        matches.removeAll()
        
        deck.shuffle()
        
        for _ in 0..<12 {
            if let last = deck.popLast() {
                cards.append(last)
            }
        }
    }
    
    mutating func dealMore() {
        guard !deck.isEmpty else { return }
        
        for _ in 0..<3 {
            if let last = deck.popLast() {
                cards.append(last)
            }
        }
    }
    
    mutating func select(_ card: Card) {
        guard cardsSelectable, let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        if selectedCards.contains(card) {
            selectedCards.remove(card)
        } else {
            selectedCards.insert(card)
        }
        
        cards[index].selected.toggle()
        
        if selectedCards.count == 3 {
            cardsSelectable = false
            guard let first = selectedCards.popFirst(),
                  let second = selectedCards.popFirst(),
                  let third = selectedCards.popFirst() else { return }
            
            if isSet(first, second, third) {
                cardsSelectable = true
                cards.removeAll(where: { $0 == first || $0 == second || $0 == third })
                matches.append(contentsOf: [first, second, third])
                score += 1
                dealMore()
            } else {
                score -= 1
                resetCards?([first, second, third])
            }
            
        }
        
    }
    
    mutating func reset(_ cards: [Card]) {
        let indexes = cards.compactMap { searchCard in
            self.cards.firstIndex(where: { $0.id == searchCard.id })
        }
        
        indexes.forEach { self.cards[$0].selected = false }
    }
    
    // MARK: - Private
    
    private func isSet(_ a: Card, _ b: Card, _ c: Card) -> Bool {
        return isSet(a, b, c, on: \.shape) &&
        isSet(a, b, c, on: \.shapeCount) &&
        isSet(a, b, c, on: \.color) &&
        isSet(a, b, c, on: \.style)
    }
    
    // Logic is for any feature of the card they must satisfy (a xor b * a xor c * b xor c) + abc. If any feature is different between two cards, then it must be different between all 3, if any feature is the same between two cards then it must be the same between all 3 cards
    private func isSet<T: Equatable>(_ a: Card, _ b: Card, _ c: Card, on keyPath: KeyPath<Card, T>) -> Bool {
        return (a[keyPath: keyPath] != b[keyPath: keyPath] && a[keyPath: keyPath] != c[keyPath: keyPath] && b[keyPath: keyPath] != c[keyPath: keyPath]) || (a[keyPath: keyPath] == b[keyPath: keyPath] && b[keyPath: keyPath] == c[keyPath: keyPath])
    }
    
    struct Card: Hashable {
        let shape: ShapeType
        let shapeCount: Int
        let color: ShapeColor
        let style: ShapeStyle
        var selected: Bool = false
        let id: Int
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func ==(lhs: Card, rhs: Card) -> Bool {
            lhs.id == rhs.id
        }
    }
}

extension Collection {
    func distribute<Other: Collection>(_ other: Other) -> [(Self.Element, Other.Element)] {
        var result: [(Self.Element, Other.Element)] = []
        other.forEach { otherValue in
            self.forEach {
                result.append(($0, otherValue))
            }
        }
        return result
    }
}
