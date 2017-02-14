//
//  Utility.swift
//  DbDemoExample
//
//  Created by Arpit Pittie on 2/14/17.
//  Copyright © 2017 Arpit Pittie. All rights reserved.
//

import UIKit

class Utility {
    class func getPath(fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        return fileURL.path
    }
    
    class func copyFile(fileName: String) {
        let dbPath: String = getPath(fileName: fileName)
        print("path for file \(dbPath)")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL?.appendingPathComponent(fileName)
            
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath!.path, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            
            let alert: UIAlertView = UIAlertView()
            if (error != nil) {
                alert.title = "Error Occured"
                alert.message = error?.localizedDescription
            } else {
                alert.title = "Successfully Copy"
                alert.message = "Your database copy successfully"
            }
            alert.addButton(withTitle: "Ok")
            alert.show()
        }
    }
    
    class func invokeAlertMethod(strTitle: String, strBody: String) {
        let alert: UIAlertView = UIAlertView()
        alert.message = strBody as String
        alert.title = strTitle as String
        alert.addButton(withTitle: "Ok")
        alert.show()
    }
}
