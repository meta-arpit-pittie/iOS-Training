//
//  DetailViewController.swift
//  SplitViewApplication
//
//  Created by Arpit Pittie on 2/22/17.
//  Copyright © 2017 Arpit Pittie. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var weaponImageView: UIImageView!
    
    var monster: Monster! {
        didSet (newMonster) {
//            self.refreshUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshUI()
    }
    
    func refreshUI() {
        nameLabel.text = monster.name
        descriptionLabel.text = monster.description
        iconImageView.image = UIImage(named: monster.iconName)
        weaponImageView.image = monster.weaponImage()
    }

}

extension DetailViewController: MonsterSelectionDelegate {
    func monsterSelected(newMonster: Monster) {
        monster = newMonster
        refreshUI()
    }
}
