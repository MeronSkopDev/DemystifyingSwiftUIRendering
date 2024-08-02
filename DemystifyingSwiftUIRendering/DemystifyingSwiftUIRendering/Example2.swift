//
//  Example2.swift
//  DemystifyingSwiftUIRendering
//
//  Created by Meron Skop on 25/07/2024.
//

import SwiftUI

//MARK: View re rendering in relation to `@State`

struct Example2: View {
    
    /// **The State**
    @State private var counter: Int = 0
    
    var body: some View {
        /// Printing if the view got re rendered and by what
        /// When do you think this will print?
        let _ = Self._printChanges()
        
        VStack {
            /// Not observing the state
            //Text("Counter: \(counter)")
            Button("Counter +1") {
                /// Changing the state
                counter += 1
            }
        }
        .padding()
    }
}

#Preview {
    Example2()
}
