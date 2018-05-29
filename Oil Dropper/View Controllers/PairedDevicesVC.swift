//
//  PairedDevicesVC.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/21/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

class PairedDevicesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if blu.bluetoothOn == false { self.alert(Title: "Please Turn On Bluetooth", Message: nil) }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return blu.peripherals.count + 1 }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { if indexPath.row == 0 { return 60.0 } else { return 60.0 } }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
                cell.backgroundColor = #colorLiteral(red: 0.4470072985, green: 0.44708848, blue: 0.4470021725, alpha: 1)
                cell.textLabel?.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                cell.textLabel?.text = "Select Bluetooth Device:"
            
            return cell
        }
        else
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath)
                if let name = blu.peripherals[indexPath.row - 1].name { cell.textLabel?.text = name } else { cell.textLabel?.text = "-----" }
                cell.textLabel?.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                cell.detailTextLabel?.text = blu.peripherals[indexPath.row - 1].identifier.uuidString
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return } else {
            if let name = blu.peripherals[indexPath.row - 1].name {
                if name.contains(find: "DD1") {
                    blu.centralManager.connect(blu.peripherals[indexPath.row - 1], options: nil)
                    self.present(HomeVC(), animated: true, completion: nil)
                } else { self.alert(Title: "Invalid Device Selected", Message: nil) }
            } else { self.alert(Title: "Invalid Device Name", Message: nil) }
        }
    }
}



