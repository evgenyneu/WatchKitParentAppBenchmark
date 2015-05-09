import WatchKit
import Foundation
import SwiftStatistics

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
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  private func getDataFromParentApp(onReply: ()->()) {
    WKInterfaceController.openParentApplication([:]) { reply, error in
      
      if let reply = reply as? [String: String] {
        self.label.setText(reply["hi"])
      }
      
      onReply()
    }
  }
  
  private func showTiming(timeElapsed: Double) {
    saveTiming(timeElapsed)
    let elapsedFormatted = String(format: "%.1f ms", timeElapsed)
    
    if let average = Statistics.average(timingsSinceFirst) {
      let averageFormated = average == 0 ? " " : String(format: "Average: %.1f ms", average)
      
      if let standardDeviation = Statistics.standardDeviationPopulation(timingsSinceFirst) {
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
