//
//  AnimatedImagePlaceholder.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 30.8.23.
//

import SwiftUI

struct AnimatedImagePlaceholder: View {
    
    let silverColor = UIColor(red: 192 / 255,  green: 192 / 255, blue: 192 / 255, alpha: 1.0)
    let tungstenColor = UIColor(red: 96 / 255,  green: 101 / 255, blue: 100 / 255, alpha: 1.0)
    
    @State var animation = false
    
    var body: some View {
        HStack {
            Image("empty")
                .resizable()
                .scaledToFit()
                .background {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(silverColor),
                            Color(tungstenColor),
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .opacity(animation ? 0.7 : 1)
                    .hueRotation(.degrees(animation ? 45 : 0))
                    
                }
                .redacted(reason: .placeholder)
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: animation)
                .onAppear {
                    animation.toggle()
                }
        }
    }
}

struct AnimatedImagePlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedImagePlaceholder()
    }
}
