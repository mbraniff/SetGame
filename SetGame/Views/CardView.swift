//
//  CardView.swift
//  SetGame
//
//  Created by Matthew Braniff on 3/27/24.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
    
    var cardSelected: (() -> Void)?
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 15)
            let shadowOffset = card.selected ? 15.0 : 0
            base
                .fill(.white)
                .shadow(color: .gray, radius: 0, x: shadowOffset, y: shadowOffset)
            base
                .stroke()
            VStack {
                ForEach(0..<card.shapeCount, id: \.self) { _ in
                    shape
                }
            }
            .padding(.horizontal, 5)
        }
        .onTapGesture {
            cardSelected?()
        }
        .scaleEffect(card.selected ? 1.025 : 1)
        .animation(.default, value: card.selected)
    }
    
    @ViewBuilder
    var shape: some View {
        switch card.shape {
        case .capsule:
            Capsule()
                .modifierForCardContent(card.style != .blank, color: card.color, style: card.style)
        case .diamond:
            Diamond()
                .modifierForCardContent(card.style != .blank, color: card.color, style: card.style)
        case .squiggle:
            Squiggle()
                .modifierForCardContent(card.style != .blank, color: card.color, style: card.style)
        }
    }
}

extension Shape {
    func modifierForCardContent(_ isFilled: Bool, color: ShapeColor, style: ShapeStyle) -> some View {
        self
            .fill(isFilled ? Color(color, style) : .clear)
            .stroke(!isFilled ? Color(color, style) : .clear)
            .aspectRatio(3, contentMode: .fit)
    }
}

extension Color {
    fileprivate static var stripedOpacity: Double {
        0.5
    }
    
    init(_ shapeColor: ShapeColor, _ style: ShapeStyle) {
        switch shapeColor {
        case .blue:
            self = style == .striped ? .blue.opacity(Self.stripedOpacity) : .blue
        case .green:
            self = style == .striped ? .green.opacity(Self.stripedOpacity) : .green
        case .pink:
            self = style == .striped ? .pink.opacity(Self.stripedOpacity) : .pink
        }
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: self.midX, y: midY)
    }
}

struct TestView: View {
    @State var card: SetGame.Card = SetGame.Card(shape: .capsule, shapeCount: 3, color: .blue, style: .striped, id: UUID().hashValue)
    
    var body: some View {
        CardView(card: card)
        .onTapGesture {
            card.selected.toggle()
        }
    }
}

#Preview {
    VStack {
        TestView()
        TestView(card: .init(shape: .diamond, shapeCount: 2, color: .blue, style: .filled, id: UUID().hashValue))
        TestView(card: .init(shape: .capsule, shapeCount: 1, color: .blue, style: .blank, id: UUID().hashValue))
    }
    .padding()
}
