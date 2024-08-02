//
//  Example6.swift
//  DemystifyingSwiftUIRendering
//
//  Created by Meron Skop on 25/07/2024.
//

import SwiftUI

//MARK: Separating View bodies for smart re rendering

struct Example6: View {
    
    /// **The State**
    @State var counter1: Int = 0
    @State var counter2: Int = 0
    @State var counter3: Int = 0
    
    var body: some View {
        /// Printing if the view got re rendered and by what
        /// When do you think this will print?
        let _ = Self._printChanges()
        
        Button("Counter1++") {
            counter1 += 1
        }
        
        Button("Counter2++") {
            counter2 += 1
        }
        
        Button("Counter2++") {
            counter3 += 1
        }
        
        // Yuckie code!
        Text("Counter1: \(counter1)")
        Text("Counter1: \(counter2)")
        Text("Counter1: \(counter3)")
    }
}

#Preview {
    Example6()
}
