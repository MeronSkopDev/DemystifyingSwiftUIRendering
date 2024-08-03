//
//  Example10.swift
//  DemystifyingSwiftUIRendering
//
//  Created by Meron Skop on 25/07/2024.
//

import SwiftUI

// MARK: Binding can further improve our solution. Look at how we changed CounterView. Now Example10 will not re render every time!

struct Example10: View {
    /// **The State**
    @State var counter1: Int = 0
    @State var counter2: Int = 0
    @State var counter3: Int = 0
    
    var body: some View {
        /// Printing if the view got re rendered and by what
        /// When do you think this will print?
        let _ = Self._printChanges()
        
        CounterButtonViewSolved(counterNum: 1) {
            counter1 += 1
        }
        
        CounterButtonViewSolved(counterNum: 2) {
            counter2 += 1
        }
        
        CounterButtonViewSolved(counterNum: 3) {
            counter3 += 1
        }
        
        /// Fast and sexy code
        CounterView(counterNum: 1, number: $counter1)
        CounterView(counterNum: 2, number: $counter2)
        CounterView(counterNum: 3, number: $counter3)
    }
    
    /// Goated mewing edging code
    private struct CounterButtonViewSolved: View, Equatable {
        /// **The State**
        let counterNum: Int
        let acton: () -> Void
        
        var body: some View {
            /// Printing if the view got re rendered and by what
            /// When do you think this will print?
            let _ = Self._printChanges()
            
            Button("Counter\(counterNum)++") {
                acton()
            }
        }
        
        static func == (lhs: Example10.CounterButtonViewSolved, rhs: Example10.CounterButtonViewSolved) -> Bool {
            lhs.counterNum == rhs.counterNum
        }
    }
    
    private struct CounterView: View {
        /// **The State**
        let counterNum: Int
        /// Look at this!!!
        @Binding var number: Int
        
        var body: some View {
            /// Printing if the view got re rendered and by what
            /// When do you think this will print?
            let _ = Self._printChanges()
            
            Text("Counter\(counterNum): \(number)")
        }
    }
}

#Preview {
    Example10()
}
