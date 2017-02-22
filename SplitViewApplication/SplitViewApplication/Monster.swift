//
//  Monster.swift
//  SplitViewApplication
//
//  Created by Arpit Pittie on 2/22/17.
//  Copyright © 2017 Arpit Pittie. All rights reserved.
//

import UIKit

enum Weapon {
    case blowgun, ninjaStar, fire, sword, smoke
}

class Monster {
    let name: String
    let description: String
    let iconName: String
    let weapon: Weapon
    
    init(name: String, description: String, iconName: String, weapon: Weapon) {
        self.name = name
        self.description = description
        self.iconName = iconName
        self.weapon = weapon
    }
    
    func weaponImage() -> UIImage? {
        switch self.weapon {
        case .blowgun:
            return UIImage(named: "blowgun.png")
        case .ninjaStar:
            return UIImage(named: "ninjastar.png")
        case .fire:
            return UIImage(named: "fire.png")
        case .sword:
            return UIImage(named: "sword.png")
        case .smoke:
            return UIImage(named: "smoke.png")
        }
    }
}
