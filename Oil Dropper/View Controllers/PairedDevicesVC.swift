//
//  PairedDevicesVC.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/21/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import UIKit

class PairedDevicesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var devices = [[String: String]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 65.0 } else { return 60.0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
                cell.backgroundColor = #colorLiteral(red: 0.4470072985, green: 0.44708848, blue: 0.4470021725, alpha: 1)
                cell.textLabel?.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                cell.textLabel?.text = "Select Bluetooth Device From Paired Devices:"
            
            return cell
        }
        else
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath)
                cell.textLabel?.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                cell.textLabel?.text = devices[indexPath.row - 1]["Name"]
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                cell.detailTextLabel?.text = devices[indexPath.row - 1]["MAC"]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        else {
            let device = devices[indexPath.row - 1]
            
        }
    }
}



