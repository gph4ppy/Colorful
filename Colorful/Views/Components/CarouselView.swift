//
//  CarouselView.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 14/01/2021.
//

import SwiftUI
import Combine

struct CarouselView<Content: View>: View {
    // MARK: Properties
    private var numberOfViews: Int
    private var content: Content
    @State private var currentIndex: Int = 0
    
    private let timer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()
    
    init(numberOfViews: Int, @ViewBuilder content: () -> Content) {
        self.numberOfViews = numberOfViews
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                self.content
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            .offset(x: CGFloat(self.currentIndex) * -geometry.size.width, y: 0)
            .animation(.spring())
            .onReceive(self.timer) { _ in
                self.currentIndex = (self.currentIndex + 1) % numberOfViews
            }
        }
    }
}
