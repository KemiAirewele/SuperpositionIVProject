//
//  AddProductsViewController.swift
//  SuperpositionIV
//
//  Created by Kemi Airewele on 3/1/20.
//  Copyright © 2020 Kemi Airewele. All rights reserved.
//

import UIKit
import Firebase

class AddProductsViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    var allProducts = [Products]()
    var filterProducts = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProduct()
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text!.isEmpty) {
            collectionView.reloadData()
        } else {
            filterContentForSearchText(searchText: searchBar.text!)
            
        }
    }
    
    
    
    func fetchProduct() {
        self.allProducts = [Products]()
        if let myID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(myID).child("products").observe(.childAdded, with: { (snapshot) in
                let product = Products()
                product.name = snapshot.key
                product.canAdd = snapshot.value as! Int
                
                print("User Product:", product.name)
                
             /*  Database.database().reference().child("products").child(product.name!).observe(.childAdded, with: { (productSnapshot) in
                    if let dictionary = productSnapshot.value as? [String: AnyObject] {
                        var skinTypes = [String]
                        var ingredients
                        product.setValuesForKeys(dictionary)
                      print("Product Info:", product.canAdd, product.type, product.name)
                    }
                    })*/

            
            })
        }
    }
            
                /*    var canAdd: Bool
                    canAdd = true
                    
                    for (key,value) in dictionary {
                        if value as? Int == 1  && product.name == key {
                            canAdd = false
                        }
                    }
                    
                    if canAdd && !self.allProducts.contains(product) {
                        self.allProducts.append(product)
                        print("Add Possible", product.name!)
                        product.canAdd = true
                    } else if !canAdd && !self.allProducts.contains(product) {
                        self.allProducts.append(product)
                        print("Already added", product.name!)
                        product.canAdd = false
                    }
                } else {
                    // Have no relationship, can add user.
                    if !self.allProducts.contains(product){
                        self.allProducts.append(product)
                        print("2. No relationship", product.user!)
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
        }*/
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filterProducts = allProducts.filter { (allProducts) -> Bool in
            return (allProducts.name?.localizedLowercase.contains(searchText.localizedLowercase))!
        }
        filterProducts.forEach { (product) in
            print(product.name!)
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
            emptyLabel.text = "Search by product name above"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.collectionView.backgroundView = emptyLabel
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProductCell", for: indexPath) as! ProductsCollectionViewCell
        let product: Products
        if searchBar.text != "" {
            product = filterProducts[indexPath.row]
        } else {
            product = allProducts[indexPath.row]
        }
        
        //cell.productName.text = product.
        cell.productType.text = "@\(product.type!)"
        cell.addProductButton.indexPath = indexPath as NSIndexPath
        cell.addProductButton.borderWidth = 1
        
        if (product.canAdd == 0) {
            cell.addProductButton.setTitle("Add", for: .normal)
            cell.addProductButton.setTitleColor(.white, for: .normal)
            cell.addProductButton.backgroundColor = .systemGreen
            cell.addProductButton.borderColor = .clear
        } else {
            cell.addProductButton.setTitle("Added", for: .normal)
            cell.addProductButton.setTitleColor(.label, for: .normal)
            cell.addProductButton.borderColor = .label
            cell.addProductButton.backgroundColor = .clear
        }

        return cell
    }
    
    @IBAction func addProductButton(_ sender: RoundButton) {
        let user: Products
        let indexPath: NSIndexPath = sender.indexPath
        
        if self.searchBar.text != "" {
            user = self.filterProducts[indexPath.row]
        } else {
            user = self.allProducts[indexPath.row]
        }
        
       // let fromID = (Auth.auth().currentUser?.uid)!
        //let toID = user.uid!
        
       /* if (user.canAdd!) {
            // "1": user is now following them
            let newConnectionRef = Database.database().reference().child("connections").child(fromID)
            newConnectionRef.updateChildValues([toID : 1])
            print("Connection added")
            
            // Change Button text to say Added
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddUserCell", for: indexPath as IndexPath) as! ProductsCollectionViewCell
            cell.addProductButton.setTitle("Added", for: .normal)
            cell.addProductButton.setTitleColor(UIColor.gray, for: .normal)
        } else {
            // Already Added
            let newConnectionRef = Database.database().reference().child("connections").child(fromID)
            newConnectionRef.updateChildValues([toID : 0])
            print("Connection removed")
            
            // Change Button text to say Added
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddUserCell", for: indexPath as IndexPath) as! ProductsCollectionViewCell
            cell.addProductButton.setTitle("Add", for: .normal)
            cell.addProductButton.setTitleColor(.systemGreen, for: .normal)
        }
        */
        
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
