//
//  ModelManager.swift
//  DbDemoExample
//
//  Created by Arpit Pittie on 2/14/17.
//  Copyright © 2017 Arpit Pittie. All rights reserved.
//

import UIKit
import FMDB

let sharedInstance = ModelManager()

class ModelManager {
    
    var database: FMDatabase? = nil
    
    class func getInstance() -> ModelManager {
        if sharedInstance.database == nil {
            sharedInstance.database = FMDatabase(path: Utility.getPath(fileName: "Student.sqlite"))
        }
        return sharedInstance
    }
    
    func addStudentData(studentInfo: StudentInfo) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO student_info (Name, Marks) VALUES (?, ?)", withArgumentsIn: [studentInfo.name, studentInfo.marks])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func getAllStudentData() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM student_info", withArgumentsIn: nil)
        let marrStudentInfo = NSMutableArray()
        if resultSet != nil {
            while resultSet.next() {
                let studentInfo = StudentInfo()
                studentInfo.rollNo = resultSet.string(forColumn: "RollNo")
                studentInfo.name = resultSet.string(forColumn: "Name")
                studentInfo.marks = resultSet.string(forColumn: "Marks")
                marrStudentInfo.add(studentInfo)
            }
        }
        sharedInstance.database!.close()
        return marrStudentInfo
    }
    
    func updateStudentData(studentInfo: StudentInfo) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE student_info SET Name=?, Marks=? WHERE RollNo=?", withArgumentsIn: [studentInfo.name, studentInfo.marks, studentInfo.rollNo])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func deleteStudentData(studentInfo: StudentInfo) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM student_info WHERE RollNo=?", withArgumentsIn: [studentInfo.rollNo])
        sharedInstance.database!.close()
        return isDeleted
    }
}
