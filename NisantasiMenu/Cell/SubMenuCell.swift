//
//  SubMenuCell.swift
//  NisantasiMenu
//
//  Created by owner on 6/10/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class SubMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mStackView: UIStackView!
    @IBOutlet weak var specialImage: UIImageView!
    @IBOutlet weak var rankingImage: UIImageView!
    
    func setImage(url: String) {
        ImagesManager.setImage(url: url, image: imageView)
    }
}
