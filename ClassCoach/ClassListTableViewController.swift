//
//  ClassListTableViewController.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 9/6/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit
import LocalAuthentication

extension ClassListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class ClassListTableViewController: UITableViewController, EmojieViewControllerDelegate, UISearchBarDelegate {

    public var classList = [Student]()
    
    private var selectedRow = 0
    private var selectedStudent = Student()
    public var selectedEmojie = UIImage(named: "emojie_1.png")
    private var evc : EmojieViewController!
    let searchController = UISearchController(searchResultsController: nil)
    private var filterCancelled = false
    @IBOutlet weak var deleteAllView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.clearsSelectionOnViewWillAppear = false
        evc = storyboard?.instantiateViewController(withIdentifier: "emojieVC") as! EmojieViewController
        evc.delegate = self
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
       
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = DataHolder.sharedInstance.themeColor.cgColor
        searchController.searchBar.delegate = self;
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        //background image
        let tempImageView = UIImageView(image: UIImage(named: "main_background.jpg"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
        self.tableView.separatorStyle = .none;
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(deleteAll))
        deleteAllView.addGestureRecognizer(tap)
        
        //self.navigationController?.navigationBar.isTranslucent = true
        //UserDefaults.standard.removeObject(forKey: "launchedBefore")
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            showPrivacyAlert()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    override func viewDidAppear(_ animated: Bool){
        self.navigationController?.isNavigationBarHidden = false
        DataHolder.sharedInstance.classList.sort {
            if $0.nameLast != $1.nameLast {
                return $0.nameLast < $1.nameLast
            } else {
                return $0.nameFirst < $1.nameFirst
            }
        }
        if (!isAFilterActive()){
            classList = DataHolder.sharedInstance.classList
        }
        hideShowDeleteAllButton()
        tableView.reloadData()
    }
    
    private func hideShowDeleteAllButton(){
        if classList.count > 1 {
            deleteAllView.isHidden = false
        } else {
            deleteAllView.isHidden = true
        }
    }
    
    private func filter(list: [Student]){
        for student in DataHolder.sharedInstance.classList {
            var addStudent = false
            var meetsAllCriteria = true
            for filterCategory in DataHolder.sharedInstance.filters {
                if (DataHolder.sharedInstance.filters[filterCategory.key])!{
                    switch (filterCategory.key){
                    case FilterCategories.ELL :
                        if (student.hasELL) {
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case FilterCategories.FIVEOFOUR :
                        if (student.has504){
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case FilterCategories.GATE :
                        if (student.hasGATE){
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case FilterCategories.IEP :
                        if (student.hasIEP()){
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case .READING_HIGH:
                        if (student.levelReading == Student.levels.high) {
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case .MATH_HIGH:
                        if (student.levelMath == Student.levels.high) {
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case .WRITING_HIGH:
                        if (student.levelWriting == Student.levels.high) {
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case .READING_MIDDLE:
                        if (student.levelReading == Student.levels.medium) {
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case .READING_LOW:
                        if (student.levelReading == Student.levels.low) {
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case .MATH_MIDDLE:
                        if (student.levelMath == Student.levels.medium) {
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case .MATH_LOW:
                        if (student.levelMath == Student.levels.low) {
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case .WRITING_MIDDLE:
                        if (student.levelWriting == Student.levels.medium) {
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    case .WRITING_LOW:
                        if (student.levelWriting == Student.levels.low) {
                            addStudent = true
                        } else {
                            meetsAllCriteria = false
                            break
                        }
                    }
                }
                if DataHolder.sharedInstance.filterMode == 0 && addStudent {
                    classList.append(student)
                    break
                }
            }
            if DataHolder.sharedInstance.filterMode == 1 && meetsAllCriteria {
                classList.append(student)
            }
        }
    }
    
    public func applyFilter(){
        if (isAFilterActive()){
            classList = [Student]()
            filter(list: classList)
        }
        self.navigationItem.leftBarButtonItem?.title = "Clear Filter"
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "clearfilter.png")
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.title = "Filtered List"
//        for filterCategory in DataHolder.sharedInstance.filters {
//            if (DataHolder.sharedInstance.filters[filterCategory.key])!{
//                self.title?.append(filterCategory.key.toString(filterCategory: filterCategory.key) + " ")
//            }
//        }
    }
    
    public func doNormalLayout(){
        classList = DataHolder.sharedInstance.classList
        tableView.reloadData()
        self.navigationItem.leftBarButtonItem?.title = "Filter Options"
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "filter.png")
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.title = "Class List"
    }
    
    public func isAFilterActive() -> Bool {
        for filter in DataHolder.sharedInstance.filters {
            if (filter.value) {
                return true
            }
        }
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let controller = segue.destination as! DetailTableViewController
            controller.setCurrentStudent(currentStudent: selectedStudent)
            if selectedRow == -1 {
                controller.editMode = true
                controller.adding = true
            } else {
                controller.editMode = false
                controller.adding = false
            }
        }
//        } else if segue.identifier == "showFilters" {
//            if let filterVC = segue.destination as? FilterTableViewController {
//                filterVC.activeFilters = activeFilters
//            }
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        selectedStudent = classList[selectedRow]
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let student = classList[indexPath.row]
            removeStudent(student: student, index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            hideShowDeleteAllButton()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = classList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! ClassListTableViewCell
        cell.textLabel!.text = " \(student.nameLast!), \(student.nameFirst!)"
        cell.textLabel!.textColor = UIColor.white
        cell.contentView.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.4)
        cell.backgroundColor = UIColor.clear
        cell.imageView?.tag = indexPath.row
        
        let emojieButton = cell.emojieButton
        emojieButton?.isUserInteractionEnabled = true
        emojieButton?.image = UIImage(named: "emojie_\(student.emojieIconIndex+1).png")!
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        emojieButton?.addGestureRecognizer(tapGestureRecognizer)
        
        
        return cell
    }
    
    @IBAction func addStudent(_ sender: AnyObject) {
        let student = Student()
        selectedStudent = student
        selectedRow = -1
        classList.append(student)
        //update model
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    private func removeStudent(student: Student, index: Int){
        classList.remove(at: index)
        //update model
        DataHolder.sharedInstance.removeStudentFromClassList(student: student)
    }
    
    @objc public func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        _ = tapGestureRecognizer.view as! UIImageView
        
        selectedRow = (tapGestureRecognizer.view?.tag)!
        self.present(evc, animated: true, completion: nil)
    }
    
    func imageUpdated(imageIndex : Int) {
        selectedEmojie = UIImage(named: "emojie_\(imageIndex+1).png")!
        classList[selectedRow].emojieIconIndex = imageIndex
        DataHolder.sharedInstance.saveData()
        tableView.reloadData()
    }
    
    @IBAction func filterButtonAction(_ sender: AnyObject) {
        if navigationItem.leftBarButtonItem?.title == "Filter Options" {
            performSegue(withIdentifier: "showFilters", sender: self)
        } else {
            //clear filter
            DataHolder.sharedInstance.filters.removeAll()
            classList = DataHolder.sharedInstance.classList
            hideShowDeleteAllButton()
            doNormalLayout()
            tableView.reloadData()
        }
    }
    
    //search bar methods
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        classList = DataHolder.sharedInstance.classList.filter({( student : Student) -> Bool in
            if student.nameFirst.lowercased().contains(searchText.lowercased()) ||
                student.nameLast.lowercased().contains(searchText.lowercased()) || searchBarIsEmpty(){
                return true
            }
            return false
        })
        if filterCancelled {
            filterCancelled = false
            hideShowDeleteAllButton()
        } else {
            deleteAllView.isHidden = true
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterCancelled = true
    }
    
    @objc private func deleteAll() {
        let alertController = UIAlertController(title: "", message: "Delete entire class list?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            DataHolder.sharedInstance.classList.removeAll()
            self.classList = DataHolder.sharedInstance.classList
            self.tableView.reloadData()
            alertController.dismiss(animated: true, completion: nil)
            self.hideShowDeleteAllButton()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showPrivacyAlert(){
        var message = "This app securely encrypts entered data and never shares or trasmits data to any external sources. However, it is recommended that you do not save personally identifiable information and sensitive data without proper approval"
        if !(LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)) {
            message.append(", and that password protection is enabled for this device.")
        } else {
            message.append(".")
        }
        let alertController = UIAlertController(title: "Data Privacy Notice", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func helpButton(_ sender: Any) {
        let message = "\nThe add button on the top right creates a new student\n\nAfter adding a student, info on the detail screen becomes locked until you click the edit button\n\nYou can tap the emojie next to a student's name to change it\n\nThe funnel icon on the top left lets you filter the class list\n\nThe preferences button allows you to add authentication for increased security\n\n\u{2605} Please leave a review in the app store to give feedback \u{2605}\n\nThank you!"
        let alertController = UIAlertController(title: "Help", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        let rateAction = UIAlertAction(title: "Rate App", style: .default, handler: { (action: UIAlertAction!) in
            self.rateApp(appId: "1298270460", completion: { success in
                print("RateApp \(success)")
            })
        })
        alertController.addAction(action)
        alertController.addAction(rateAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/us/app/class-coach/id" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
}
