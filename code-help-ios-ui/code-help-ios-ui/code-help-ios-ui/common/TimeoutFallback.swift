//
//  TimeoutFallback.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 1.9.23.
//

import SwiftUI

struct TimeoutFallback<Content: View, FallbackContent: View>: View {
    @State private var timedOut = false
    
    let timeout: TimeInterval
    @ViewBuilder let content: () -> Content
    @ViewBuilder let fallback: () -> FallbackContent
    
    func timeOut() {
        timedOut.toggle()
    }
    
    
    var body: some View {
        if !timedOut {
            content()
                .task(priority: .background) {
                    Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { _ in
                        timeOut()
                    }
                }
        } else {
            fallback()
        }
    }
}
struct TimeoutFallback_Previews: PreviewProvider {
    static var previews: some View {
        TimeoutFallback(timeout: 2) {
            ProgressView()
                .progressViewStyle(.circular)
        } fallback: {
            Text("failed")
        }
    }
}
