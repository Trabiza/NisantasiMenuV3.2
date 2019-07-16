//
//  MainMenuCell.swift
//  NisantasiMenu
//
//  Created by owner on 6/10/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class MainMenuCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemsCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(url: String) {
        ImagesManager.setImage(url: url, image: imageView)
    }
    
}
