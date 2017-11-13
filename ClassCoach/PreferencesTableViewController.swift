//
//  PreferencesTableViewController.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 11/5/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

class PreferencesTableViewController: UITableViewController {

    @IBOutlet weak var authOnStartSwitch: UISwitch!
    @IBOutlet weak var authOnActiveSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //background image
        let tempImageView = UIImageView(image: UIImage(named: "red_poly.jpg"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
        self.tableView.separatorStyle = .none;
        
        if DataHolder.sharedInstance.authOnStart != nil {
            authOnStartSwitch.isOn = DataHolder.sharedInstance.authOnStart
        }
        if DataHolder.sharedInstance.authOnActive != nil {
            authOnActiveSwitch.isOn = DataHolder.sharedInstance.authOnActive
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //(view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.darkGray
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = DataHolder.sharedInstance.themeColor
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    @IBAction func authOnStart(_ sender: Any) {
        DataHolder.sharedInstance.authOnStart = (sender as AnyObject).isOn
    }
    
    @IBAction func authOnActive(_ sender: Any) {
        DataHolder.sharedInstance.authOnActive = (sender as AnyObject).isOn
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
