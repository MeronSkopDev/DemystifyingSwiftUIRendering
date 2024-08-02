//
//  Example7.swift
//  DemystifyingSwiftUIRendering
//
//  Created by Meron Skop on 25/07/2024.
//

import SwiftUI

//MARK: Separating View bodies for smart re rendering

struct Example7: View {
    /// **The State**
    @State var counter1: Int = 0
    @State var counter2: Int = 0
    @State var counter3: Int = 0
    
    var body: some View {
        /// Printing if the view got re rendered and by what
        /// When do you think this will print?
        let _ = Self._printChanges()
        
        /// Are these buttons still disgusting?
        Button("Counter1++") {
            counter1 += 1
        }
        
        Button("Counter2++") {
            counter2 += 1
        }
        
        Button("Counter2++") {
            counter3 += 1
        }
        
        /// Fast and sexy code
        CounterView(counterNum: 1, number: counter1)
        CounterView(counterNum: 2, number: counter2)
        CounterView(counterNum: 3, number: counter3)
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

// TODO: Close the console before the next example -> Example8

#Preview {
    Example7()
}
