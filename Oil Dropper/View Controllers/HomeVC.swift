//
//  HomeVC.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/21/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import UIKit

var blu = Bluetooth()

class HomeVC: UIViewController
{
    var connectionTimer = Timer()
    var sessionTimer = Timer()
    
    var currentSession:TimeInterval = 0.0
    var sessionData = [Double]()
    
    // var testData = [0.0, 1.0, 5.0, 9.0, 12.0, 22.0, 28.0, 32.0]
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    
    @IBOutlet weak var startSessionButton: UIButton!
    @IBAction func startSessionAction(_ sender: Any) {
        if blu.peripheral == nil { self.alert(Title: "Please Connect Device", Message: nil) }
        else { self.present(self.sessionAlert(), animated: true, completion: nil) }
    }
    
    @IBOutlet weak var statButton: UIButton!
    @IBAction func statAction(_ sender: Any) {
        if let statvc = self.storyboard?.instantiateViewController(withIdentifier: "StatVC") as? StatVC {
            statvc.gsrData = sessionData
            self.present(statvc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blu = Bluetooth()
        // self.sessionData = self.testData
        
        self.progress.setProgress(0.0, animated: false)
        self.connectionTimer = Timer(timeInterval: 1.5, repeats: true, block: { (timer) in self.checkConnection() })
    }
    
    
    private func checkConnection() {
        if blu.peripheral == nil {
            if self.sessionTimer.isValid { self.sessionTimer.invalidate() }
            self.connectionLabel.text = "Disconnected"
            self.connectionLabel.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        }
        else {
            self.updateTempData()
            self.connectionLabel.text = "Connected"
            self.connectionLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
    }
    
    // Have User Select Session Duration
    private func sessionAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Session Time", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "30 Minutes", style: .default, handler: { (action) in /* Begin Session */ self.toggleSession(SessionDuration: 60.0 * 30) }))
        alert.addAction(UIAlertAction(title: "45 Minutes", style: .default, handler: { (action) in /* Begin Session */ self.toggleSession(SessionDuration: 60.0 * 45) }))
        alert.addAction(UIAlertAction(title: "60 Minutes", style: .default, handler: { (action) in /* Begin Session */ self.toggleSession(SessionDuration: 60.0 * 60) }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil) }))
        return alert
    }
    
    private func toggleSession(SessionDuration: TimeInterval?) {
        // Initialize Session //
        if let duration = SessionDuration {
            
            // Check If Connection Has Been Established //
            if blu.peripheral != nil {
                
                // Inform Peripheral of Session Initialization //
                blu.sendInquiry(ValueToSend: "y", Closure: { (value) in })
                self.startSessionButton.titleLabel?.text = "End Session"
                
                // Session Data Collection Loop //
                self.sessionTimer = Timer(timeInterval: 1.0, repeats: true, block: { (timer) in
                    
                    // Update Running Time & Progress Bar //
                    self.currentSession = self.currentSession + 1.0
                    self.progress.setProgress(Float(duration / self.currentSession), animated: true)
                    
                    // Validate Session //
                    if self.currentSession.isEqual(to: duration) { self.toggleSession(SessionDuration: nil) } else { self.updateGSRData() }
                })
            }
        }
        else {
            // Terminate Session Data Collection Loop //
            self.sessionTimer.invalidate()
            
            // Reset Running Time & Progress Bar //
            self.currentSession = 0.0
            self.progress.setProgress(0.0, animated: true)
            
            // Inform Peripheral Of Session Termination //
            if blu.peripheral != nil {
                blu.sendInquiry(ValueToSend: "z", Closure: { (value) in })
                self.startSessionButton.titleLabel?.text = "Start Session"
            }
        }
    }
    
    private func updateGSRData() {
        if blu.peripheral != nil {
            blu.sendInquiry(ValueToSend: "u", Closure: { (data) in
                if let dbl = Double(data) { self.sessionData.append(dbl) } })
        }
    }
    
    private func updateTempData() {
        if blu.peripheral != nil {
            blu.sendInquiry(ValueToSend: "x", Closure: { (data) in
                if let dbl = Double(data) { self.tempLabel.text = "Temperature: \(dbl)ºC" }
                else { self.tempLabel.text = "Temperature: --- ºC" }
            })
        }
    }
}

