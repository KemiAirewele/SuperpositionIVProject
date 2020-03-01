//
//  ProfileViewController.swift
//  SuperpositionIV
//
//  Created by Chloe Yan on 3/1/20.
//  Copyright © 2020 Kemi Airewele. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    let networkingService = NetworkingService()
    let userRef = databaseRef.child("users").child(userID!)
    var userProducts = [Products]()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var skinTypeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        userRef.observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = Users()
                user.setValuesForKeys(dictionary)
                user.uid = snapshot.key
                
                self.emailLabel.text = user.email!
                var skinType: String?
                
                switch user.skinType {
                    case "0":
                    skinType = "Dry"
                    case "1":
                    skinType = "Normal"
                    case "2":
                    skinType = "Oily"
                    default:
                    skinType = "Not Selected"
                }
                
                self.skinTypeLabel.text = skinType
            }
        })
        
        productfetch()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut(_ sender: Any) {
        networkingService.signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "startvc")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        userID = nil
    }

    func productfetch() {
        if let myID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("userProducts").child(myID).observe(.childAdded, with: { (snapshot) in
                let product = Products()
                product.name = snapshot.key
                
                Database.database().reference().child("products").child(product.name!).observe(.value, with: { (productSnap) in
                    for child in productSnap.children {
                        let snap = child as! DataSnapshot
                        if snap.key == "type" {
                            product.type = snap.value as? String
                            self.userProducts.append(product)
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                
                })
                
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductsCollectionViewCell
        let product: Products
        product = userProducts[indexPath.row]
        
        cell.productName.text = product.name
        cell.productType.text = product.type
        
        return cell
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
