//
//  PumpVC.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/21/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import UIKit

class PumpVC: UIViewController {
    @IBOutlet weak var lowButton: UIButton!
    @IBAction func lowAction(_ sender: Any) {
        if blu.peripheral == nil { self.alert(Title: "Please Connect Device", Message: nil) }
        else { blu.sendInquiry(ValueToSend: "9", Closure: { (value) in }) }
    }
    
    @IBOutlet weak var mediumButton: UIButton!
    @IBAction func mediumAction(_ sender: Any) {
        if blu.peripheral == nil { self.alert(Title: "Please Connect Device", Message: nil) }
        else { blu.sendInquiry(ValueToSend: "0", Closure: { (value) in }) }
    }
    
    @IBOutlet weak var highButton: UIButton!
    @IBAction func highAction(_ sender: Any) {
        if blu.peripheral == nil { self.alert(Title: "Please Connect Device", Message: nil) }
        else { blu.sendInquiry(ValueToSend: "a", Closure: { (value) in }) }
    }
    
    @IBOutlet weak var offButton: UIButton!
    @IBAction func offAction(_ sender: Any) {
        if blu.peripheral == nil { self.alert(Title: "Please Connect Device", Message: nil) }
        else { blu.sendInquiry(ValueToSend: "b", Closure: { (value) in }) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


