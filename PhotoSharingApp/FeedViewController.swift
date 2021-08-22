//
//  FeedViewController.swift
//  PhotoSharingApp
//
//  Created by Oğulcan DEMİRTAŞ on 15.08.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource    {

    @IBOutlet weak var tableView: UITableView!
    /*
    var emailArray = [String]()
    var commentArray = [String]()
    var imageArray = [String]()
    */
    
    var postArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        getfirebaseData()
    }
    
    func getfirebaseData() {
        
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Post").order(by: "tarih", descending: true).addSnapshotListener { snapshot, error in //verileri güncel olarak çekmek istiyoruz //tarihe göre dizilecek gönderiler en son paylaşılan en önce (descending)
            if error != nil {
                print(error?.localizedDescription)
                
            }else{
               if snapshot?.isEmpty != true && snapshot != nil {  //snapshot'ın boş olup olmadığına bakıyoruz post'un dökümanlarında
                //self.emailArray.removeAll(keepingCapacity: false)
                //self.commentArray.removeAll(keepingCapacity: false)
                //self.imageArray.removeAll(keepingCapacity: false)
                self.postArray.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents {
                    // let documentId = document.documentID
                    if let imageUrl = document.get("imageurl") as? String{
                        if let comment = document.get("comment") as? String{
                            if let email = document.get("email") as? String{
                               
                                let post = Post(email: email, comment: comment, imageUrl: imageUrl)
                                self.postArray.append(post)
                            }
                            
                        }
            
                        
                    }
                    
                    
                }
                self.tableView.reloadData()
                    
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell //cell'leri tekrar kullanılabilir olarak table cell'imize eşitliyoruz ve oluşturuğumuz FeedCell sınıfına cast ettik
        cell.emailLabel.text = postArray[indexPath.row].email
        
        cell.commentLabel.text = postArray[indexPath.row].comment
        
        cell.postImageView.sd_setImage(with: URL(string: self.postArray[indexPath.row].imageUrl))
        return cell
    }



}
