//
//  DetailTableViewController.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 9/6/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {
    
    //need these to dynamic manipulate size of 504 cell
    let rowHeight504 = 150
    var cellIndexPath504: IndexPath = IndexPath(row:1, section:1)
    
    //general
    @IBOutlet weak var fieldLastName: UITextField!
    @IBOutlet weak var fieldFirstName: UITextField!
    @IBOutlet weak var selectorGender: UISegmentedControl!
    
    //plans
    @IBOutlet weak var detailIep: UILabel!
    @IBOutlet weak var switch504: UISwitch!
    @IBOutlet weak var tableViewCell504: UITableViewCell!
    @IBOutlet weak var textView504: UITextView!
    @IBOutlet weak var switchGate: UISwitch!
    @IBOutlet weak var switchEll: UISwitch!
    
    //skills
    @IBOutlet weak var selectorReading: UISegmentedControl!
    @IBOutlet weak var selectorMath: UISegmentedControl!
    @IBOutlet weak var selectorWriting: UISegmentedControl!
    @IBOutlet weak var fieldRW: UITextField!
    
    //traits
    @IBOutlet weak var selectorBehavior: UISegmentedControl!
    @IBOutlet weak var selectorIndependence: UISegmentedControl!
    
    //parents
    @IBOutlet weak var switchDifficult: UISwitch!
    @IBOutlet weak var switchHelpful: UISwitch!
    @IBOutlet weak var switchDivorced: UISwitch!

    @IBOutlet weak var cellIEP: UITableViewCell!
    @IBOutlet weak var cell504: UITableViewCell!
    @IBOutlet weak var cellGATE: UITableViewCell!
    @IBOutlet weak var cellELL: UITableViewCell!
    
    //after clicking Done, editMode becomes false and all fields are locked
    public var editMode:Bool = true {
        didSet {
            editModeChanged()
        }
    }
    public var adding:Bool = false
    public var shouldCheckDups = false
    public var student = Student()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.hideKeyboard()
        fieldLastName.delegate = self
        fieldFirstName.delegate = self
        textView504.delegate = self
        fieldRW.delegate = self
        
        //background image
        let tempImageView = UIImageView(image: UIImage(named: "yellow_gradient.jpg"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        view.addGestureRecognizer(tap)
//        view.isUserInteractionEnabled = true
        
        initTextView504()
        setData()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            if validate() {
                if adding {
                    DataHolder.sharedInstance.classList.append(self.student)
                }
                //DataHolder.sharedInstance.saveData()
            } else {
                DataHolder.sharedInstance.removeStudentFromClassList(student: student)
            }
        }
    }
    
    private func validate() -> Bool{
        changedFirstName()
        changedLastName()
        if (student.nameFirst == "" || student.nameLast == ""){
            return false
        } else if adding && checkIfStudentExists(){
            return false
        } else {
            return true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let iepvc = segue.destination as! IEPTableViewController
        iepvc.setCurrentStudent(currentStudent: student)
    }
    
    public func setCurrentStudent(currentStudent : Student){
        student = currentStudent
    }
    
    private func initTextView504(){
        textView504.text = "Enter any notes"
        textView504.textColor = UIColor.lightGray
        textView504.layer.borderWidth = 1
        textView504.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setData(){
        fieldFirstName.text = student.nameFirst
        fieldLastName.text = student.nameLast
        selectorGender.selectedSegmentIndex = Student.genderArray.index(of: student.gender)!
        detailIep.text = student.getIepServices()
        switch504.isOn = student.has504
        if switch504.isOn {
            textView504.text = student.notes504
            if textView504.text.isEmpty {
                initTextView504()
            }
        }
        switchGate.isOn = student.hasGATE
        switchEll.isOn = student.hasELL
        selectorReading.selectedSegmentIndex = Student.levelsArray.index(of: student.levelReading)!
        selectorWriting.selectedSegmentIndex = Student.levelsArray.index(of: student.levelWriting)!
        selectorMath.selectedSegmentIndex = Student.levelsArray.index(of: student.levelMath)!
        fieldRW.text = student.levelRW // do picker
        selectorBehavior.selectedSegmentIndex = Student.levelsArray.index(of: student.behavior)!
        selectorIndependence.selectedSegmentIndex = Student.levelsArray.index(of: student.independence)!
        switchDifficult.isOn = student.parentDifficult
        switchHelpful.isOn = student.parentHelpful
        switchDivorced.isOn = student.parentDivorced
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (editMode){
            (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
            (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.darkGray
        } else {
            (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.darkGray
            (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        var title = ""
        var message = ""
        switch (indexPath.row){
        case 1:
            title = "504"
            message = "For students with disabilities who do not require specialized instruction but need to recieve accomodations or services to ensure academic success"
        case 2:
            title = "GATE"
            message = "Gifted and Talented Education: Program designed to address the learning styles of the students who have been identified as gifted and talented"
        case 3:
            title = "ELL"
            message = "English Language Learner: Student who is unable to communicate fluently or learn effectively in English. Often comes from a non-English-speaking home and typically requires specialized instruction"
        default:
            title = "Info"
            message = "Special Education Plan"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var selectorColor = DataHolder.sharedInstance.themeColor
        if (!editMode) {
            selectorColor = UIColor.darkGray
            cell.accessoryType = UITableViewCellAccessoryType.none
        } else {
            if (cell == cellIEP) {
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else if (cell == cell504 || cell == cellGATE || cell == cellELL) {
                cell.accessoryType = UITableViewCellAccessoryType.detailButton
            }
        }
        selectorGender?.tintColor = selectorColor
        selectorReading?.tintColor = selectorColor
        selectorWriting?.tintColor = selectorColor
        selectorMath?.tintColor = selectorColor
        selectorBehavior?.tintColor = selectorColor
        selectorIndependence?.tintColor = selectorColor
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath == cellIndexPath504 && switch504.isOn {
            return CGFloat(rowHeight504)
        }
        return tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setCellsEditable(editable: editMode)
    }
    
    private func editModeChanged(){
        let button = self.navigationItem.rightBarButtonItem
        if editMode {
            button?.title = "Done"
            //navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 18.0)!], for: UIControlState.normal)
        } else {
            button?.title = "Edit"
            //navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 22.0)!], for: UIControlState.normal)
        }
        setCellsEditable(editable: editMode)
        tableView.reloadData()
    }
    
    @IBAction func doneEditButtonAction(_ sender: AnyObject) {
        editMode = !editMode
        let alertController = UIAlertController(title: "", message: "\n\n\nInfo Locked\n\n\n\n", preferredStyle: .alert)
        
        var delay = 1
        if ((fieldFirstName.text?.isEmpty)! || (fieldLastName.text?.isEmpty)!){
            editMode = !editMode
            delay = -1
            alertController.message = "\nEnter a first and last name\n\n"
        } else if !editMode {
            if (adding || shouldCheckDups) && checkIfStudentExists() {
                editMode = !editMode
                delay = -1
                alertController.message = "\nStudent with this name already exists\n\n"
            } else {
                delay = 0
                alertController.message = "\n\nStudent Saved\n\n\n"
            }
        } else {
            alertController.message = "\n\nInfo Editable\n\n\n"
        }
        presentAndDismissAlert(alertController: alertController, delay: delay)
    }
    
    private func checkIfStudentExists() -> Bool{
        var numMatches = 0
        for savedStudent in DataHolder.sharedInstance.classList {
            if savedStudent.nameFirst == student.nameFirst && savedStudent.nameLast == student.nameLast {
                numMatches+=1
                if (numMatches >= 2){
                    return true
                }
            }
        }
        return false
    }
    
    private func presentAndDismissAlert(alertController : UIAlertController, delay : Int){
        if (delay == -1){
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        } else {
            if (delay > 0) {
                self.present(alertController, animated: true, completion: nil)
                let when = DispatchTime.now() + .seconds(delay)
                DispatchQueue.main.asyncAfter(deadline: when){
                    alertController.dismiss(animated: true, completion: nil)
                    if (!self.editMode){
                        self.navigationController!.popViewController(animated: true)
                    }
                }
            } else {
                if (!self.editMode){
                    self.navigationController!.popViewController(animated: true)
                }
            }
        }
    }
    
    private func setCellsEditable(editable : Bool){
        let cells = self.tableView.visibleCells
        
        for cell in cells {
            if cell.isUserInteractionEnabled == !editable{
                cell.isUserInteractionEnabled = editable
            }
        }
    }
    
    /* placeholder text functions for 504 notes */
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView504.textColor == UIColor.lightGray {
            textView504.text = ""
            textView504.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView504.text.isEmpty {
            initTextView504()
        }
        student.notes504 = textView504.text
    }
    
    // functions for RW picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func changedFirstName(_ sender: AnyObject) {
        if (student.nameFirst != fieldFirstName.text) {
            changedFirstName()
        }
    }

    @IBAction func changedLastName(_ sender: AnyObject) {
        if (student.nameLast != fieldLastName.text?.trimmingCharacters(in: .whitespaces)) {
            changedLastName()
        }
    }
    
    private func changedFirstName(){
        fieldFirstName.text = fieldFirstName.text?.trimmingCharacters(in: .whitespaces).capitalized
        student.nameFirst = fieldFirstName.text
        shouldCheckDups = true
    }
    
    private func changedLastName(){
        fieldLastName.text = fieldLastName.text?.trimmingCharacters(in: .whitespaces).capitalized
        student.nameLast = fieldLastName.text
        shouldCheckDups = true
    }
    
    @IBAction func changedGender(_ sender: AnyObject) {
        student.gender = Student.genderArray[selectorGender.selectedSegmentIndex]
    }
        
    @IBAction func changed504(_ sender: AnyObject) {
        student.has504 = switch504.isOn
        let switchState = switch504.isOn
        textView504.isHidden = !switchState
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func changedGate(_ sender: AnyObject) {
        student.hasGATE = switchGate.isOn
    }
    
    @IBAction func changedELL(_ sender: AnyObject) {
        student.hasELL = switchEll.isOn
    }
    
    @IBAction func changedReadingLevel(_ sender: AnyObject) {
        student.levelReading = Student.levelsArray[selectorReading.selectedSegmentIndex]
    }
    
    @IBAction func changedMathLevel(_ sender: AnyObject) {
        student.levelMath = Student.levelsArray[selectorMath.selectedSegmentIndex]
    }
    
    @IBAction func changedRW(_ sender: Any) {
        student.levelRW = fieldRW.text?.trimmingCharacters(in: .whitespaces).capitalized
    }
    
    @IBAction func changedWritingLevel(_ sender: AnyObject) {
        student.levelWriting = Student.levelsArray[selectorWriting.selectedSegmentIndex]
    }
        
    @IBAction func changedBehavior(_ sender: AnyObject) {
        student.behavior = Student.levelsArray[selectorBehavior.selectedSegmentIndex]
    }

    @IBAction func changedIndependence(_ sender: AnyObject) {
        student.independence = Student.levelsArray[selectorIndependence.selectedSegmentIndex]
    }
    
    @IBAction func changedParentIsDifficult(_ sender: AnyObject) {
        student.parentDifficult = switchDifficult.isOn
    }
    
    @IBAction func changedParentIsHelpful(_ sender: AnyObject) {
        student.parentHelpful = switchHelpful.isOn
    }
    
    @IBAction func changedParentIsDivorced(_ sender: AnyObject) {
        student.parentDivorced = switchDivorced.isOn
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if (!editMode) {
           let alertController = UIAlertController(title: "", message: "Data is protected.\nDo you want to edit?\n", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.doneEditButtonAction(self)
                alertController.dismiss(animated: true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
