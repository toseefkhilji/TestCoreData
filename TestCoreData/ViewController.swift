//
//  ViewController.swift
//  TestCoreData
//
//  Created by Toseefhusen Khilji on 30/12/16.
//  Copyright © 2016 Toseef Khilji. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UISearchControllerDelegate {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var arrayStudents : [Student] = []
    var filteredTableData = [Student]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Student Entity
//        let student : Student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: DatabaseManager.persistentContainer.viewContext)
        
        self.tableview.allowsMultipleSelectionDuringEditing = false
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load students from Coredata
        loadStudents()
    }
    
    /// Method used to load students from CoreData
    func loadStudents() -> () {
        
        // Create fetch request for Student Entity
        let fetchRequest  : NSFetchRequest <Student> = Student.fetchRequest()
        
        do{
            
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "age", ascending: true)]

            // Execute fetch request
            let searchResults = try DatabaseManager.getContext().fetch(fetchRequest)
            
            // Update student array with new result
            self.arrayStudents = searchResults
            
            for result in searchResults as [Student] {
                print("Name :\(result.displayName())")
            }
            
            self.tableview.reloadData()
        }
        catch{
            // Handle Error
            print("Error:\(error)")
        }
    }

    // MARK: - Custom Action methods

    @IBAction func addItem(_ sender: Any) {
        
        // Getting ViewController using UIViewcontroller Extension
        let studVC = UIViewController.viewController(instoryboard: "Main", withController: "StudentViewController")
        
        // Another way of getting View controller
//        let storyboard = UIStoryboard(name: StudentViewController.storyboardName, bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: StudentViewController.viewControllerIdentifier) as! StudentViewController
        
        
        self.present(studVC, animated: true, completion: { print("Presentation Done")})
    }
    
    // Method is callled when search button bar item is tapped.
    @IBAction func searchTapped(_ sender: Any) {
        
        guard !self.resultSearchController.isActive else {
            print("Already Presented")
            return
        }
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            self.definesPresentationContext = true
            controller.delegate = self
            controller.searchResultsUpdater = self
            controller.searchBar.delegate = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.default
            controller.searchBar.barTintColor = UIColor.red
            controller.searchBar.backgroundColor = UIColor.clear
            self.navigationItem.titleView = controller.searchBar
            return controller
        })()
        self.navigationItem.titleView = resultSearchController.searchBar
        resultSearchController.searchBar.becomeFirstResponder()
        searchButton.hidden = true
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detail" {
            
            let stud : StudentViewController = segue.destination as! StudentViewController
            let index  = self.tableview.indexPathForSelectedRow! as IndexPath
            stud.student = arrayStudents[index.row] as Student
        }
    }
}


// MARK: - UITableView DataSource extension
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive {
            return self.filteredTableData.count
        }else{
            return self.arrayStudents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "cellId"
        let  cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        // Get Student Entity from respective array
//        let stud = resultSearchController.isActive ? filteredTableData[indexPath.row] : self.arrayStudents[indexPath.row]
        
        let stud : Student?
        if self.resultSearchController.isActive {
             stud = filteredTableData[indexPath.row]
        }
        else{
            stud = self.arrayStudents[indexPath.row] 
        }
        
        cell.textLabel?.text = stud?.displayName()
        cell.detailTextLabel?.text = stud?.age.stringValue
        
        return cell
    }
    
}

// MARK: - UITableView DataSource Extension
extension ViewController : UITableViewDelegate {
    
    private func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if !self.resultSearchController.isActive {
        return true
        }
        return false
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            //add code here for when you hit delete
            let stud = arrayStudents[indexPath.row]
            
            let isDeleted = DatabaseManager.delete(student: stud)
            
            if isDeleted {
                let alert = UIAlertController(title: "Deleted")
                alert.show()
                arrayStudents.remove(at: indexPath.row)
                tableview.reloadData()
            }
            else{
                print(" Not Deleted")
            }
        }
    }
}


extension ViewController : UISearchResultsUpdating ,UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController)  {
        
        guard let searchString = searchController.searchBar.text , searchString.isBlank else {
            print("Blank  search String")
            return
        }
        // Remove data form filteredTableData
        filteredTableData.removeAll()
        
        // Set NSPredicate for filter data
        let searchPredicate2 = NSPredicate(format: "firstName CONTAINS[c] %@ || lastName CONTAINS[c] %@", searchString,searchString)
        let array2 = (arrayStudents as NSArray).filtered(using: searchPredicate2)
        filteredTableData = array2 as! [Student]
        
        self.tableview.reloadData()
    }
    
    
    func didDismissSearchController(_ searchController: UISearchController) {

        searchButton.hidden = false
        self.navigationItem.titleView = nil
        self.tableview.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        self.navigationItem.titleView = nil
        searchButton.hidden = false
        resultSearchController.isActive = false;
        self.tableview.reloadData()
    }
}

