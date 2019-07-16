//
//  ImagesCell.swift
//  NisantasiMenu
//
//  Created by owner on 6/10/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class ImagesCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(url: String) {
        ImagesManager.setImage(url: url, image: imageView)
    }

}
