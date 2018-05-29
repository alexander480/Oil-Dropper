//
//  CentralManager.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/22/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

class Bluetooth: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let centralManager = CBCentralManager()
    
    var peripherals = [CBPeripheral]()
    var peripheral: CBPeripheral?
    
    var service: CBService?
    let serviceUUID = CBUUID(string: "0000ffe0-0000-1000-8000-00805f9b34fb")
    
    var char: CBCharacteristic?
    let charUUID = CBUUID(string: "0000ffe1-0000-1000-8000-00805f9b34fb")
    
    var lastInq: String = ""
    var currentTemp: String?
    
    var bluetoothOn = false
    
    override init() {
        super.init()
        self.centralManager.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch(central.state) {
        case .poweredOn:
            print("[INFO] Scanning Nearby Devices...")
            self.bluetoothOn = true
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        case .poweredOff:
            print("[ERROR] Please Turn On Bluetooth.")
            self.bluetoothOn = false
        default:
            print("[ERROR] Could Not Turn Bluetooth On. Unknown Error.")
            self.bluetoothOn = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripherals.contains(peripheral) == false {
            if peripheral.name != nil {
                peripherals.append(peripheral)
                print(peripheral)
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
        self.peripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let err = error { print("[ERROR] Could Not Discover Services: \(err.localizedDescription)"); return }
        if let serv = peripheral.services { peripheral.discoverCharacteristics([charUUID], for: serv[0]) }
        else { print("[ERROR] Could Not Validate Peripheral Services.") }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let err = error { print("[ERROR] Could Not Discover Services: \(err.localizedDescription)"); return }
        if let chars = service.characteristics {
            print("[INFO] Discovered \(chars.count) Characteristics!")
            print("[SUCCESS] Ready To Talk")
            
            if let characteristic = chars.first {
                if characteristic.uuid == charUUID {
                    peripheral.setNotifyValue(true, for: characteristic)
                    self.char = characteristic
                }
            }
        }
    }
    
    func sendInquiry(ValueToSend: String, Closure: (String) -> ()) {
        if let p = self.peripheral {
            if let c = self.char {
                self.lastInq = ValueToSend
                if let data = ValueToSend.data(using: String.Encoding.utf8) {
                    p.writeValue(data, for: c, type: .withResponse)
                    p.readValue(for: c)
                    if let ValueReturned = c.value {
                        if let finalValue = String(data: ValueReturned, encoding: String.Encoding.utf8) { Closure(finalValue) }
                        else { Closure("") }
                    }
                    else { print("[ERROR] 'ValueReturned' Invalid") }
                }
                else { print("[ERROR] 'ValueToSend' Invalid") }
            }
            else { print("[ERROR] Invalid Characteristic") }
        }
        else { print("[ERROR] Invalid Peripheral") }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let err = error { print("[ERROR] Invalid Value For Characteristic: \(err.localizedDescription)"); return }
        if self.lastInq == "x" {
            if let data = characteristic.value {
                if let val = String(data: data, encoding: String.Encoding.utf8) {
                    print("Temperature: \(val)ºC")
                    self.currentTemp = val
                }
            }
        }
    }
}
