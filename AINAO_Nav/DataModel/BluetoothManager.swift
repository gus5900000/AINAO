//
//  BluetoothManager.swift
//  EatSideStory
//
//  Created by FrancoisW on 11/06/2024.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var isBluetoothEnabled = false
    @Published var discoveredPeripherals = [CBPeripheral]()

    private var centralManager: CBCentralManager!

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isBluetoothEnabled = true
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            isBluetoothEnabled = false
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)

            // print("CBPeripheral : \(peripheral), advertismenetData : \(advertisementData), rssi : \(RSSI)")
            // print("advertismenetData : \(advertisementData), rssi : \(RSSI)")
           //  print("CBPeripheral : \(peripheral), rssi : \(RSSI)")
            // print("CBPeripheral : \(peripheral.name) (\(peripheral.debugDescription)), rssi : \(RSSI)")
            print("CBPeripheral : \(peripheral.name ?? "No Name"), rssi : \(RSSI)")

        }


  }

    func toggleBluetooth() {
        if centralManager.state == .poweredOn {
            centralManager.stopScan()
            centralManager = nil
        } else {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }
}

