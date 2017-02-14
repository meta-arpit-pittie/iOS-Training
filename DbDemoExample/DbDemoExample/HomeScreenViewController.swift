//
//  ViewController.swift
//  DbDemoExample
//
//  Created by Arpit Pittie on 2/13/17.
//  Copyright © 2017 Arpit Pittie. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var studentTableView: UITableView!
    
    var marrStudentData: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        getStudentData()
    }
    
    func getStudentData() {
        marrStudentData = ModelManager.getInstance().getAllStudentData()
        studentTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editSegue")
        {
            let btnEdit : UIButton = sender as! UIButton
            let selectedIndex : Int = btnEdit.tag
            let viewController : InsertRecordViewController = segue.destination as! InsertRecordViewController
            viewController.isEdit = true
            viewController.studentData = marrStudentData.object(at: selectedIndex) as! StudentInfo
        }
    }

    // MARK: Actions
    @IBAction func editButtonClicked(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "editSegue", sender: sender)
    }

    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        let selectedIndex : Int = sender.tag
        let studentInfo: StudentInfo = marrStudentData.object(at: selectedIndex) as! StudentInfo
        let isDeleted = ModelManager.getInstance().deleteStudentData(studentInfo: studentInfo)
        if isDeleted {
            Utility.invokeAlertMethod(strTitle: "", strBody: "Record deleted successfully.")
        } else {
            Utility.invokeAlertMethod(strTitle: "", strBody: "Error in deleting record.")
        }
        self.getStudentData()
    }
    
}

extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marrStudentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StudentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell") as! StudentTableViewCell
        let student:StudentInfo = marrStudentData.object(at: indexPath.row) as! StudentInfo
        cell.contentLabel.text = "Name : \(student.name) \nMarks : \(student.marks)"
        cell.deleteButton.tag = indexPath.row
        cell.editButton.tag = indexPath.row
        return cell
    }
}
