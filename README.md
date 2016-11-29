# Observable
Simplified Swift pub/sub wrapper for NotificationCenter.

## Try it out!

Clone or download this repo and simply open the `Observable.playground` in Xcode to try it out.

## Usage

### Observable object

```swift
struct Television: Observable {
    
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

### Observer object

```swift
class TelevisionWatcher {
    
    private let tv = Television()
    
    init() {
        // Block example
        tv.subscribe(to: .poweredOn) { (notification) in
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
