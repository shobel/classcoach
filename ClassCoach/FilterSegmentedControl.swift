//
//  FilterSegmentedControl.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 10/23/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

class FilterSegmentedControl: UISegmentedControl {

    // captures existing selected segment on touchesBegan
    var oldValue : Int!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.oldValue = self.selectedSegmentIndex
        super.touchesBegan(touches, with: event)
    }
    
    // This was the key to make it work as expected
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if self.oldValue == self.selectedSegmentIndex{
            self.selectedSegmentIndex = -1
            sendActions(for: .valueChanged)
        }
    }

}
