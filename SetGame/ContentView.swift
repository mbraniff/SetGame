//
//  ContentView.swift
//  SetGame
//
//  Created by Matthew Braniff on 3/27/24.
//

import SwiftUI

struct ContentView: View {
    private let playingCardAspectRatio: CGFloat = 5/7
    @ObservedObject var viewModel: SetGameViewModel
    @State private var cardWidth: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                HStack {
                    Spacer()
                    Button("New Game") {
                        viewModel.newGame()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Text("Cards in Deck\n\(viewModel.cardsInDeck)")
                    .multilineTextAlignment(.center)
                
                HStack {
                    Text("Score: \(viewModel.score)")
                    Spacer()
                }
            }
            
            VStack {
                AspectVGrid(viewModel.cards, aspectRatio: playingCardAspectRatio, forcedMinima: 50) { card, width in
                    CardView(card: card) {
                        viewModel.select(card)
                    }
                    .padding(4)
                    .onAppear {
                        cardWidth = width
                    }
                }
                .animation(.default, value: cardWidth)
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(viewModel.cardsInDeck > 0 ? .blue : .clear)
                    .stroke(viewModel.cardsInDeck > 0 ? .clear : .black)
                    .aspectRatio(playingCardAspectRatio, contentMode: .fit)
                    .frame(width: cardWidth)
                    .onTapGesture {
                        viewModel.dealMore()
                    }
                    .onChange(of: cardWidth) {
                        print(cardWidth)
                    }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: SetGameViewModel())
}
