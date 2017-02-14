//
//  InsertRecordViewController.swift
//  DbDemoExample
//
//  Created by Arpit Pittie on 2/13/17.
//  Copyright © 2017 Arpit Pittie. All rights reserved.
//

import UIKit

class InsertRecordViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var marksTextField: UITextField!
    
    var isEdit: Bool = false
    var studentData: StudentInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEdit {
            nameTextField.text = studentData.name;
            marksTextField.text = studentData.marks;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions

    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if nameTextField.text == "" {
            Utility.invokeAlertMethod(strTitle: "", strBody: "Please enter student name.")
        } else if marksTextField.text == "" {
            Utility.invokeAlertMethod(strTitle: "", strBody: "Please enter student marks.")
        } else {
            if isEdit {
                let studentInfo = StudentInfo()
                studentInfo.rollNo = studentData.rollNo
                studentInfo.name = nameTextField.text!
                studentInfo.marks = marksTextField.text!
                let isUpdated = ModelManager.getInstance().updateStudentData(studentInfo: studentInfo)
                if isUpdated {
                    Utility.invokeAlertMethod(strTitle: "", strBody: "Record updated successfully.")
                } else {
                    Utility.invokeAlertMethod(strTitle: "", strBody: "Error in updating record.")
                }
            } else {
                let studentInfo: StudentInfo = StudentInfo()
                studentInfo.name = nameTextField.text!
                studentInfo.marks = marksTextField.text!
                let isInserted = ModelManager.getInstance().addStudentData(studentInfo: studentInfo)
                if isInserted {
                    Utility.invokeAlertMethod(strTitle: "", strBody: "Record Inserted successfully.")
                } else {
                    Utility.invokeAlertMethod(strTitle: "", strBody: "Error in inserting record.")
                }
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
