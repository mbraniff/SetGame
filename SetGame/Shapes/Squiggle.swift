//
//  Squiggle.swift
//  SetGame
//
//  Created by Matthew Braniff on 3/27/24.
//

import SwiftUI

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        let widthOffset = rect.width * 0.25
        let heightOffset = rect.height
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + heightOffset))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                      control1: CGPoint(x: rect.midX - widthOffset, y: rect.minY - heightOffset),
                      control2: CGPoint(x: rect.midX + widthOffset, y: rect.minY + heightOffset))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - heightOffset))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY),
                      control1: CGPoint(x: rect.midX + widthOffset, y: rect.maxY + heightOffset),
                      control2: CGPoint(x: rect.midX - widthOffset, y: rect.maxY - heightOffset))
        path.closeSubpath()
        return path
    }
}

extension Shape where Self == Squiggle {
    static var squiggle: Squiggle { Squiggle() }
}
