//
//  BluetoothManager.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/22/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate
{
    var centralManager: CBCentralManager
    var peripheralManager: PeripheralManager?
    
    var peripheral: CBPeripheral?
    var peripheralName: String
    
    init(PeripheralName: String) {
        self.centralManager = CBCentralManager()
        self.peripheralName = PeripheralName
        super.init()
        
        self.centralManager.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch(central.state) {
        case .poweredOn:
            print("[INFO] Scanning Nearby Devices...")
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        case .poweredOff:
            print("[ERROR] Please Turn On Bluetooth.")
        default:
            print("[ERROR] Could Not Turn Bluetooth On. Unknown Error.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name {
            if name == self.peripheralName {
                print("[INFO] Found Peripheral Named '\(name)'")
                self.centralManager.stopScan()
                
                print("[INFO] Connecting To Device...")
                self.centralManager.connect(peripheral, options: nil)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("[ERROR] Could Not Connect To Device.")
        if let err = error { print("[REASON] \(err.localizedDescription)") }
        else { print("[REASON] Unknown Error") }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("[INFO] Connection Successful!")
        self.peripheralManager = PeripheralManager(Peripheral: peripheral, ServiceUUID: "", ReadUUID: "", WriteUUID: "")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.peripheralManager = PeripheralManager(Peripheral: peripheral, ServiceUUID: "", ReadUUID: "", WriteUUID: "")
    }
}
