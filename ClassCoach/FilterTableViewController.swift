//
//  FilterTableViewController.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 9/6/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background image
        let tempImageView = UIImageView(image: UIImage(named: "school.jpg"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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

}
