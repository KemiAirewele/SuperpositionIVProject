//
//  ViewController.swift
//  SuperpositionIV
//
//  Created by Kemi Airewele on 2/29/20.
//  Copyright © 2020 Kemi Airewele. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
  
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
   // var users = [CLUser]()
    var allProducts = [Products]()
    var filterProducts = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text!.isEmpty) {
            collectionView.reloadData()
        } else {
            filterContentForSearchText(searchText: searchBar.text!)
            
        }
    }
    
    /*  if self.mySearchBar.text!.isEmpty {
     
     // set searching false
     self.isSearching = false
     
     }else{
     
     // set searghing true
     self.isSearching = true
     
     self.names.removeAll()
     self.uidArray.removeAll()
     self.imageUrl.removeAll()
     
     for key in self.sarchDict {
     
     let mainKey = key
     //I am making query against email in snapshot dict
     
     
     let str = key["email"] as? String
     
     //taking value of email from my dict lowerCased to make query as case insensitive
     
     let lowercaseString = str?.lowercased()
     //checking do my any email have entered letter or not
     if(lowercaseString?.hasPrefix(self.mySearchBar.text!.lowercased()))!{
     
     //here I have a check so to remove value of current logged user
     if ((key["uID"] as! String) != (Auth.auth().currentUser?.uid)!){
     
     //If value is found append it in some arrays
     self.imageUrl.append( key["profilePic"] as! String )
     self.names.append( key["name"] as! String )
     self.uidArray.append( key["uID"] as! String )
     
     //you can check which values are being added from which key
     print(mainKey)
     
     }
     }
     }
     //reload TableView here
     }*/
    // }
    
    /*   func fetchUsers() {
     self.users.removeAll()
     let query = ref.child("users").queryOrdered(byChild: "username").queryStarting(atValue: searchBar.text)
     query.observe(.value) { (snapshot) in
     for child in snapshot.children.allObjects as! [DataSnapshot] {
     if let value = child.value as? NSDictionary {
     var user = CLUser(snapshot: snapshot)
     let name = value["fullName"] as? String ?? "Name not found"
     let username = value["username"] as? String ?? "Email not found"
     user.fullName = name
     user.username = username
     self.users.append(user)
     DispatchQueue.main.async {
     self.collectionView.reloadData()
     print(self.users)
     }
     }
     }
     }
     }*/
    
    func fetchUser() {
        self.allProducts = [Users]()
        if let myID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let user = Users()
                    user.setValuesForKeys(dictionary)
                    user.uid = snapshot.key
                    
                    /*
                     If the user isn't me, go into my connections and see if they already follow me. - If there is a 1, they follow me, Show the unadd button.
                     - If they aren't there then show the add button
                     */
                    
                    if user.uid != myID {
                        let connectionRef = self.ref.child("connections").child(myID)
                        connectionRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            
                            if let dictionary = snapshot.value as? [String: AnyObject] {
                                // Check if they are already added
                                
                                var canAdd: Bool
                                canAdd = true
                                
                                for(key,value) in dictionary {
                                    if value as? Int == 1  && user.uid == key {
                                        canAdd = false
                                        
                                    }
                                }
                                
                                if canAdd && !self.allusers.contains(user) {
                                    self.allusers.append(user)
                                    print("Add Possible", user.name!, user.username!)
                                    user.canAdd = true
                                } else if !canAdd && !self.allusers.contains(user) {
                                    self.allusers.append(user)
                                    print("Already added", user.name!, user.username!)
                                    user.canAdd = false
                                }
                            } else {
                                // Have no relationship, can add user.
                                if !self.allusers.contains(user){
                                    self.allusers.append(user)
                                    print("2. No relationship", user.name!, user.username!)
                                }
                            }
                            
                            DispatchQueue.global().async {
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                            }
                        })
                    }
                }
            })
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filterProducts = allProducts.filter { (allusers) -> Bool in
            return (allusers.username?.localizedLowercase.contains(searchText.localizedLowercase))!
        }
        filterProducts.forEach { (user) in
            print(user.username!)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchBar.text != "" {
            print(filterProducts.count)
            self.collectionView.backgroundView = .none
            return filterProducts.count
        } else {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "Search by username above"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.collectionView.backgroundView = emptyLabel
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddUserCell", for: indexPath) as! UsersCollectionViewCell
        let user: Users
        if searchBar.text != "" {
            user = filterProducts[indexPath.row]
        } else {
            user = allProducts[indexPath.row]
        }
        
        cell.fullNameLabel.text = user.name
        cell.usernameLabel.text = "@\(user.username!)"
        cell.addUserButton.indexPath = indexPath as NSIndexPath
        cell.addUserButton.borderWidth = 1
        
        if (user.canAdd!) {
            cell.addUserButton.setTitle("Add", for: .normal)
            cell.addUserButton.setTitleColor(.white, for: .normal)
            cell.addUserButton.backgroundColor = .systemGreen
            cell.addUserButton.borderColor = .clear
        } else {
            cell.addUserButton.setTitle("Added", for: .normal)
            cell.addUserButton.setTitleColor(.label, for: .normal)
            cell.addUserButton.borderColor = .label
            cell.addUserButton.backgroundColor = .clear
        }
        //For Image
        storageRef.reference(forURL: user.photoURL!).getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let data = data {
                    cell.profileImageView.image = UIImage(data: data)
                }
            }
        })
        return cell
    }
    
    @IBAction func addUserButton(_ sender: RoundButton) {
        let user: Users
        let indexPath: NSIndexPath = sender.indexPath
        
        if self.searchBar.text != "" {
            user = self.filterUsers[indexPath.row]
        } else {
            user = self.allusers[indexPath.row]
        }
        
        let fromID = (Auth.auth().currentUser?.uid)!
        let toID = user.uid!
        
        if (user.canAdd!) {
            // "1": user is now following them
            let newConnectionRef = Database.database().reference().child("connections").child(fromID)
            newConnectionRef.updateChildValues([toID : 1])
            print("Connection added")
            
            // Change Button text to say Added
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddUserCell", for: indexPath as IndexPath) as! ProductsCollectionViewCell
            cell.addUserButton.setTitle("Added", for: .normal)
            cell.addUserButton.setTitleColor(UIColor.gray, for: .normal)
        } else {
            // Already Added
            let newConnectionRef = Database.database().reference().child("connections").child(fromID)
            newConnectionRef.updateChildValues([toID : 0])
            print("Connection removed")
            
            // Change Button text to say Added
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddUserCell", for: indexPath as IndexPath) as! ProductsCollectionViewCell
            cell.addUserButton.setTitle("Add", for: .normal)
            cell.addUserButton.setTitleColor(.systemGreen, for: .normal)
        }
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
