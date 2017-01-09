//
//  Power.swift
//  MockObjectTesting
//
//  Created by Arpit Pittie on 07/01/17.
//  Copyright © 2017 Metacube. All rights reserved.
//

import UIKit

class Power {
    
    var device: UIDevice
    
    init() {
        self.device = UIDevice.current
    }
    
    init(usingMockDevice mockDevice: UIDevice) {
        device = mockDevice
    }
    
    func isPluggedIn() -> Bool {
        let batteryState = self.device.batteryState
        let isPluggedIn = batteryState ==    UIDeviceBatteryState.charging || batteryState ==  UIDeviceBatteryState.full
        return isPluggedIn
    }
    
}
