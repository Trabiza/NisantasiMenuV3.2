//
//  OffersCell.swift
//  NisantasiMenu
//
//  Created by owner on 6/19/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class OffersCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func setImage(url: String) {
        ImagesManager.setImage(url: url, image: imageView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 11.0, *){
            imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
}
