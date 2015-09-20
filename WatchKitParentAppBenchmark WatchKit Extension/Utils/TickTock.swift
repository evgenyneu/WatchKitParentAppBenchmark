//  
//  Measures code execution time.
//
//  Usage:
//
//    let timer = iTickTock()
//    ... code to measure execution time for
//    timer.output()
//
//    Output: [TOCK] 10.2 ms
//

import Foundation

public class TickTock {
  var startTime:NSDate

  public init() {
    startTime = NSDate()
  }

  public func measure() -> Double {
    return Double(Int(-startTime.timeIntervalSinceNow * 10000)) / 10
  }

  public func formatted() -> String {
    let elapsedMs = measure()
    return String(format: "%.1f", elapsedMs)
  }

  public func formattedWithMs() -> String {
    return "[TOCK] \(formatted()) ms"
  }

  public func output() {
    print(formattedWithMs())
  }
}
