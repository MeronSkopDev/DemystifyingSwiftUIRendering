//
//  Example4.swift
//  DemystifyingSwiftUIRendering
//
//  Created by Meron Skop on 25/07/2024.
//

import SwiftUI

//MARK: Avoid expensive logic in the body

class Example4ViewModel: ObservableObject {
    /// Garbage code!
    var values: [Int] {
        return [10, 20, 99, 1, 80, 70].sorted()
    }
}

struct Example4: View {
    /// **The State**
    @State var values: [Int] = [10, 20, 99, 1, 80, 70]
    @StateObject var viewModel = Example4ViewModel()
    
    var body: some View {
        /// Garbage code!
        /// This happens every time the body re renders!!!
        ForEach(values.sorted(), id: \.self) { value in
            Text("\(value)")
        }
        Spacer()
        /// Garbage code!
        /// This might be in the VM but it will also happens every time the body re renders!!!
        ForEach(viewModel.values, id: \.self) { value in
            Text("\(value)")
        }
    }
}

#Preview {
    Example4()
}
