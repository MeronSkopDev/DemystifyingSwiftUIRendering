//
//  Example3.swift
//  DemystifyingSwiftUIRendering
//
//  Created by Meron Skop on 25/07/2024.
//

import SwiftUI

//MARK: View re rendering in relation to `ObservableObject`

class Example3ViewModel: ObservableObject {
    @Published var counter: Int = 0
}

struct Example3: View {
    
    /// **The state**
    /// This will work essentially the same with the other observing wrappers
    @StateObject var viewModel = Example3ViewModel()
    
    var body: some View {
        /// Printing if the view got re rendered and by what
        /// When do you think this will print?
        let _ = Self._printChanges()
        
        VStack {
            /// Not observing the state
            // Text("Counter: \(counter)")
            Button("Counter +1") {
                /// Changing the state
                viewModel.counter += 1
            }
        }
        .padding()
    }
    
    // TODO: - Lets talk about how SwiftUI compares the View's data in order to decide if it has changed and needs to be re rendered.
}

#Preview {
    Example3()
}
