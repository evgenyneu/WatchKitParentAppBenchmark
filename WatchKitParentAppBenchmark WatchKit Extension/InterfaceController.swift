import WatchKit
import Foundation
import SigmaSwiftStatistics
import WatchConnectivity

class InterfaceController: WKInterfaceController {

  @IBOutlet weak var label: WKInterfaceLabel!
  @IBOutlet weak var labelPerformance: WKInterfaceLabel!
  @IBOutlet weak var labelAverage: WKInterfaceLabel!
  @IBOutlet weak var labelDeviation: WKInterfaceLabel!
  
  private var numberOfMeasuresAfterFirstOne: Double = -1
  private var timingsSinceFirst = [Double]()
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    label.setText(" ")
    labelPerformance.setText(" ")
    labelAverage.setText(" ")
    labelDeviation.setText(" ")
  }
  
  private func getDataFromParentApp(onReply: ()->()) {
    if WCSession.isSupported() {
      let session = WCSession.defaultSession()
      
      session.sendMessage(["my key":"my value"], replyHandler: { reply in
        if let reply = reply as? [String: String] {
          self.label.setText(reply["hi"])
        }
  
        onReply()
      
      }, errorHandler: nil)
    }
  }
  
  private func showTiming(timeElapsed: Double) {
    saveTiming(timeElapsed)
    let elapsedFormatted = String(format: "%.1f ms", timeElapsed)
    
    if let average = Sigma.average(timingsSinceFirst) {
      let averageFormated = average == 0 ? " " : String(format: "Average: %.1f ms", average)
      
      if let standardDeviation = Sigma.standardDeviationPopulation(timingsSinceFirst) {
        let standardDeviationFormatted = String(format: "Deviation: %.1f ms", standardDeviation)
        labelDeviation.setText(standardDeviationFormatted)
      }
      
      labelPerformance.setText(elapsedFormatted)
      labelAverage.setText(averageFormated)
    }
  }
  
  private func saveTiming(timeElapsed: Double) {
    numberOfMeasuresAfterFirstOne += 1
    
    // don't count the first timing as it is much slower probably because... I have not idea why.
    if numberOfMeasuresAfterFirstOne == 0 { return }
    
    timingsSinceFirst.append(timeElapsed)
  }
  
  @IBAction func onGetTimeTapped() {
    let tick = TickTock()
    getDataFromParentApp { [weak self] in
      self?.showTiming(tick.measure())
    }
  }
}
