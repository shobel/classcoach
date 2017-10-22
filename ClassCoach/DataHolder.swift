//
//  DataHolder.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 10/9/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import Foundation
import UIKit

extension FileManager {
    func addSkipBackupAttributeToItemAtURL(url:NSURL) throws {
        try url.setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
    }
}

class DataHolder {
    
    var filePath: String {
        //1 - manager lets you examine contents of a files and folders in your app; creates a directory to where we are saving it
        let manager = FileManager.default
        //2 - this returns an array of urls from our documentDirectory and we take the first path
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        print("this is the url path in the documentDirectory \(String(describing: url))")
        //3 - creates a new path component and creates a new file called "Data" which is where we will store our Data array.
        return (url!.appendingPathComponent("Data").path)
    }
    
    static let sharedInstance = DataHolder()
    public var classList : [Student]! {
        didSet {
            saveData()
        }
    }
    public var filters = [FilterCategories:Bool]()
    public var themeColor = UIColor(red: 39/255, green: 121/255, blue: 138/255, alpha: 1)
        
    private init() {
        do {
            try FileManager.default.addSkipBackupAttributeToItemAtURL(url: NSURL(string: filePath)!)
        } catch {
            print("Error: \(error)")
        }
        loadData()
        //UserDefaults.standard.removeObject(forKey: "classlist")
//        if let classListRaw = UserDefaults.standard.data(forKey: "classlist") {
//            if let unarchivedClassList = NSKeyedUnarchiver.unarchiveObject(with: classListRaw) as? [Student] {
//                classList = unarchivedClassList
//            }
//        }
    }
    
    public func saveData(){
        //NSKeyedArchiver.archiveRootObject(classList, toFile: filePath)
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: classList)
        let encryptedData = RNCryptor.encrypt(data: archivedData, withPassword: "password")
        NSKeyedArchiver.archiveRootObject(encryptedData, toFile: filePath)
    }
    
    public func loadData(){
        //if there is data saved in old plain text format, load it and then encrypt it
        //Otherwise, try to load the encrypted data
        if let classData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Student] {
            if (validate(classList: classData)){
                classList = classData
                saveData()
            }
        } else {
            if let encryptedArchive = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data {
                do {
                    let decryptedArchive = try RNCryptor.decrypt(data: encryptedArchive, withPassword: "password")
                    let classData = NSKeyedUnarchiver.unarchiveObject(with: decryptedArchive) as! [Student]
                    if (validate(classList: classData)){
                        classList = classData
                    } else {
                        classList = [Student]()
                    }
                } catch {
                    print(error)
                }
            } else {
                classList = [Student]()
            }
        }
        
//        if let classData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Student] {
//            if (validate(classList: classData)){
//                classList = classData
//            } else {
//                classList = [Student]()
//            }
//        } else {
//            classList = [Student]()
//        }
    }
    
    public func removeStudentFromClassList(student : Student){
        for i in 0 ..< classList.count {
            if (classList[i] === student){
                classList.remove(at: i)
                break;
            }
        }
        //saveData()
    }
    
    private func validate(classList : [Student]) -> Bool{
        for student in classList {
            if !student.isValid(student: student) {
                return false
            }
        }
        return true
    }
    
}
