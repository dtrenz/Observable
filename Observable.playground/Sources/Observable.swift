import Foundation


public protocol Observable {
    associatedtype ObservableEvent: RawRepresentable
    
    func subscribe(to event: ObservableEvent, with block: @escaping (Notification) -> Void)
    func subscribe(to event: ObservableEvent, with observer: AnyObject, selector: Selector)
    func post(_ event: ObservableEvent, with object: Any?)
}

extension Observable {
    
    private static var center: NotificationCenter {
        return NotificationCenter.default
    }
    
    
    /// Subscribe to an event on an Observable object, using a block.
    ///
    /// - Parameters:
    ///   - event: The event to subscribe to.
    ///   - block: The block to call when the event is posted.
    public func subscribe(to event: Self.ObservableEvent, with block: @escaping (Notification) -> Void) {
        guard let notificationName = notificationName(for: event) else { return }
        
        Self.center.addObserver(forName: notificationName, object: self, queue: OperationQueue.main, using: block)
    }
    
    /// Subscribe to an event on an Observable object, using an observer object and selector.
    ///
    /// - Parameters:
    ///   - event: The event to subscribe to.
    ///   - observer: The object to subscribe to the event.
    ///   - selector: The selector on the observer object to call when the event is posted.
    public func subscribe(to event: Self.ObservableEvent, with observer: AnyObject, selector: Selector) {
        guard let notificationName = notificationName(for: event) else { return }
        
        Self.center.addObserver(observer, selector: selector, name: notificationName, object: self)
    }
    
    /// Post an event; optionally, include an object associated with the event.
    ///
    /// - Parameters:
    ///   - event: The event to post.
    ///   - object: An object associated with the event that may be of use to a subscriber of the event.
    public func post(_ event: Self.ObservableEvent, with object: Any?) {
        guard let notificationName = notificationName(for: event) else { return }
        
        Self.center.post(name: notificationName, object: object)
    }
    
    private func notificationName(for event: Self.ObservableEvent) -> Notification.Name? {
        guard let eventString = event.rawValue as? String else { return nil }
        
        return Notification.Name(eventString)
    }
    
}
