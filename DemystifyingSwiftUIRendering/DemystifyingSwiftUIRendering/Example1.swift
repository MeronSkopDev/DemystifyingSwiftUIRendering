//
//  Example1.swift
//  DemystifyingSwiftUIRendering
//
//  Created by Meron Skop on 25/07/2024.
//

import SwiftUI

//MARK: View re rendering in relation to `@State`

struct Example1: View {
    
    /// **The State**
    @State private var counter: Int = 0
    
    var body: some View {
        /// Printing if the view got re rendered and by what
        let _ = Self._printChanges()
        
        VStack {
            /// Observing the state
            Text("Counter: \(counter)")
            Button("Counter +1") {
                /// Changing the state
                counter += 1
            }
        }
        .padding()
    }
}

#Preview {
    Example1()
}
