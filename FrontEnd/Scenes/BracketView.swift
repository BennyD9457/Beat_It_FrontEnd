//
//  BracketView.swift
//  FrontEnd
//
//  Created by Andy Donis Paz on 12/8/24.
//

import Foundation
import SwiftUI


struct BracketView: View {
    private let columnWidth: CGFloat = UIScreen.main.bounds.width * 0.9
    private let colors: [Color] = [Color.red, Color.green, Color.blue]
    @State private var dragOffsetX: CGFloat = 0
    @State private var focusedColumnIndex: Int = 0
    
    private var offsetX: CGFloat {
        -CGFloat(focusedColumnIndex) * columnWidth + dragOffsetX
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            columns.offset(x: offsetX)
        }
        .frame(width: UIScreen.main.bounds.size.width)
        .scrollDisabled(true)
        .gesture(DragGesture(minimumDistance: 12, coordinateSpace: .global)
            .onChanged(updateCurrentOffsetX)
            .onEnded(handleDragEnded)
        )
    }
    
    private var columns: some View {
        HStack(spacing: 0) {
            ForEach(colors, id: \.hashValue) { color in
                color
                    .frame(width: columnWidth)
            }
        }
        .frame(width: CGFloat(colors.count) * columnWidth)
    }
    
    private var numberOfColumns: Int {
            colors.count
        }
    
    private func updateCurrentOffsetX(_ dragGestureValue: DragGesture.Value) {
        dragOffsetX = dragGestureValue.translation.width
    }

    private func moveToLeft() {
        withAnimation {
            focusedColumnIndex -= 1
            dragOffsetX = 0
        }
    }
    
    private func moveToRight() {
        withAnimation {
            focusedColumnIndex += 1
            dragOffsetX = 0
        }
    }

    private func stayAtSameIndex() {
        withAnimation {
            dragOffsetX = 0
        }
    }
    
    private func handleDragEnded(_ gestureValue: DragGesture.Value) {
        let isScrollingRight = dragOffsetX < 0
        
        let didScrollEnough = abs(gestureValue.translation.width) > columnWidth * 0.5
        
        let isFirstColumn = focusedColumnIndex == 0
        let isLastColumn = focusedColumnIndex == numberOfColumns - 1
        
        guard didScrollEnough else {
            return stayAtSameIndex()
        }
        
        if isScrollingRight, !isLastColumn {
            moveToRight()
            
        } else if !isScrollingRight, !isFirstColumn {
            moveToLeft()
            
        } else {
            stayAtSameIndex()
        }
    }

}

struct BracketView_Previews: PreviewProvider {
    static var previews: some View {
        BracketView()
    }
}

