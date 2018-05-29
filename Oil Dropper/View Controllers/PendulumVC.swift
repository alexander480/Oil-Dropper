//
//  PendulumVC.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/21/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import UIKit

class PendulumVC: UIViewController {
    @IBOutlet weak var lowButton: UIButton!
    @IBAction func lowAction(_ sender: Any) {
        if blu.peripheral == nil { self.alert(Title: "Please Connect Device", Message: nil) }
        else {  blu.sendInquiry(ValueToSend: "5", Closure: { (value) in }) }
    }
    
    @IBOutlet weak var mediumButton: UIButton!
    @IBAction func mediumAction(_ sender: Any) {
        if blu.peripheral == nil { self.alert(Title: "Please Connect Device", Message: nil) }
        else { blu.sendInquiry(ValueToSend: "6", Closure: { (value) in }) }
    }
    
    @IBOutlet weak var highButton: UIButton!
    @IBAction func highAction(_ sender: Any) {
        if blu.peripheral == nil { self.alert(Title: "Please Connect Device", Message: nil) }
        else { blu.sendInquiry(ValueToSend: "7", Closure: { (value) in }) }
    }
    
    @IBOutlet weak var offButton: UIButton!
    @IBAction func offAction(_ sender: Any) {
        if blu.peripheral == nil { self.alert(Title: "Please Connect Device", Message: nil) }
        else { blu.sendInquiry(ValueToSend: "8", Closure: { (value) in }) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



