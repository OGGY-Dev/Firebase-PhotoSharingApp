//
//  FeedCell.swift
//  PhotoSharingApp
//
//  Created by Oğulcan DEMİRTAŞ on 19.08.2021.
//

import UIKit

//tableview cell kullanıldığında ona ait yeni bir cocoa touch dosyası ve sınıf açıyoruz. yoksa çalışmaz

class FeedCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
