//
//  ProfileViewController.swift
//  SuperpositionIV
//
//  Created by Chloe Yan on 3/1/20.
//  Copyright © 2020 Kemi Airewele. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut(_ sender: Any) {
        networkingService.signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "startvc")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        userID = nil
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
