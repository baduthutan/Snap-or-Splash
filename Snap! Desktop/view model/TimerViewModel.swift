//
//  TimerViewModel.swift
//  Snap! Desktop
//
//  Created by vin chen on 23/05/24.
//

import Foundation

@Observable
class TimerViewModel {
    var countDown: Double = 0.0
    private var timer: DispatchSourceTimer?
    init() {
        startTimer()
    }
    var integralCount: Int {
            return Int(countDown)
        }
    private func startTimer() {
        guard timer == nil else { return }
        let queue = DispatchQueue(label: "com.app.snap", qos: .userInteractive)
                timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        timer?.schedule(deadline: .now(), repeating: 0.1)
                timer?.setEventHandler {
                    DispatchQueue.main.async {
                        self.countDown += 0.1
                            if self.countDown >= 8 {
                                self.stopTimer()
                            }
                    }
                }
        timer?.resume()
    }
    
    private func stopTimer() {
        print("timerstopped")
        timer?.cancel()
        timer = nil
    }

}
