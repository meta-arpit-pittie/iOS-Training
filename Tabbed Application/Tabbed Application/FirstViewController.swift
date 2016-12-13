//
//  FirstViewController.swift
//  Tabbed Application
//
//  Created by Arpit Pittie on 07/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var scrollViewForm: UIScrollView!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var experienceField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var saveInformationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollViewForm.contentSize = CGSize(width: 50, height: 50)
        
        saveInformationButton.isEnabled = false
        
        fullNameField.delegate = self
        emailField.delegate = self
        mobileField.delegate = self
        experienceField.delegate = self
        addressField.delegate = self
        cityField.delegate = self
        stateField.delegate = self
        countryField.delegate = self
        zipcodeField.delegate = self
        companyField.delegate = self
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveInformationButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkAllFieldsHaveValues()
    }
    
    func checkAllFieldsHaveValues() {
        let fullName = fullNameField.text ?? ""
        let email = emailField.text ?? ""
        let mobile = mobileField.text ?? ""
        let experience = experienceField.text ?? ""
        let address = addressField.text ?? ""
        let city = cityField.text ?? ""
        let state = stateField.text ?? ""
        let country = countryField.text ?? ""
        let zipcode = zipcodeField.text ?? ""
        let company = companyField.text ?? ""
        
        saveInformationButton.isEnabled = !(fullName.isEmpty || email.isEmpty || mobile.isEmpty || experience.isEmpty || address.isEmpty || city.isEmpty || state.isEmpty || country.isEmpty || zipcode.isEmpty || company.isEmpty)
        
        print(saveInformationButton.isEnabled)
    }
    
}

