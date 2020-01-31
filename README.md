



[**DispatchTimer**](https://github.com/arkdan/ARKExtensions#dispatchtimer) | [Dispatch delay](https://github.com/arkdan/ARKExtensions#delay) | [Double.round](https://github.com/arkdan/ARKExtensions#double) | [**Collection**](https://github.com/arkdan/ARKExtensions#collection) | [**Operation**](https://github.com/arkdan/ARKExtensions#ooperation) | [OperationQueue](https://github.com/arkdan/ARKExtensions#ooperationqueue) | [**AlertController**](https://github.com/arkdan/ARKExtensions#alertcontroller) | [**UIView constraints**](https://github.com/arkdan/ARKExtensions#uiview-constraints) | [UIColor 255](https://github.com/arkdan/ARKExtensions#uicolor-255)


### DispatchTimer

Executes a closure on specified dispatch queue, with specified time intervals, for specified number of times (optionally).
You can change the closure at any time.

`timeInterval` may be changed (although i don't know how that can be useful)


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

• safe subscript; nil if out of bounds:

```swift
if let element = array[safe: 100500] {  }
```

• property-based collection sort
Sorting array of `Model` instances by its string `id` property:

```swift
let shuffled = (0..<10).shuffled().map { Model(id: "\($0)") }

let sortedAsc = shuffled.sorted(property: { $0.id })
// [Model(id: "0"), Model(id: "1"), Model(id: "2"), ... Model(id: "9")]

let sortedDesc = shuffled.sorted(property: { $0.id }, ascending: false)
// [Model(id: "9"), Model(id: "8"), Model(id: "7"), ... Model(id: "0")]
```

• shuffle
• any item:

```swift
let random = [1, 2, 3].any() // throws exception if collection empty. Use anyItem() to be safe.
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
Better syntax for presenting alerts.

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


### UIView constraints

Easy.


• size

```swift
view.constraint(.width, 100)
view.constraint(.height, 40)
// or
view.constraint(size: (100, 40))
```

• center

```swift
let superview: UIView
superview.addSubview(view)

superview.constraint(.centerX, .centerY, subview: view)

// offset 10 points to left:
superview.constraint(.centerY, subview: view)
superview.constraint(.centerX, subview: view, -10)
```

• pinning edges

```swift
// all 4, dead
superview.constraint(.top, .bottom, .leading, .trailing, subview: view)

// 4 edges, with 10 points offset each
superview.constraint(.top, .bottom, .leading, .trailing, subview: view, 10)

// top/bottom dead, leading & trailing offset:
superview.constraint(.top, .bottom, subview: view)
superview.constraint(.leading, .trailing, subview: view, 10)
```

• siblings

```swift
let superview: UIView
let subview1 = UIView(frame: .zero)
let subview2 = UIView(frame: .zero)

superview.addSubview(subview1)
superview.addSubview(subview2)

// view1 size
subview1.constraint(.width, 100)
subview1.constraint(.height, 100)
// view one position in superview
superview.constraint(.leading, .top, subview: subview1, 50)

// view2 size
subview2.constraint(size: (20, 20))

// view2 top margin to view1 top
subview2.constraint(.top, to: .top, ofSibling: subview1)
// view2 leading 20 right from view1 trailing
subview1.constraint(.trailing, to: .leading, ofSibling: subview2, constant: 20)
```

### UIColor 255

255 instead of 0 to 1.
```swift
let color = UIColor(red255: 153, green: 102, blue: 51.0)
expect(color) == UIColor.brown
```
