//
//  ScannerViewController.swift
//  ScanditScanner
//
//  Created by Arpit Pittie on 12/01/17.
//  Copyright © 2017 Metacube. All rights reserved.
//

import UIKit
import ScanditSDK

class ScannerViewController: UIViewController, ScanditSDKOverlayControllerDelegate {

    var scanditBarcodePicker = ScanditSDKBarcodePicker()
    override func viewDidLoad() {
        super.viewDidLoad()

        scanditBarcodePicker.overlayController.delegate = self
    }
    
    // MARK: ScanditSDKOverlayControllerDelegate
    func scanditSDKOverlayController(_ overlayController: ScanditSDKOverlayController!, didScanBarcode barcode: [AnyHashable : Any]!) {
    }
    
    func scanditSDKOverlayController(_ overlayController: ScanditSDKOverlayController!, didCancelWithStatus status: [AnyHashable : Any]!) {
    }
    
    func scanditSDKOverlayController(_ overlayController: ScanditSDKOverlayController!, didManualSearch text: String!) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
