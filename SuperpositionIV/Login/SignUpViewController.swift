//
//  SignUpViewController.swift
//  SuperpositionIV
//
//  Created by Kemi Airewele on 2/29/20.
//  Copyright © 2020 Kemi Airewele. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var skinTypeControl: UISegmentedControl!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    let networkingService = NetworkingService()
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        
        firstNameTextField.underlined()
        emailTextField.underlined()
        passwordTextField.underlined()
        repeatPasswordTextField.underlined()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            repeatPasswordTextField.becomeFirstResponder()
        } else if textField == repeatPasswordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
        
    @IBAction func signUpUser(_ sender: Any) {
        
        // Check that text fields are not empty
        if (firstNameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (repeatPasswordTextField.text?.isEmpty)! {
            
            //Display Error Alert
            let alertController = UIAlertController(title: "Error", message: "Please make sure that all fields are filled in", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else if (passwordTextField.text?.count)! < 6 {
            let alertController = UIAlertController(title: "Error", message: "Password must be 6 characters long or more", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else if passwordTextField.text != repeatPasswordTextField.text {
            // Check that two Passwords are the Same
            let alertController = UIAlertController(title: "Error", message: "The passwords do not match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else if isValidEmail(testStr: emailTextField.text!) == false {
            let alertController = UIAlertController(title: "Error", message: "Email is not valid", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            // Sign up user
            self.networkingService.signUp(self.emailTextField.text!, name: self.firstNameTextField.text!, password: self.passwordTextField.text!, skinType: skinTypeControl.selectedSegmentIndex)

            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tabmainvc")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
            self.networkingService.signIn(self.emailTextField.text!, password: self.passwordTextField.text!)
            defaults.set(true, forKey:"LoggedIn")
            defaults.set(self.emailTextField.text, forKey:"userEmail")
            print(defaults.string(forKey: "userEmail"))
            userID = Auth.auth().currentUser?.uid
            defaults.synchronize()
        }
    }
    
        
}
