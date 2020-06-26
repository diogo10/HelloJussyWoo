//
//  ActivityIndicator.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 24/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import SwiftUI


struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                VStack {
                    ActivityIndicator(isShowing: .constant(true)).frame(width: 50, height: 50, alignment: .center)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}


struct ActivityIndicator: View {
    @State private var isAnimating: Bool = false
    @Binding var isShowing: Bool
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<5) { index in
                Group {
                    Circle()
                        .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
                        .scaleEffect(!self.isAnimating ? 1 - CGFloat(index) / 5 : 0.2 + CGFloat(index) / 5)
                        .offset(y: geometry.size.width / 10 - geometry.size.height / 2)
                }.frame(width: geometry.size.width, height: geometry.size.height)
                    .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
                    .animation(Animation
                        .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
                        .repeatForever(autoreverses: false))
            }
        }
        .aspectRatio(1, contentMode: .fit).opacity(self.isShowing ? 1 : 0)
        .onAppear {
            self.isAnimating = true
        }
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(isShowing: .constant(false))
    }
}