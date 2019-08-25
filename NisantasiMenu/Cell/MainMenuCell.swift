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
    @IBOutlet weak var gradientView: UIView!
    
    func setImage(url: String) {
        ImagesManager.setImage(url: url, image: imageView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //gradientView.setGradientBackground(colorTop: .clear, colorBottom: UIColor.lightGray)
    }
    
    /*override var isSelected: Bool{
        didSet{
            UIView.animate(withDuration: 2) {
                self.transform = self.isSelected ? CGAffineTransform(scaleX: 1.5, y: 1.5) : CGAffineTransform.identity
            }
        }
    }*/
    
    
    
}

extension UIView {
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
