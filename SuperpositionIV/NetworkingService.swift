//
//  NetworkingService.swift
//  SuperpositionIV
//
//  Created by Kemi Airewele on 2/29/20.
//  Copyright © 2020 Kemi Airewele. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import UIKit

struct NetworkingService {
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: StorageReference {
        return Storage.storage().reference()
    }
    
    // 3 -- Saving the User Info in the Database
    fileprivate func saveInfo(_ user: User!, name: String, password: String, skinType: Int) {
        
        // Create our user dictionary info\
        let userInfo = ["email": user.email!, "name": name, "uid": user.uid, "skinType": skinType] as [String : Any]

        // Create User Reference
        
        let userRef = databaseRef.child("users").child(user.uid)
        
        //Save the user Info in the Database
        
        userRef.setValue(userInfo)
        
        signIn(user.email!, password: password)
        
    }
    // 4 -- Sign In
    func signIn(_ email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                
                if let user = user {
                    print("\(user.user.displayName) has signed in!")
                    
                }
            } else {
                print(error!.localizedDescription)
                
            }
        })
    }
    
    // 2 -- Set User Info
    fileprivate func setUserInfo(_ user: User!, name: String, password: String, skinType: Int){
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: { (error) in
            if error == nil {
                
                self.saveInfo(user, name: name, password: password, skinType: skinType)
                
            } else{
                print(error!.localizedDescription)
            }
        })
    }
    
    // 1-- We Create the User
    func  signUp(_ email: String, name: String, password: String, skinType: Int) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                
                self.setUserInfo(user?.user, name: name, password: password, skinType: skinType)
                
            } else {
                print(error!.localizedDescription)
                
            }
        })
    }
    
    // Reset Password
    func resetPassword(_ email: String){
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            
            if error == nil {
                print("An email with information on how to reset your password has been sent to you. Thank You")
            } else {
                print(error!.localizedDescription)
            }
            
        })
        
    }
    
    func updateEmail(_ email: String, oldEmail: String, password: String){
        
        let user = Auth.auth().currentUser
        var credential: AuthCredential
        
        // Prompt the user to re-provide their sign-in credentials
        credential = EmailAuthProvider.credential(withEmail: oldEmail, password: password)
        
        user?.reauthenticate(with: credential, completion: { (authResult, error) in
            if let error = error {
                // An error happened.
                print(error.localizedDescription)
            } else {
                // User re-authenticated.
                Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
                    
                    if error == nil {
                        print("Email has been updated")
                    } else {
                        print(error!.localizedDescription)
                        
                    }
                    
                })
            }
        })
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut();
            defaults.set(false, forKey:"LoggedIn")
            defaults.removeObject(forKey: "userEmail")
            defaults.synchronize()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    
}
