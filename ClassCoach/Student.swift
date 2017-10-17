//
//  Student.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 9/6/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import Foundation

public class Student : NSObject, NSCoding {
    
    var nameFirst : String!
    var nameLast : String!
    var gender : genders!
    
    var iepMath : Bool!
    var iepReading : Bool!
    var iepWriting : Bool!
    var iepSpeech : Bool!
    var iepOT : Bool!
    
    var has504 : Bool!
    var notes504 : String!
    var hasGATE : Bool!
    var hasELL : Bool!
    
    var levelReading : levels!
    var levelMath : levels!
    var levelWriting : levels!
    var levelRW : String!
    
    var behavior : levels!
    var independence : levels!
    
    var parentDifficult : Bool!
    var parentHelpful : Bool!
    var parentDivorced : Bool!
    
    var emojieIconIndex : Int!
    
    //var favorite = false
    
    public static var levelsArray = [levels.low, levels.medium, levels.high]
    public static var genderArray = [genders.male, genders.female]
    
    
    
    override init() {
        super.init()
        
        nameFirst = ""
        nameLast = ""
        gender = genders.male
        
        iepMath = false;
        iepReading = false;
        iepWriting = false;
        iepSpeech = false;
        iepOT = false;
        
        has504 = false;
        notes504 = "";
        hasGATE = false;
        hasELL = false;
        
        levelReading = levels.medium
        levelMath = levels.medium
        levelWriting = levels.medium
        levelRW = "A"
        
        behavior = levels.medium
        independence = levels.medium
        
        parentDifficult = false
        parentHelpful = false
        parentDivorced = false
        
        emojieIconIndex = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        nameFirst = aDecoder.decodeObject(forKey: "firstname") as? String
        nameLast = aDecoder.decodeObject(forKey: "lastname") as? String
        notes504 = aDecoder.decodeObject(forKey: "notes504") as? String
        levelRW = aDecoder.decodeObject(forKey: "levelRW") as? String

        iepMath = aDecoder.decodeObject(forKey: "iepMath") as? Bool
        iepReading = aDecoder.decodeObject(forKey: "iepReading") as? Bool
        iepWriting = aDecoder.decodeObject(forKey: "iepWriting") as? Bool
        iepSpeech = aDecoder.decodeObject(forKey: "iepSpeech") as? Bool
        iepOT = aDecoder.decodeObject(forKey: "iepOT") as? Bool
        has504 = aDecoder.decodeObject(forKey: "has504") as? Bool
        hasGATE = aDecoder.decodeObject(forKey: "hasGATE") as? Bool
        hasELL = aDecoder.decodeObject(forKey: "hasELL") as? Bool
        parentHelpful = aDecoder.decodeObject(forKey: "parentHelpful") as? Bool
        parentDifficult = aDecoder.decodeObject(forKey: "parentDifficult") as? Bool
        parentDivorced = aDecoder.decodeObject(forKey: "parentDivorced") as? Bool

        levelReading = levels(rawValue: aDecoder.decodeInteger(forKey: "levelReading"))
        levelWriting = levels(rawValue: aDecoder.decodeInteger(forKey: "levelWriting"))
        levelMath = levels(rawValue: aDecoder.decodeInteger(forKey: "levelMath"))
        behavior = levels(rawValue: aDecoder.decodeInteger(forKey: "levelBehavior"))
        independence = levels(rawValue: aDecoder.decodeInteger(forKey: "levelIndependence"))
        gender = genders(rawValue: aDecoder.decodeInteger(forKey: "gender"))

        emojieIconIndex = aDecoder.decodeObject(forKey: "emojie") as? Int
        
//        levelReading = levels(rawValue: (aDecoder.decodeObject( forKey: "levelReading" ) as! Int))
//        levelWriting = levels(rawValue: (aDecoder.decodeObject( forKey: "levelWriting" ) as! Int))
//        levelMath = levels(rawValue: (aDecoder.decodeObject( forKey: "levelMath" ) as! Int))
//        behavior = levels(rawValue: (aDecoder.decodeObject( forKey: "levelBehavior" ) as! Int))
//        independence = levels(rawValue: (aDecoder.decodeObject( forKey: "levelIndependence" ) as! Int))
//
//        gender = genders(rawValue: (aDecoder.decodeObject( forKey: "gender" ) as! Int))

    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(nameFirst, forKey: "firstname")
        aCoder.encode(nameLast, forKey: "lastname")
        aCoder.encode(notes504, forKey: "notes504")
        aCoder.encode(levelRW, forKey: "levelRW")
        aCoder.encode(iepMath, forKey: "iepMath")
        aCoder.encode(iepReading, forKey: "iepReading")
        aCoder.encode(iepWriting, forKey: "iepWriting")
        aCoder.encode(iepSpeech, forKey: "iepSpeech")
        aCoder.encode(iepOT, forKey: "iepOT")
        aCoder.encode(has504, forKey: "has504")
        aCoder.encode(hasGATE, forKey: "hasGATE")
        aCoder.encode(hasELL, forKey: "hasELL")
        aCoder.encode(parentDifficult, forKey: "parentDifficult")
        aCoder.encode(parentDivorced, forKey: "parentDivorced")
        aCoder.encode(parentHelpful, forKey: "parentHelpful")
        aCoder.encode(levelReading.rawValue, forKey: "levelReading")
        aCoder.encode(levelWriting.rawValue, forKey: "levelWriting")
        aCoder.encode(levelMath.rawValue, forKey: "levelMath")
        aCoder.encode(behavior.rawValue, forKey: "levelBehavior")
        aCoder.encode(independence.rawValue, forKey: "levelIndependence")
        aCoder.encode(gender.rawValue, forKey: "gender")
        aCoder.encode(emojieIconIndex, forKey: "emojie")

    }
    
    public enum levels : Int {
        case high, medium, low
    }
    
    public enum genders : Int {
        case male, female
    }
    
    public func getIepServices() -> String {
        var services = "None"
        if hasIEP() {
            services = ""
        }
        if iepMath {
            services += " Math"
        }
        if iepReading {
            services += " Reading"
        }
        if iepWriting {
            services += " Writing"
        }
        if iepSpeech {
            services += " Speech"
        }
        if iepOT {
            services += " OT"
        }
        return services
    }
    
    public func hasIEP() -> Bool {
        if (iepReading || iepWriting || iepMath || iepSpeech || iepOT){
            return true
        }
        return false
    }
    
    public func isValid(student : Student) -> Bool {
        if nameFirst == nil || nameLast == nil || gender == nil || iepMath == nil || iepReading == nil || iepWriting == nil || iepSpeech == nil || iepOT == nil || has504 == nil || notes504 == nil || hasGATE == nil || hasELL == nil || levelReading == nil || levelMath == nil || levelWriting == nil || levelRW == nil || behavior == nil || independence == nil || parentDifficult == nil || parentHelpful == nil || parentDivorced == nil || emojieIconIndex == nil {
            return false
        }
        return true
    }
    
}
