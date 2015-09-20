import WatchKit
import Foundation
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
    
    resetBenchmark()
    measure()
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
      let averageFormated = average == 0 ? " " : formatAverage(average)
      
      if let standardDeviation = Sigma.standardDeviationPopulation(timingsSinceFirst) {
        let standardDeviationFormatted = String(format: "Deviation: %.1f ms", standardDeviation)
        labelDeviation.setText(standardDeviationFormatted)
      }
      
      labelPerformance.setText(elapsedFormatted)
      labelAverage.setText(averageFormated)
    } else {
      labelAverage.setText(elapsedFormatted)
    }
  }
  
  private func formatAverage(time: Double) -> String {
    return String(format: "Average: %.1f ms", time)
  }
  
  private func saveTiming(timeElapsed: Double) {
    numberOfMeasuresAfterFirstOne += 1
    
    // don't count the first timing as it is much slower probably because... I have not idea why.
    if numberOfMeasuresAfterFirstOne == 0 { return }
    
    timingsSinceFirst.append(timeElapsed)
  }
  
  private func resetBenchmark() {
    label.setText(" ")
    labelPerformance.setText(" ")
    labelAverage.setText(" ")
    labelDeviation.setText(" ")
    numberOfMeasuresAfterFirstOne = -1
    timingsSinceFirst = []
  }
  
  private func measure() {
    let tick = TickTock()
    getDataFromParentApp { [weak self] in
      self?.showTiming(tick.measure())
    }
  }
  
  @IBAction func onGetTimeTapped() {
    measure()
  }
  
  @IBAction func didTapResetButton() {
    resetBenchmark()
  }
}
