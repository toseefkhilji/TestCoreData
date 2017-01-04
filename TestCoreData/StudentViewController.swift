//
//  StudentViewController.swift
//  TestCoreData
//
//  Created by Toseefhusen Khilji on 02/01/17.
//  Copyright © 2017 Toseef Khilji. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController {

    // Constant for creating StudentViewController object from Storyboard
    static let storyboardName = "Main"
    static let viewControllerIdentifier = "StudentViewController"

    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    
    var student : Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if student != nil {
            self.txtFname.text = student?.firstName
            self.txtLname.text = student?.lastName
            self.txtAge.text = student?.age.stringValue
        }
    }

    
    @IBAction func saveTapped(_ sender: Any) {
        
        guard let fname = txtFname.text , fname.isBlank else{
            let alert = UIAlertController(title: "Enter Valid First Name")
            self.present(alert, animated: true, completion: nil)
            self.txtFname.becomeFirstResponder()
            return
        }
        
        guard let lname = txtLname.text, lname.isBlank , lname.trimmed.characters.count > 0 else{
            let alert = UIAlertController(title: "Enter Valid Last Name")
            self.present(alert, animated: true, completion: nil)
            self.txtLname.becomeFirstResponder()
            return
        }
        guard let age: Int = txtAge.text?.int, age > 0 else{
            let alert = UIAlertController(title: "Enter Valid age")
            let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                print("Tapped ok")
                self.txtAge.becomeFirstResponder()
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if student != nil {
            student?.firstName = fname
            student?.lastName = lname
            student?.age = Int16(age)
            DatabaseManager.saveContext()
            self.navigationController?.popViewController()
        }
        else{
            
            let stud : Student = Student(context: DatabaseManager.getContext())
            stud.firstName = fname
            stud.lastName = lname
            stud.age = Int16(age)
            DatabaseManager.saveContext()
            self.dismiss(animated: true, completion:nil)
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion:nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
