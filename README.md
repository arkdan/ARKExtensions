## Tools
[DispatchTimer](https://github.com/arkdan/ARKExtensions#dispatchtimer) | [Dispatch delay](https://github.com/arkdan/ARKExtensions#delay) | [substring(Int)](https://github.com/arkdan/ARKExtensions#strings) | [Double round](https://github.com/arkdan/ARKExtensions#double) | [Collection[safe: index]](https://github.com/arkdan/ARKExtensions#collection)

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
```
Alternatively,
```swift
DispatchQueue.main.delayed(2) { // execute after 2 sec }
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
