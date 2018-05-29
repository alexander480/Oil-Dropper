//
//  HeatVC.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/21/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import UIKit

class HeatVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let temps = ["30", "32", "34", "36", "38", "40"]
    
    @IBOutlet weak var tempPicker: UIPickerView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var onButton: UIButton!
    @IBAction func onAction(_ sender: Any) {
        if blu.peripheral == nil { self.statusLabel.text = "Please Connect Device" }
        else { let row = self.tempPicker.selectedRow(inComponent: 0); blu.sendInquiry(ValueToSend: temps[row], Closure: { (value) in }) }
    }
    
    @IBOutlet weak var offButton: UIButton!
    @IBAction func offAction(_ sender: Any) {
        if blu.peripheral != nil { blu.sendInquiry(ValueToSend: "i", Closure: { (value) in }); self.statusLabel.text = "Heater OFF" }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if blu.peripheral != nil {
            blu.sendInquiry(ValueToSend: "i", Closure: { (value) in
                if value.isEmpty { self.statusLabel.text = "Heater OFF" }
                else { self.statusLabel.text = "Heater ON" }  })
        }
        
        self.tempPicker.delegate = self
        self.tempPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return temps.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return temps[row] + "ºC" }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if statusLabel.text == "Heater ON" {
            let row = self.tempPicker.selectedRow(inComponent: 0);
            if blu.peripheral != nil { blu.sendInquiry(ValueToSend: temps[row], Closure: { (value) in }) }
        }
    }
}



