# SwiftUI - `View` rendering
## The relationship between `@State` and re rendering a `View`'s body
We already know that if we want to have a mutable variable inside of a `View` we need to define it with a property wrapper like `@State`, since all `View`s in SwiftUI are structs, making all the variables inside them immutable. But we can use the `@State` wrapper for more than just having a mutable value.
```Swift
import SwiftUI  
struct ContentView: View {  
	@State private var counter: Int = 0 
	var body: some View {  
		VStack {  
			Text("Counter: \(counter)")  
			Button {  
				counter += 1  
			} label: {  
				Text("Counter +1")  
			}  
		}  
		.padding()    
	}
}
```
Here we have a simple `View` that has a state, a text and a button. The interesting question here is wether changing the `counter` state re renders our `View`. In this case it must, because if it didn't then we won't see the text `Text("Counter: \(counter)")` change whenever the `counter` changes.
In short, will `ContentView` re render when `counter` changes? YES
But a more interesting question is if the code below re renders when the counter changes.
```Swift
import SwiftUI  
struct ContentView: View {  
	@State private var counter: Int = 0 
	var body: some View {  
		VStack {  
			//Text("Counter: \(counter)")  
			Button {  
				counter += 1  
			} label: {  
				Text("Counter +1")  
			}  
		}  
		.padding()  
	}
}
```
As you can see we just commented `Text("Counter: \(counter)")` out, meaning that we have a state in `counter` and we change it when the button is tapped, but no one is observing its changes. 
Will `ContentView` re render when `counter` changes? NO
## The relationship between `ObservableObject` and re rendering a `View`'s body
So we have seen what happens with the relationship between `@State` and re rendering a `View`'s body but what happens when we use `ObservableObject`?
```Swift
import SwiftUI  

class ContentViewModel: ObservableObject {
	@Published var counter: Int = 0
}

struct ContentView: View {  
	@StateObject private var ViewModel: ContentViewModel = ContentViewModel()
	var body: some View {  
		VStack {  
			Button {  
				ViewModel.counter += 1  
			} label: {  
				Text("Counter +1")  
			}  
		}  
		.padding()  
		}  
	}
}
```
We can see here that we switched the simple `@State` with a `@StateObject` that holds a `@Published` variable within it, but we can also see that no one observes the `@Published` counter.
Will changing `counter` within `ContentViewModel` re render `Content`View``? YES
So we can see that unlike `@State`, `ObserveableObject` does re render the `View` holding it wether you observe its `@Published` variables or not.

*Side note: In iOS 17 the* `@Observation` *modifier was added, but unlike* `ObservableObject` *It does NOT re render on every change of a* `@Published` *variable within. Instead it works like the* `@State` *wrapper, like we saw in* [The part about `@State`](##-The-relationship-between-`@State`-and-re-rendering-a-`View`'s-body).
## A little SwiftUI under the hood
So how does SwiftUI know how to re render `View`s, and what `View`s should be replaced with new ones?
It basically follows these steps:
1. SwiftUI receives a change it the state that requires a re render (Like we saw in [The section about `@State`](##The-relationship-between-`@State`-and-re-rendering-a-`View`'s-body) or [The section about `ObservableObject`](##-The-relationship-between-`ObservableObject`-and-re-rendering-a-`View`'s-body)).
2. SwiftUI creates some data for the **state** of the new possible `View`s that might be created.
	- This data is an amalgamation of the state of the `View`, meaning the variables within it, wether they have property wrapper like `@State` or not. This means that if a `View` has an `Int` or a `[String]` within it, they will be included in that data that is created for comparison.
3. SwiftUI checks wether the **state** of `View`s that are already in the hierarchy is **equal** to the ones it wants to add.
	- If they **are equal**: SwiftUI keeps the `View`s that are in the hierarchy without making changes and it throws the data it created in step 2 to the trash.
	- If they **are NOT equal**: SwiftUI calls the body of the `View`s that have changed again, this time with the new data it created in step 2 and it re renders them.
Remember that every body of every `View` holds more `View`s inside it, making this a recursive thing that digs deeper and deeper every time.
### How to improve performance with that knowledge
#### Rule 1: Keep your `View`'s body as simple as possible
Since we know that the body of the `View` will be called every time it needs to re render, that means it will run all the actions in that body every time as well. Also sometimes the body is called multiple times in the layout phase, and if you have a lot of complicated actions in the body they will all get called multiple times when the `View` boots up initially.
```Swift
var body: some View {  
	List {  
		ForEach(model.values.filter { $0 > 0 }, id: \.self) {  
			Text(String($0))  
			.padding()  
			}  
		}  
	}
}
```
For example `ForEach(model.values.filter { $0 > 0 }, id: \.self) {}` is very bad since this filter will run every time the body is re rendered. 

#### Rule 2: Avoid conditional `View`s
```Swift
var body: some View {  
	VStack {  
		if isHighlighted {  
			CustomView()  
				.opacity(0.8)  
		} else {  
			CustomView()  
		}
	} 
}
```
In this case although we have the `if` statement that means only one case is rendered, SwiftUI keeps a hierarchy tree for **both** cases. This means that if `CustomView` has some complicated `View` hierarchy and conditional statements within it then SwiftUI will build a tree for it in the background.
The reason that this happens is because of the `opacity` modifier. This modifier makes SwiftUI unable to distinguish that the `View`s in the two cases are the same `View`s. It looks like this to SwiftUI:
`VStack<_ConditionalContent<ModifiedContent<CustomView, _OpacityEffect>, CustomView>>`
Notice that we have `ModifiedContent<Custom`View`, _OpacityEffect>` and `CustomView` which seem like two different `View`s to SwiftUI.

*Side note: You can print that by running* `po print(type(of: body))` *in debug when you have a breakpoint in the* `View`s *body.*

```Swift
var body: some View {  
	VStack {  
		CustomView()  
			.opacity(isHighlighted ? 0.8 : 1.0)
	} 
}
```
This basically solves cases like this.

What you mainly need to remember from this is: Even if you have two identical `View`s, they look like two different `View`s to SwiftUI once one of them has a `View` modifier.

#### Rule 3: Split parts that listen to different state to separate `View`s
```Swift
import SwiftUI  

struct ContentView: View {
    @State var topCounter: Int = 0
    @State var midCounter: Int = 0
    @State var bottomCounter: Int = 0
    var body: some View {
        VStack {
            Button {
                topCounter += 1
            } label: {
                Text("TopCounter + 1")
            }
            
            Button {
                midCounter += 1
            } label: {
                Text("midCounter + 1")
            }
            
            Button {
                bottomCounter += 1
            } label: {
                Text("bottomCounter + 1")
            }
            
            Text("\(topCounter)")
            Text("\(midCounter)")
            Text("\(bottomCounter)")
        }
        .padding()
    }
}
```
In this example we have three separate buttons that change different states of the `View`. In this example whenever any of the three counters change the whole body will re render, including the `Text`s that are not even showing the effected state.

*Side note: We can use* `Self._printChanges()` *in the `View`'s `body`, like this* 
`let _ = Self._printChanges()` *to see if it re renders and why. But for now just trust my word because I did that for you.*

We can solve this by extracting the `Text`s into their own structs. Remember what we saw at the beginning of [A little SwiftUI under the hood](#-A-little-SwiftUI-under-the-hood), what we compare is the state of the `View`. This means that if we have a `View` within the body which kept the same state as before the change SwiftUI will not re render it.
```Swift
import SwiftUI  

struct ContentView: View {
    @State var topCounter: Int = 0
    @State var midCounter: Int = 0
    @State var bottomCounter: Int = 0
    var body: some View {
        VStack {
            Button {
                topCounter += 1
            } label: {
                Text("TopCounter + 1")
            }
            
            Button {
                midCounter += 1
            } label: {
                Text("midCounter + 1")
            }
            
            Button {
                bottomCounter += 1
            } label: {
                Text("bottomCounter + 1")
            }
            
            NumberView(number: topCounter)
            NumberView(number: midCounter)
            NumberView(number: bottomCounter)
        }
        .padding()
    }
}

private struct NumberView: View {
    let number: Int
    
    var body: some View {
        Text("\(number)")
    }
}
```
Now if `topCounter` changes it will only effect the top button because the other two button's states did NOT change as a result of `topCounter` changing.

*Side note: Using* `@ViewBuilder` *or functions that return* `some View` *will not give you the same effect as creating a separate `View`. This will be the same as the first example we gave in which everything is re rendered for every state change.* We will understand why in the next section.
## Comparing `View`s
### Plain old data (POD)
Before we can understand how SwiftUI compares `View`s we have to understand what is POD. What POD means essentially is a data type that is "simple" "trivial" or bitwise copyable.
Bitwise copyable is any data structure that can be moved or copied with direct calls to `memcpy` (Its a C function) and which requires no special destroy operation. But all that is complicated and can be almost impossible to remember luckily we can solve this using the `_isPOD` function.
```Swift
struct Test {
    let test: Int
}

_isPOD(Int.self) // true
_isPOD(Float.self) // true
_isPOD(Bool.self) // true
_isPOD(Double.self) // true
_isPOD(String.self) // false
_isPOD(Test.self) // true
```
As we can see here the `_isPOD` function tells us which data types are POD and which are not. Here we have just some examples, but you can always check your own types for yourself.
### Comparing
**Important note**: <u>All of the information in this section is not from Apple's documentation, but rather and amalgamation of data that people found. This means that it might not be 100% accurate, and that it is subject to change without warning in the future!</u>
One more little thing. Look at this
```Swift
struct EmptyView: View {
	var body: some View {
		Text("Text")
		.onAppear {
			print(_isPOD(EmptyView.self)) // true
		}
	}
}
```
We can see here that ``View`` is a POD, cool right? well we will se why this is super cool in a second.
Now that we have all the ground rules set we can actually talk about the interesting part
SwiftUI uses three different ways to compare `View`s. Here they are ordered by how fast they are, the fastest one is at the top:
- **memcmp**: This is a essentially a C function for comparing memory directly. This is an incredibly fast way of checking equality because it literally comparing bits.
- **Equality**: This refers to `Equatable` in swift. This is not as fast as memcmp, but it is still very quick and much better than the last option.
	- Objects that can have memcpy used on them don't need this since the system can use memcmp internally.
- **Reflection**: This is a really slow way to compare data, as reflection usually is.
Our main takeaway here should be this:
- All POD types use **memcmp**, unless they conform to `Equatable`, then they will use **equality**
- All NON-POD types use **reflection** (Yuckie) unless they conform to `Equatable`, then they will use **equality** (Dope as hell)
So this is all cool and everything but what can we do with this? This gives us a really powerful thing in SwiftUI. Given that a `View` uses **memcpy** or **equality** we can ensure it will not re render when we don't want it to. And it also makes comparing `View`s in case they do need to change much much faster.
Lets put this all together now.
```Swift
import SwiftUI  

struct ContentView: View {  
	@State var topCounter: Int = 0
	@State var midCounter: Int = 0
	@State var bottomCounter: Int = 0
	var body: some View {  
		VStack {  
			ButtonWithCounter(counter: topCounter){ 
				topCounter += 1
			}
			
			ButtonWithCounter(counter: midCounter){ 
				midCounter += 1
			}
			
			ButtonWithCounter(counter: bottomCounter){ 
				bottomCounter += 1
			}
			
			NumberView(number: topCounter)
		}  
		.padding()  
	}
}

private struct ButtonWithCounter: View, Equatable {
	let counter: Int
	// This requiers we conform to equatable because its not POD
	let action: () -> Void 
	
	var body: some View {
		Button {  
			action()
		} label: {  
			Text("Counter: \(counter)")  
		}
	}
	
	static func == (lhs: ButtonWithCounter, rhs: ButtonWithCounter) -> Bool {
			lhs.counter == rhs.counter
	}
}

// Already POD so it does not need to conform to Equatable
private struct NumberView: View {
	let number: Int
	
	var body: some View {
		Text("\(number)")
	}
}
```
What we have here is very cool now.
- `private struct ButtonWithCounter: View, Equatable {}`: This struct contains `let action: () -> Void ` which is not POD, meaning that conforming to `Equatable` saves us from **reflection** comparison. This in turn means that this `View` will NOT re render unless the state that it observes changes.
- `private struct NumberView: View {}`: This struct is POD because it only has an `Int` inside of it (which is also POD). This means that this `View` will use **memcmp** to compare, which in return means that this `View` will NOT re render unless the state that it observes changes.

***
### Resources:
- https://medium.com/@vladislavshkodich/mastering-swiftui-are-you-really-as-good-as-you-think-40a4953f7e88
- https://github.com/swiftlang/swift-evolution/blob/main/proposals/0426-bitwise-copyable.md#transient-and-permanent
