//
//  DetailTableViewController.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 9/6/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
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
    @IBOutlet weak var pickerRW: UIPickerView!
    @IBOutlet weak var selectorMath: UISegmentedControl!
    @IBOutlet weak var selectorWriting: UISegmentedControl!
    
    //traits
    @IBOutlet weak var selectorBehavior: UISegmentedControl!
    @IBOutlet weak var selectorIndependence: UISegmentedControl!
    
    //parents
    @IBOutlet weak var switchDifficult: UISwitch!
    @IBOutlet weak var switchHelpful: UISwitch!
    @IBOutlet weak var switchDivorced: UISwitch!
    
    //after clicking Done, editMode becomes false and all fields are locked
    public var editMode:Bool = true {
        didSet {
            editModeChanged()
        }
    }
    public var adding:Bool = false
    public var student = Student()
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView504.delegate = self
        
        initTextView504()
        initPicker()
        setData()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            validate()
        }
    }
    
    private func validate(){
        changedFirstName()
        changedLastName()
        if (student.nameFirst == "" || student.nameLast == ""){
            DataHolder.sharedInstance.removeStudentFromClassList(student: student)
        } else if adding {
            DataHolder.sharedInstance.classList.append(self.student)
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
    
    private func initPicker(){
        pickerRW.delegate = self
        pickerRW.dataSource = self
        
        for char in "ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters {
            pickerData.append(String(char))
        }
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
        pickerRW.selectRow(pickerData.index(of: student.levelRW)!, inComponent: 0, animated: false)
        selectorBehavior.selectedSegmentIndex = Student.levelsArray.index(of: student.behavior)!
        selectorIndependence.selectedSegmentIndex = Student.levelsArray.index(of: student.independence)!
        switchDifficult.isOn = student.parentDifficult
        switchHelpful.isOn = student.parentHelpful
        switchDivorced.isOn = student.parentDivorced
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath == cellIndexPath504 && switch504.isOn {
            return CGFloat(rowHeight504)
        }
        return tableView.rowHeight
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setCellsEditable(editable: editMode)
    }
    
    private func editModeChanged(){
        let button = self.navigationItem.rightBarButtonItem
        if editMode {
            button?.title = "Done"
        } else {
            button?.title = "Edit"
        }
        setCellsEditable(editable: editMode)
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
            delay = 0
            alertController.message = "\n\nStudent Saved\n\n\n"
        } else {
            alertController.message = "\n\nInfo Editable\n\n\n"
        }
        presentAndDismissAlert(alertController: alertController, delay: delay)
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func changedFirstName(_ sender: AnyObject) {
        changedFirstName()
    }

    @IBAction func changedLastName(_ sender: AnyObject) {
        changedLastName()
    }
    
    private func changedFirstName(){
        student.nameFirst = fieldFirstName.text!.capitalized
    }
    
    private func changedLastName(){
        student.nameLast = fieldLastName.text!.capitalized
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        student.levelRW = pickerData[row]
    }
    
    @IBAction func changedMathLevel(_ sender: AnyObject) {
        student.levelMath = Student.levelsArray[selectorMath.selectedSegmentIndex]
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
    
}
