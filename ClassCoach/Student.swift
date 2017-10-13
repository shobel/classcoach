//
//  Student.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 9/6/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import Foundation

public class Student {
    
    var nameFirst = ""
    var nameLast = ""
    var gender = genders.male
    
    var iepMath = false;
    var iepReading = false;
    var iepWriting = false;
    var iepSpeech = false;
    var iepOT = false;
    
    var has504 = false;
    var notes504 = "";
    var hasGATE = false;
    var hasELL = false;
    
    var levelReading = levels.medium
    var levelMath = levels.medium
    var levelWriting = levels.medium
    var levelRW = "A"
    
    var behavior = levels.medium
    var independence = levels.medium
    
    var parentDifficult = false
    var parentHelpful = false
    var parentDivorced = false
    
    var emojieIconIndex = 0
    
    //var favorite = false
    
    public static var levelsArray = [levels.low, levels.medium, levels.high]
    public static var genderArray = [genders.male, genders.female]
    
    public enum levels {
        case high, medium, low
    }
    
    public enum genders {
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
        if iepReading{
            services += " Reading"
        }
        if iepWriting {
            services += " Writing"
        }
        if iepSpeech {
            services += " Speech"
        }
        if iepOT{
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
    
}
