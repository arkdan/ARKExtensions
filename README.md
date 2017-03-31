## Tools
[DispatchTimer](https://github.com/arkdan/ARKExtensions#dispatchtimer) | [Dispatch delay](https://github.com/arkdan/ARKExtensions#delay) | [substring(Int)](https://github.com/arkdan/ARKExtensions#strings) | [Double round](https://github.com/arkdan/ARKExtensions#double) | [safe collection subscript](https://github.com/arkdan/ARKExtensions#collection) | [Operation](https://github.com/arkdan/ARKExtensions#ooperation) | [OperationQueue](https://github.com/arkdan/ARKExtensions#ooperationqueue) | [AlertController](https://github.com/arkdan/ARKExtensions#alertcontroller)

### Installation
Please use carthage:
```
github "arkdan/ARKExtensions"
```
No, seriously, use carthage, please. No pods.

### DispatchTimer

Executes a closure on specified dispatch queue, with specified time intervals, for specified number of times (optionally).
You can change the closure at any time.

`timeInterval` may also be changed, although i dn't know how that can be useful.


Built using `DispatchSourceTimer`'s `scheduleRepeating(...)`

```swift
let queue = DispatchQueue(label: "ArbitraryQueue")
let timer = DispatchTimer(timeInterval: 1, queue: queue) { timer in
    // body to execute until cancelled by timer.cancel()
}

let timer100 = DispatchTimer(timeInterval: 0.1, queue: queue, maxCount: 100) { timer in
    // will be executed 100 times, or until cancelled
}
```

### delay

Executes a closure asynchronously after `delay` seconds. Optionally pass the queue to execute on. Default `.main`

```swift
delay(2) { // executed after 2 sec, on main }

delay(2, queue: queue) { // executed after 2 sec on `queue` }

// Alternatively,
queue.delayed(2) { // execute after 2 sec }
```

### Strings

Brings back `substring()` to/from/range with `Int`s

```swift
let original = "0123456789"

var substring = original.substring(from: 1)
expect(substring) == "123456789"

substring = original.substring(to: 9)
expect(substring) == "012345678"

substring = original.substring(with: 5..<6)
expect(substring) == "5"
```

### Double
round(digits: Int) mostly for printing
```swift
let double = 0.123456789;
let rounded = double.round(2)
expect(rounded) == 0.12
```
### Collection
safe subscript - nil if out of bounds
```swift
guard let element = array[safe: 100500] else { return }
// do stuff with element
```

### OOperation

Handy asynchronous Operation (*NSOperation*) with completion reporting.

• No need to fiddle with *will set did set executing finished*... i never get it right because i'm stupid.

• No need to subclass, you can pass blocks like so:

```swift
let op = OOperation { finished in
    // do work; call finished() when done
    delay(2) { finished() }
}
```

• I dont mind subclassing though; helps me stay focused and keeps logic separated. Instead of overriding traditional `start` and playing with *executing finished* - override `execute`, call `finish()` when you're done.

```swift
class DelayOperation: OOperation {
    let delay: Double

    init(delay: Double) {
        self.delay = delay
        super.init()
    }

    override func execute() {
        // do work, then call finish()
        DispatchQueue.main.delayed(self.delay) {
            self.finish()
        }
    }
}
```

### OOperationQueue

`whenEmpty: () -> Void` called each time all operations are completed. Also, you can add blocks to the queue as a convenience - similar to `addOperation(_ block: @escaping () -> Void)`:

```swift
queue.addExecution { finished in
    delay(0.5) { finished() }
}
```

Example:

```swift
let op = OOperation { finished in
    delay(2) { finished() }
}

let delayOp = DelayOperation(delay: 3)
op.addDependency(delayOp)

let queue = OOperationQueue()
queue.addOperation(op)
queue.addOperation(delayOp)

queue.addExecution { finished in
    delay(0.5) { finished() }
}

queue.whenEmpty = {
    print("all operations finished")
}
```

### AlertController
`UIViewController` extension, with clean and simple syntax for presenting alerts (UIAlertControllers). Callback when user taps either button, with `buttonIndex` as the parameter.

**The alerts queue up, fifo**. I.e. latter alers wait and don't show until user respond to former alerts.

```swift
UIViewController.presentAlert(title: "Title",
                              message: "message",
                              cancelButtonTitle: "Cancel",
                              otherButtonTitles: ["button1", "button2"]) { (buttonIndex) in
    // called when user taps either button
    switch buttonIndex {
    case 0:
        print("tapped Cancel")
    case 1:
        print("button 1 tapped")
    case 2:
        print("button 2")
    default:
        break
    }
}
```

For simple 1-button alerts,

```swift
UIViewController.presentAlert(title: "Title", message: "message", cancelButtonTitle: "OK")
```