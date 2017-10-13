//
//  FilterCategories.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 10/9/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import Foundation

public enum FilterCategories {
    case IEP, FIVEOFOUR, GATE, ELL
    
    public func toString(filterCategory: FilterCategories) -> String {
        switch (filterCategory){
        case FilterCategories.ELL : return "ELL"
        case FilterCategories.IEP : return "IEP"
        case FilterCategories.FIVEOFOUR : return "504"
        case FilterCategories.GATE : return "GATE"
        }
    }
}



