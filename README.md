# Sending message from Apple Watch to the main app in watchOS 2

This is a demo iOS app that shows how to send a message from WatchKit extension to the main app in watchOS 2. It uses `sendMessage` to send the message from the watch and receive results from the iOS device. The app also measures time it takes to send and receive such a message.

## How to setup connectivity between Apple Watch and iOS device

1) In your **WatchKit extension delegate**: activate connectivity session.

```Swift
import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
  func applicationDidFinishLaunching() {
    if WCSession.isSupported() {
      let session = WCSession.defaultSession()
      session.delegate = self
      session.activateSession()
    }
  }
}
```

2) In your **iOS app delegate**: activate watch connectivity and supply the delegate.

```Swift
import UIKit
import WatchConnectivity

class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    if WCSession.isSupported() {
      let session = WCSession.defaultSession()
      session.delegate = self
      session.activateSession()
    }

    return true
  }
}
```

## How to send a message from WatchKit to iOS app

1) In your **WaitchKit extension**: call `sendMessage` of `WCSession` object supplying the data to be sent to the iOS app. You can supply a closure in `replyHandler` parameter if you need to process the reply from the iOS app.

```Swift
if WCSession.isSupported() {
  let session = WCSession.defaultSession()

  let data = ["animal":"🐘"] // Data to be sent to iOS app

  session.sendMessage(data, replyHandler: { reply in
    //
    // Handle reply from iOS app (optional)
    //
  }, errorHandler: nil)
}
```

2) In your **iOS app delegate**: implement `session didReceiveMessage` method


```Swift
func session(session: WCSession, didReceiveMessage message: [String : AnyObject],
  replyHandler: ([String : AnyObject]) -> Void) {

  // 1. Handle massage from the watch here

  // 2. Send a reply (optional)

  let replyMessage = ["plan":"🌵"]
  replyHandler(replyMessage)
}
```


### Question

How much time does it take for a WatchKit extension to receive data back from the parent app?

### Answer

About 50 ms.

<br>

<img src='https://raw.githubusercontent.com/evgenyneu/WatchKitParentAppBenchmark/master/Graphics/watchkit_extension_to_parent_app_benchmark.png' alt='WatchKit extension to main app communication time' width='300'>

