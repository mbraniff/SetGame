//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Matthew Braniff on 3/27/24.
//

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var game: SetGame
    
    init() {
        self.game = SetGame()
        
        self.game.resetCards = self.resetCards
    }
    
    var cards: [SetGame.Card] {
        game.cards
    }
    
    var cardsInDeck: Int {
        game.deck.count
    }
    
    var score: Int {
        game.score
    }
    
    func select(_ card: SetGame.Card) {
        game.select(card)
    }
    
    func newGame() {
        game.startNewGame()
    }
    
    func dealMore() {
        game.dealMore()
    }
    
    private func resetCards(cards: [SetGame.Card]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.game.reset(cards)
            self?.game.cardsSelectable = true
        }
    }
}

extension SetGame.Card: Identifiable {}
