//
//  QRCodeViewController.swift
//  QRCodeReader
//
//  Created by Arpit Pittie on 11/01/17.
//  Copyright © 2016 Metacube. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

}
