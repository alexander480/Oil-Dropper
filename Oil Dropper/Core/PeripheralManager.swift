//
//  PeripheralManager.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/22/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import Foundation
import CoreBluetooth

class PeripheralManager: NSObject, CBPeripheralDelegate{
    var peripheral: CBPeripheral
    
    var serviceUUID: CBUUID
    var readUUID: CBUUID
    var writeUUID: CBUUID
    
    var service: CBService?
    var readChar: CBCharacteristic?
    var writeChar: CBCharacteristic?
    
    var lastValueSent: UInt8 = 0
    
    init(Peripheral: CBPeripheral, ServiceUUID: String, ReadUUID: String, WriteUUID: String) {
        self.peripheral = Peripheral
        self.serviceUUID = CBUUID(string: ServiceUUID)
        self.readUUID = CBUUID(string: ReadUUID)
        self.writeUUID = CBUUID(string: WriteUUID)
        
        super.init()
        
        self.peripheral.delegate = self
        self.peripheral.discoverServices([serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let err = error {
            print("[ERROR] Could Not Discover Services.")
            print("[REASON] \(err.localizedDescription)")
            return
        }
        
        if let serv = peripheral.services { self.peripheral.discoverCharacteristics([readUUID, writeUUID], for: serv[0]) }
        else { print("[ERROR] Could Not Validate Peripheral Services.") }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let err = error {
            print("[ERROR] Could Not Discover Services.")
            print("[REASON] \(err.localizedDescription)")
            return
        }
        
        if let chars = service.characteristics {
            print("[INFO] Discovered \(chars.count) Characteristics!")
            print("[SUCCESS] Ready To Talk")
            
            for char in chars {
                if char.uuid == readUUID { self.readChar = char; self.peripheral.setNotifyValue(true, for: char) }
                else if char.uuid == writeUUID { self.writeChar = char }
            }
        }
    }
    
    func sendInquiry(Question: UInt8) -> Data? {
        if let write = writeChar, let read = readChar {
            self.lastValueSent = Question
            self.peripheral.writeValue(Data([Question]), for: write, type: CBCharacteristicWriteType.withoutResponse)
            self.peripheral.readValue(for: read)
            if let newValue = read.value { print("[INFO] Got New Data: \(newValue)"); return newValue }
            else { print("[ERROR] Invalid Value For Characteristic."); return nil }
        }
        else {
            print("[ERROR] Invalid Characteristics, Attempting To Recover.");
            self.peripheral.discoverServices([serviceUUID]);
            
            return nil
        }
    }
}
