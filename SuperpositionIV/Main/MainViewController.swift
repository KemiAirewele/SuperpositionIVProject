//
//  MainViewController.swift
//  SuperpositionIV
//
//  Created by Kemi Airewele on 2/29/20.
//  Copyright © 2020 Kemi Airewele. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let networkingService = NetworkingService()
    var acneImage: UIImage!
    var imagePicker: UIImagePickerController!

    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func photoFromRoll(_ sender: Any) {
        
        self.getImage(fromSourceType: .photoLibrary)

    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        self.getImage(fromSourceType: .camera)
    }
    
    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true) {
            self.performSegue(withIdentifier: "photoObtained", sender: nil)
        }
        acneImage = info[.originalImage] as? UIImage
    }
    
    @IBAction func logOut(_ sender: Any) {
        networkingService.signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "startvc")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        userID = nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoObtained" {
            if let vc = segue.destination as? ResultsViewController {
                vc.image = acneImage
            }
        }
    }
    

}
