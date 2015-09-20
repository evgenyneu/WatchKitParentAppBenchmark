import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
  
  func applicationDidFinishLaunching() {
    // Activate watch connectivity session when application launches on the Watch
    activateWatchConnectivity()
  }
  
  private func activateWatchConnectivity() {
    if WCSession.isSupported() {
      let session = WCSession.defaultSession()
      session.delegate = self
      session.activateSession()
    }
  }

}
