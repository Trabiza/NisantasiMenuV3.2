//
//  Extensions+Cardview.swift
//  NisantasiMenu
//
//  Created by owner on 7/28/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit


extension UICollectionViewCell{
    func shadowAndBorderForCell(cell : UICollectionViewCell){
        // SHADOW AND BORDER FOR CELL
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.borderWidth = 0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
    }
}

extension UITableViewCell{
    func shadowAndBorderForTableViewCell(cell : UITableViewCell){
        // SHADOW AND BORDER FOR CELL
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.borderWidth = 0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
    }
}
