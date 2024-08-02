//
//  Example5.swift
//  DemystifyingSwiftUIRendering
//
//  Created by Meron Skop on 25/07/2024.
//

import SwiftUI

// MARK: - Avoid conditional Views if you can

struct Example5: View {
    
    /// **The State**
    let isHighlighted = true
    
    var body: some View {
        /// Garbage code!
        /// To the complier this is `_ConditionalContent<Text, ModifiedContent<Text, _OpacityEffect>>`
        if isHighlighted {
            /// This is what we see
            /// To the complier this is: `Text`
            Text("This is trash")
        } else {
            /// This views gets its hierarchy tree tree computed behind the scenes,
            /// although we don't see it, because to SwiftUI this looks like a whole different View
            /// compared to the `Text` above
            /// To the complier this is: `ModifiedContent<Text, _OpacityEffect>`
            Text("This is trash")
                .opacity(0.8)
        }
        
        Text("Chefs kiss")
            .opacity(isHighlighted ? 1.0 : 0.8)
    }
}

#Preview {
    Example5()
}
