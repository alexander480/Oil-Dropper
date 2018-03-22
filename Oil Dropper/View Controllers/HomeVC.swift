//
//  HomeVC.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/21/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var flowLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    
    @IBOutlet weak var startSessionButton: UIButton!
    @IBAction func startSessionAction(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

