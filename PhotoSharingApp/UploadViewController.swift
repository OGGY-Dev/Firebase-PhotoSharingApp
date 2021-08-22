//
//  UploadViewController.swift
//  PhotoSharingApp
//
//  Created by Oğulcan DEMİRTAŞ on 15.08.2021.
//

import UIKit
import Firebase


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var photoPick: UIImageView!
    
    @IBOutlet weak var noteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPick.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        photoPick.addGestureRecognizer(imageGestureRecognizer)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        
        view.addGestureRecognizer(gestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    @objc func klavyeyiKapat () {
        view.endEditing(true)
    }
    @IBAction func shareButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()  //storageımıza referens verdik
        
        let mediaFolder = storageReference.child("media")  //bir şey'in alt klasörüne geçmek ve açmak için child komutu kullanılır . yani upload edilen dosyalar firebase de media referanslı/isimli klasöre kaydolacak
        
       
        //fotoğrafımızı veri haline getiriyoruz
        if let data = photoPick.image?.jpegData(compressionQuality: 0.5){   //0.5 sıkıştırma kalitesi 0..1 arası
            
            let uuid = UUID().uuidString //rastgele uuid yazılıyor burada program tarafından
            
            let photoReference = mediaFolder.child("\(uuid).jpg") //upload edilen dosyalar media dosyasının içine bu şekilde kaydedilecek
            photoReference.putData(data, metadata:  nil) { storagemetadata, error in
                if error != nil {
                    self.showErrorMessage(title: "Error", message: error?.localizedDescription ?? "Bilinmeyen Hata, tekrar deneyiniz")    //firebase'den gelen hata neyse onu gösterir, eğer firebasede bi sıkıntı çıkarsa bizim yazdığımızı gösterir
                    
                }else{
                    photoReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            if let imageUrl = imageUrl{
                                //firestore'a gönderiyoruz resmi,yorumu,hangi kullanıcnın attığını ve tarihi
                                let firestorePost = ["imageurl" : imageUrl, "comment" : self.noteTextField.text!, "email" : Auth.auth().currentUser!.email, "tarih": FieldValue.serverTimestamp() ] as [String : Any]
                                
                                
                                let firestoreDatabase = Firestore.firestore()
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { error in
                                    if error != nil {
                                        
                                        self.showErrorMessage(title: "error", message: error?.localizedDescription ?? "bilinmeyen hata" )
                                    }else {
                                        
                                        self.photoPick.image = UIImage(systemName: "photo") //resmi şeçip paylaştıktan sonra resim seçme yerine tekrar ilk seçim ekranındaki resim geliyor
                                        self.noteTextField.text = ""
                                        self.tabBarController?.selectedIndex = 0 //mainstoryboardda tab barda görünen feed-upload-settings kısmının indenxleri 0 - 1 - 2 şeklindedir ve biz bu denkleme 0 yazarak upload yapınca 0. index'e yani feed'e gitmesini söylüyoruz.
                                        
                                    }
                                }
                                
                            }
                            
                            
                            
                           
                            
                            
                        }
                    }
                }
            }
            
            
        }
        
    }
    
    @objc func pickImage() {
        let picker = UIImagePickerController()   // kullanıcının görsele tıklayınca galeriye,kütüphaneye gitmesini sağlıyor
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
        photoPick.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    }

