//
//  ViewController.swift
//  PhotoSharingApp
//
//  Created by Oğulcan DEMİRTAŞ on 15.08.2021.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        
        view.addGestureRecognizer(gestureRecognizer)
    }

    @objc func klavyeyiKapat () {
        view.endEditing(true)
    }
    @IBAction func signinButton(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdataresult, error in
                if error != nil {
                    self.errorMessage(titleInput: "HATA", messageInput: error!.localizedDescription) //veya kayıt olmadaki gibi yazabiiliriz
                    
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else {
            self.errorMessage(titleInput: "HATA", messageInput: "Kullanici Adi veya şifre giriniz")
        }
        
    }
    
    
    @IBAction func signupButton(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            //kayıt olma işlemi
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdataresult, error in
                if error != nil {
                    
                    self.errorMessage(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Bilinmeyen Hata") //veya error!.localizedDescription yazarsak da direk sorun çözülür gelen hataya göre mesaj çıkarır
                    
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            errorMessage(titleInput: "Hata!", messageInput: "Kullanıcı adı ve/veya şifre giriniz.")
        }
        
    }
    
    func errorMessage(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }
}

