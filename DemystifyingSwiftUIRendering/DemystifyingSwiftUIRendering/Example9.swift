//
//  Example9.swift
//  DemystifyingSwiftUIRendering
//
//  Created by Meron Skop on 25/07/2024.
//

import SwiftUI

//MARK: Lets use everything we learned to improve Example7 to the max!

struct Example9: View {
    /// **The State**
    @State var counter1: Int = 0
    @State var counter2: Int = 0
    @State var counter3: Int = 0
    
    var body: some View {
        /// Printing if the view got re rendered and by what
        /// When do you think this will print?
        let _ = Self._printChanges()
        
        /// Goated mewing edging code
        CounterButtonView(counterNum: 1) {
            counter1 += 1
        }
        
        CounterButtonView(counterNum: 2) {
            counter2 += 1
        }
        
        CounterButtonView(counterNum: 3) {
            counter3 += 1
        }
        
        /// Fast and sexy code
        CounterView(counterNum: 1, number: counter1)
        CounterView(counterNum: 2, number: counter2)
        CounterView(counterNum: 3, number: counter3)
    }
    
    private struct CounterButtonView: View {
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
        
    }
    
    private struct CounterView: View {
        /// **The State**
        let counterNum: Int
        let number: Int
        
        var body: some View {
            /// Printing if the view got re rendered and by what
            /// When do you think this will print?
            let _ = Self._printChanges()
            
            Text("Counter\(counterNum): \(number)")
        }
    }
}

#Preview {
    Example9()
}
