//
//  SettingsViewController.swift
//  PhotoSharingApp
//
//  Created by Oğulcan DEMİRTAŞ on 15.08.2021.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("TEHLİKELİ HATA")
        }
        
        
       
       
        
    }
}
