//
//  AppDelegate.swift
//  ScanditBarcodeScanner
//
//  Created by Arpit Pittie on 18/01/17.
//  Copyright © 2017 Metacube. All rights reserved.
//

import UIKit

let kScanditBarcodeScannerAppKey = "DeWOMVCxxWBbncnfE7jbOnv0vUIfdtiqaIUEvW4INlU";

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SBSScanDelegate, UIAlertViewDelegate {

    var window: UIWindow?
    
    var picker : SBSBarcodePicker?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SBSLicense.setAppKey(kScanditBarcodeScannerAppKey);
        
        // Scandit Barcode Scanner Integration
        // The following method calls illustrate how the Scandit Barcode Scanner can be integrated
        // into your app.
        // Hide the status bar to get a bigger area of the video feed. (optional)
        application.setStatusBarHidden(true, with:.none);
        let settings = SBSScanSettings.pre47Default();
        let thePicker = SBSBarcodePicker(settings:settings);
        
        // set the allowed interface orientations. The value UIInterfaceOrientationMaskAll is the
        // default and is only shown here for completeness.
        thePicker.allowedInterfaceOrientations = .all;
        // Set the delegate to receive scan event callbacks
        thePicker.scanDelegate = self;
        thePicker.startScanning();
        
        picker = thePicker;
        
        window?.rootViewController = picker;
        window?.makeKeyAndVisible();
        return true
    }
    
    // This delegate method of the SBSScanDelegate protocol needs to be implemented by
    // every app that uses the Scandit Barcode Scanner and this is where the custom application logic
    
    // goes. In the example below, we are just showing an alert view with the result.
    func barcodePicker(_ picker: SBSBarcodePicker, didScan session: SBSScanSession) {
        // call stopScanning on the session to immediately stop scanning and close the camera. This
        // is the preferred way to stop scanning barcodes from the SBSScanDelegate as it is made
        // sure that no new codes are scanned. When calling stopScanning on the picker, another code
        // may be scanned before stopScanning has completely stoppen the scanning process.
        session.stopScanning();
        
        let code = session.newlyRecognizedCodes[0];
        // the barcodePicker:didScan delegate method is invoked from a picker-internal queue. To
        // display the results in the UI, you need to dispatch to the main queue. Note that it's not
        // allowed to use SBSScanSession in the dispatched block as it's only allowed to access the
        // SBSScanSession inside the barcodePicker(picker:didScan:) callback. It is however safe to
        // use results returned by session.newlyRecognizedCodes etc.
        DispatchQueue.main.async {
            let alert = UIAlertView();
            alert.delegate = self;
            alert.title = String(format:"Scanned code %@", code.symbologyString);
            alert.message = code.data;
            alert.addButton(withTitle:"OK");
            alert.show();
        }
    }
    
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        picker?.startScanning();
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

