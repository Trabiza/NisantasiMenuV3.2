//
//  VideoVC.swift
//  NisantasiMenu
//
//  Created by owner on 7/22/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import AVKit
import BMPlayer
import SwiftyGif

class VideoVC: UIViewController {
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //HelperManager.RTLBtn(backBtn)
        //HelperManager.RTLBtn(searchBtn)
        backBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
    }

}
