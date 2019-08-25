//
//  SideBar.swift
//  NisantasiMenu
//
//  Created by owner on 7/17/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

public class SideBar {
    
    var name: String?
    var itemArr: [String] = []
    var image: String?
    var collapsed: Bool = false
    var id: String?
    
    init(id: String, name: String, image: String, itemArr: [String], collapsed: Bool) {
        self.name = name
        self.image = image
        self.itemArr = itemArr
        self.collapsed = collapsed
        self.id = id
    }
    
}
