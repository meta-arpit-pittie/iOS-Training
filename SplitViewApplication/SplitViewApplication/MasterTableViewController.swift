//
//  MasterTableViewController.swift
//  SplitViewApplication
//
//  Created by Arpit Pittie on 2/22/17.
//  Copyright © 2017 Arpit Pittie. All rights reserved.
//

import UIKit

protocol MonsterSelectionDelegate: class {
    func monsterSelected(newMonster: Monster)
}

class MasterTableViewController: UITableViewController {
    
    var monsters = [Monster]()
    weak var delegate: MonsterSelectionDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.monsters.append(Monster(name: "Cat-Bot", description: "MEE-OW",
                                     iconName: "meetcatbot.png", weapon: Weapon.sword))
        self.monsters.append(Monster(name: "Dog-Bot", description: "BOW-WOW",
                                     iconName: "meetdogbot.png", weapon: Weapon.blowgun))
        self.monsters.append(Monster(name: "Explode-Bot", description: "BOOM!",
                                     iconName: "meetexplodebot.png", weapon: Weapon.smoke))
        self.monsters.append(Monster(name: "Fire-Bot", description: "Will Make You Stamed",
                                     iconName: "meetfirebot.png", weapon: Weapon.ninjaStar))
        self.monsters.append(Monster(name: "Ice-Bot", description: "Has A Chilling Effect",
                                     iconName: "meeticebot.png", weapon: Weapon.fire))
        self.monsters.append(Monster(name: "Mini-Tomato-Bot", description: "Extremely Handsome",
                                     iconName: "meetminitomatobot.png", weapon: Weapon.ninjaStar))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monsters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let monster = monsters[indexPath.row]
        cell.textLabel?.text = monster.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMonster = monsters[indexPath.row]
        delegate?.monsterSelected(newMonster: selectedMonster)
        
        if let detailViewController = delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
        }
    }
    
}
