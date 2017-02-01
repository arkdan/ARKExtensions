# ARKExtensions

## DispatchTimer

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

## delay

Executes a closure asynchronously after `delay` seconds. Optionally pass the queue to execute on. Default `.main`

```swift
delay(2) {
    // executed after 2 sec
}

delay(2, queue: queue) {
    // executed after 2 sec on `queue`
}
```
