//
//  SideBarCollapsedCell.swift
//  NisantasiMenu
//
//  Created by owner on 7/17/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class SideBarCollapsedCell: UITableViewCell {
    
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mView: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.mView.backgroundColor = selected ? UIColor.darkGray : UIColor.init(named: "MainColor")
    }
}
