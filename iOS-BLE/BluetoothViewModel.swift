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
                withServices: [CBUUID(string: "FFE0"), CBUUID(string: "CD80"), CBUUID(string: "FFF0")],
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
            )
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            
            if let peripheralName = peripheral.name {
                self.peripheralNames.append(peripheralName)
            } else {
                self.namelessPeripheralsCount += 1
                self.peripheralNames.append("Nameless peripharal \(self.namelessPeripheralsCount)")
            }
        }
    }
}
