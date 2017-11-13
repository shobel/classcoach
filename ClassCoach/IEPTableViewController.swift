//
//  IEPTableViewController.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 10/8/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

class IEPTableViewController: UITableViewController {

    private var student : Student!
    @IBOutlet weak var readingSwitch: UISwitch!
    @IBOutlet weak var writingSwitch: UISwitch!
    @IBOutlet weak var mathSwitch: UISwitch!
    @IBOutlet weak var speechSwitch: UISwitch!
    @IBOutlet weak var otSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background image
        let tempImageView = UIImageView(image: UIImage(named: "purple_poly.png"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
        self.tableView.separatorStyle = .none;
        
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setData(){
        if (student != nil){
            readingSwitch.isOn = student.iepReading
            writingSwitch.isOn = student.iepWriting
            mathSwitch.isOn = student.iepMath
            speechSwitch.isOn = student.iepSpeech
            otSwitch.isOn = student.iepOT
        }
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "IEP", message: "Individualized Education Program: Defines the objectives of a child who has a learning disability in one or more areas, as defined by federal regulations. It is intended to help children reach educational goals", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func setCurrentStudent(currentStudent : Student){
        student = currentStudent
    }
    
    @IBAction func iepReadingAction(_ sender: AnyObject) {
        student.iepReading = sender.isOn
    }

    @IBAction func iepWritingAction(_ sender: AnyObject) {
        student.iepWriting = sender.isOn
    }
    
    @IBAction func iepMathAction(_ sender: AnyObject) {
        student.iepMath = sender.isOn
    }
    
    @IBAction func iepSpeechAction(_ sender: AnyObject) {
        student.iepSpeech = sender.isOn
    }
    
    @IBAction func iepOTAction(_ sender: AnyObject) {
        student.iepOT = sender.isOn
    }
    
}
