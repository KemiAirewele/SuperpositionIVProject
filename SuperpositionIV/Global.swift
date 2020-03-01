//
//  Global.swift
//  SuperpositionIV
//
//  Created by Kemi Airewele on 2/29/20.
//  Copyright © 2020 Kemi Airewele. All rights reserved.
//

import Foundation
import UIKit
import Firebase

let defaults = UserDefaults.standard
var userID = Auth.auth().currentUser?.uid


extension UITextField {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
       /* self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.])*/
}

}

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

var databaseRef: DatabaseReference! {
    return Database.database().reference()
}

var storageRef: Storage {
    return Storage.storage()
}

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

class Products: NSObject {
    @objc var forSkinType: [String: Bool]?
    @objc var ingredients: [String: Bool]?
    @objc var type: String?
    var canAdd: Bool?
}
