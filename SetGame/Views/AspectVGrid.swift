//
//  AspectVGrid.swift
//  SetGame
//
//  Created by Matthew Braniff on 3/29/24.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio = 1.0
    var forcedMinima: CGFloat
    var content: (Item, CGFloat) -> ItemView
    
    init(_ items: [Item], aspectRatio: Double = 1.0, forcedMinima: CGFloat? = nil, @ViewBuilder content: @escaping (Item, CGFloat) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.forcedMinima = forcedMinima != nil ? forcedMinima! : 0
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = max(columnWidthForGrid(size: geometry.size), forcedMinima)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: width), spacing: 0)]) {
                    ForEach(items) { item in
                        content(item, width)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .onAppear {
                print(geometry.size)
            }
        }
    }
    
    func columnWidthForGrid(size: CGSize) -> CGFloat {
        let count = CGFloat(items.count)
        var columnCount = 1.0
        
        repeat {
            let width = size.width / columnCount
            let height = (width / aspectRatio)
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return width.rounded(.down)
            }
            
            columnCount += 1
        } while columnCount <= count
        
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
