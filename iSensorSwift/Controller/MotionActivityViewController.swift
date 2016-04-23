//
//  MotionActivityViewController.swift
//  iSensorSwift
//
//  Created by koogawa on 2016/04/10.
//  Copyright © 2016 koogawa. All rights reserved.
//

import UIKit
import CoreMotion

class MotionActivityViewController: UIViewController {

    @IBOutlet weak var stepLabel: UILabel!

    @IBOutlet weak var stationaryLabel: UILabel!
    @IBOutlet weak var walkingLabel: UILabel!
    @IBOutlet weak var runningLabel: UILabel!
    @IBOutlet weak var automotiveLabel: UILabel!
    @IBOutlet weak var unknowLabel: UILabel!

    @IBOutlet weak var confidenceLabel: UILabel!

    let pedometer = CMPedometer()
    let activityManager = CMMotionActivityManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.startStepCounting()
        self.startUpdatingActivity()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        self.pedometer.stopPedometerUpdates()
        self.activityManager.stopActivityUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Internal methods

    func startStepCounting() {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startPedometerUpdatesFromDate(NSDate(), withHandler: {
                [weak self] (data: CMPedometerData?, error: NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if data != nil && error == nil {
                        self?.stepLabel.text = "step: \(data!.numberOfSteps)"
                    }
                })
            })
        }
    }

    func startUpdatingActivity() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
                [weak self] (data: CMMotionActivity?) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if let data = data {
                    self?.stationaryLabel.text = "stationary: \(data.stationary)"
                    self?.walkingLabel.text = "walking: \(data.walking)"
                    self?.runningLabel.text = "running: \(data.running)"
                    self?.automotiveLabel.text = "automotive: \(data.automotive)"
                    self?.unknowLabel.text = "unknown: \(data.unknown)"
                    self?.confidenceLabel.text = "confidence(0-2): \(data.confidence.rawValue)"
                    }
                })
            })
        }
    }
}
