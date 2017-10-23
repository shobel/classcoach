//
//  FilterTableViewController.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 9/6/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    @IBOutlet weak var filterReading: UISegmentedControl!
    @IBOutlet weak var filterWriting: UISegmentedControl!
    @IBOutlet weak var filterMath: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background image
        let tempImageView = UIImageView(image: UIImage(named: "orange_poly.jpg"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
        self.tableView.separatorStyle = .none;
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @IBAction func applyButtonAction(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
        let classListVC = navigationController?.topViewController as! ClassListTableViewController
        for filterCategory in DataHolder.sharedInstance.filters {
            if (DataHolder.sharedInstance.filters[filterCategory.key])!{
                classListVC.applyFilter()
                break
            }
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
        DataHolder.sharedInstance.filters.removeAll()
        let classListVC = navigationController?.topViewController as! ClassListTableViewController
        classListVC.doNormalLayout()
        
    }
    
    @IBAction func filterELL(_ sender: AnyObject) {
        DataHolder.sharedInstance.filters[FilterCategories.ELL] = sender.isOn
    }
    
    @IBAction func filterGate(_ sender: AnyObject) {
        DataHolder.sharedInstance.filters[FilterCategories.GATE] = sender.isOn
    }
    
    @IBAction func filter504(_ sender: AnyObject) {
        DataHolder.sharedInstance.filters[FilterCategories.FIVEOFOUR] = sender.isOn
    }
    
    @IBAction func filterIEP(_ sender: AnyObject) {
        DataHolder.sharedInstance.filters[FilterCategories.IEP] = sender.isOn
    }
    
    @IBAction func filterReading(_ sender: Any) {
        DataHolder.sharedInstance.filters[FilterCategories.READING_HIGH] = false
        DataHolder.sharedInstance.filters[FilterCategories.READING_MIDDLE] = false
        DataHolder.sharedInstance.filters[FilterCategories.READING_LOW] = false
        if (sender as! UISegmentedControl).selectedSegmentIndex == 0 {
            DataHolder.sharedInstance.filters[FilterCategories.READING_HIGH] = true
        } else if (sender as! UISegmentedControl).selectedSegmentIndex == 1 {
            DataHolder.sharedInstance.filters[FilterCategories.READING_MIDDLE] = true
        } else if (sender as! UISegmentedControl).selectedSegmentIndex == 2 {
            DataHolder.sharedInstance.filters[FilterCategories.READING_LOW] = true
        }
    }
    
    @IBAction func filterWriting(_ sender: Any) {
        DataHolder.sharedInstance.filters[FilterCategories.WRITING_HIGH] = false
        DataHolder.sharedInstance.filters[FilterCategories.WRITING_MIDDLE] = false
        DataHolder.sharedInstance.filters[FilterCategories.WRITING_LOW] = false
        if (sender as! UISegmentedControl).selectedSegmentIndex == 0 {
            DataHolder.sharedInstance.filters[FilterCategories.WRITING_HIGH] = true
        } else if (sender as! UISegmentedControl).selectedSegmentIndex == 1 {
            DataHolder.sharedInstance.filters[FilterCategories.WRITING_MIDDLE] = true
        } else if (sender as! UISegmentedControl).selectedSegmentIndex == 2 {
            DataHolder.sharedInstance.filters[FilterCategories.WRITING_LOW] = true
        }
    }
    
    @IBAction func filterMath(_ sender: Any) {
        DataHolder.sharedInstance.filters[FilterCategories.MATH_HIGH] = false
        DataHolder.sharedInstance.filters[FilterCategories.MATH_MIDDLE] = false
        DataHolder.sharedInstance.filters[FilterCategories.MATH_LOW] = false
        if (sender as! UISegmentedControl).selectedSegmentIndex == 0 {
            DataHolder.sharedInstance.filters[FilterCategories.MATH_HIGH] = true
        } else if (sender as! UISegmentedControl).selectedSegmentIndex == 1 {
            DataHolder.sharedInstance.filters[FilterCategories.MATH_MIDDLE] = true
        } else if (sender as! UISegmentedControl).selectedSegmentIndex == 2 {
            DataHolder.sharedInstance.filters[FilterCategories.MATH_LOW] = true
        }
    }

}
