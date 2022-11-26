//
//  PeripheralsList.swift
//  iOS-BLE
//
//  Created by CHI on 26/11/2022.
//

import SwiftUI

struct PeripheralsList: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    
    var body: some View {
        NavigationView {
            List(bluetoothViewModel.peripheralNames, id: \.self) { peripheralName in
                Text(peripheralName)
            }
            .navigationTitle("Peripherals")
        }
        .navigationViewStyle(.stack)
    }
}

struct PeripheralsList_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralsList()
    }
}
