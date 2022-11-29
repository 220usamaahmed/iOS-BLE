//
//  BluetoothViewModel.swift
//  iOS-BLE
//
//  Created by CHI on 26/11/2022.
//

import Foundation
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    private var namelessPeripheralsCount = 0
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(
                withServices: [
                    CBUUID(string: "FFB0"),
                    CBUUID(string: "FFE0"), CBUUID(string: "CD80"), CBUUID(string: "FFF0")],
                // withServices: nil,
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
            )
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            
            print("🔵 Peripheral discovered: \(peripheral.identifier), \(peripheral.name ?? "Nameless Device")")
            // printPeripheralCharacteristics(peripheral: peripheral)
            // connectToPeripheral(peripheral: peripheral)
            
            // if true {
            // if peripheral.identifier.uuidString == "74596AB7-58E4-DBBC-0966-DDEDA6594F85" {
            // if peripheral.identifier.uuidString == "05DA4B40-1605-F411-76A4-9D3EAFFD8C7C" {
            if peripheral.identifier.uuidString == "8166D820-4242-C386-11D9-5117AB809FCA" {
                self.centralManager?.connect(peripheral)
            }
        
            if let peripheralName = peripheral.name {
                self.peripheralNames.append(peripheralName)
            } else {
                self.namelessPeripheralsCount += 1
                self.peripheralNames.append("Nameless peripheral \(self.namelessPeripheralsCount)")
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("🤝 Connection established with peripheral \(peripheral.name ?? "Nameless Device")")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    private func printPeripheralCharacteristics(peripheral: CBPeripheral) {
        print("Number of services: \(peripheral.services?.count ?? 0)")

        peripheral.services?.forEach { service in
            print("👷 Service: \(service.description)")
            service.characteristics?.forEach { characteristic in
                print("\tCharacteristic: \(characteristic.description)")
            }
        }
    }
}

extension BluetoothViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Number of services: \(peripheral.services?.count ?? 0)")
        
        peripheral.services?.forEach { service in
            print("👷 Service: \(service.description)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        service.characteristics?.forEach { characteristic in
            print("📝 Characteristic: \(characteristic.description)")
            // peripheral.readValue(for: characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
        }
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error
        {
            print("🔴 Error reading characteristic : \(error)")
            return
        }
        guard let value = characteristic.value else
        {
            return
        }
        
        let bytes = [UInt8](value)
        
        let weight = Double((UInt16(bytes[2]) << 8) + UInt16(bytes[3])) / 100.0
        print("\(characteristic.uuid): \(bytes) ---> Weight: \(weight)")
    }
    
    private func decodeFrame(data: [UInt8]) {
    
    }
}
