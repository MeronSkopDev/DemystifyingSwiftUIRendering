//
//  Example8.swift
//  DemystifyingSwiftUIRendering
//
//  Created by Meron Skop on 25/07/2024.
//

import SwiftUI

//MARK: Plain Old Data (POD)

struct Example8: View {
    
    /// **The State**
    let integer: Int = 0
    let floatingPoint: Float = 0.0
    /// Do you guys know about the Mantissa? IEEE 754?
    let mantissaFloatingPoint: Double = 0.0
    let character: Character = "a"
    let string: String = "What do you think I am?"
    @State var stateInteger: Int = 0
    
    /// Just inner definitions
    struct WhatDoYouThinkIAm {
        
    }
    
    struct WhatDoYouThinkIAmReally {
        let integer: Int = 0
    }
    
    struct WhatDoYouThinkIAmGoneWild {
        let string: String = "We goin crazy now"
    }
    
    class WhatDoYouThinkIAmGoneWildAfterMidnight {
        
    }
    
    struct WhatDoYouThinkIAmGonePositivelyInsanelyDemented: View {
        var body: some View { VStack { } }
    }
    
    var body: some View {
        VStack{}
            .onAppear {
                print("integer: ", _isPOD(Int.self))
                print("float: ", _isPOD(Float.self))
                print("Mantissa: ", _isPOD(Double.self))
                print("Char: ", _isPOD(Character.self))
                print("String: ", _isPOD(String.self))
                print("State: ", _isPOD(type(of: $stateInteger)))
                print("Struct: ", _isPOD(WhatDoYouThinkIAm.self))
                print("StructWithData: ", _isPOD(WhatDoYouThinkIAmReally.self))
                print("StructWithData2: ", _isPOD(WhatDoYouThinkIAmGoneWild.self))
                print("Class: ", _isPOD(WhatDoYouThinkIAmGoneWildAfterMidnight.self))
                print("View: ", _isPOD(WhatDoYouThinkIAmGonePositivelyInsanelyDemented.self))
                print("Example8: ", _isPOD(Example8.self))
            }
    }
    
    // TODO: Lets talk about memcmp, Equatable and Reflection
        /// This explains `Example6` and `Example7` isn't that sick?
        /// This also comes together with the explanation in 
    // TODO: Close the console before the next example -> Example9
}

#Preview {
    Example8()
}
