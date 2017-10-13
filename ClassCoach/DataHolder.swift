//
//  DataHolder.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 10/9/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import Foundation

class DataHolder {
    
    static let sharedInstance = DataHolder()
    public var classList = [Student]()
    public var filters = [FilterCategories:Bool]()
    
    private init() {}
    
    public func removeStudentFromClassList(student : Student){
        for i in 0 ..< classList.count {
            if (classList[i] === student){
                classList.remove(at: i)
                break;
            }
        }
    }
    
}
