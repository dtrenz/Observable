# Observable
Simplified Swift pub/sub wrapper for NotificationCenter.

## How is this useful?
This is a very simple library, the goals of which are;

1. to create a clean & concise implementation of an observer pattern around `NotificationCenter`
1. to bind events/notifications to objects so that they are only fired during the lifetime of the object
1. to make events statically typed to avoid any issues caused by using "magic" strings (e.g. typppos)

Aside from simply adding the `Observable` protocol to the object you would like to observe, the only other implementation requirement for the `Observable` object is to declare an `ObservableEvent` enum that contains all of the events that can be observed on that object.

## Try it out!
Clone or download this repo and simply open the `Observable.playground` in Xcode to try it out.

## Usage Example

#### Observable object

```swift
struct Television: Observable {
    
    /// Declaring a String enum named `ObservableEvent` is the only implementation requirement for the Observable object.
    enum ObservableEvent: String {
        case changedChannel, poweredOff, poweredOn
    }
    
    var channel = 0 {
        didSet {
            post(.changedChannel, with: channel)
        }
    }

}
```

#### Observer object

```swift
class TelevisionWatcher {
    
    private let tv = Television()
    
    init() {
        // Block example
        tv.subscribe(to: .poweredOn) { _ in
            print("TV was powered on.")
        }
        
        // Selector example
        tv.subscribe(to: .changedChannel, with: self, selector: #selector(handleChannelChange))
    }
    
    @objc private func handleChannelChange(notification: Notification) {
        guard let channelNumber = notification.object as? Int else { return }
        
        print("The TV is now on channel \(channelNumber)")
    }
    
}
```
