import Foundation
import WatchConnectivity

///
/// Reply to WatchKit extension with a dictionary.
///
struct WatchkitCommunicator {
  static let animals = "🐨🐱🐀🐛🐋🐢🐌🐮🐗"
  
  /**
  
  Returns a dictionary with key "hi" and the value being a random animal emoji

  Example:
  
      ["hi": "🐛"]
  */
  static func reply(reply: (([String : AnyObject]) -> Void)) {
    let data = ["hi": "\(randomAnimal)"]
    reply(data)
  }
  
  private static var randomAnimal: String {
    let randomIndex = Int(arc4random_uniform(UInt32(animals.characters.count)))
    return String(animals[animals.startIndex.advancedBy(randomIndex)])
  }
  
  private static var currentTime: String {
    let formatter =  NSDateFormatter()
    formatter.dateFormat = "hh:mm:ss:SSS"
    return formatter.stringFromDate(NSDate())
  }
}