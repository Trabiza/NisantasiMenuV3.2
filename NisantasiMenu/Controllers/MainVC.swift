//
//  MainVC.swift
//  NisantasiMenu
//
//  Created by owner on 7/16/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class MainVC: BaseVC {
    
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var arabicBtn: UIButton!
    @IBOutlet weak var englishBtn: UIButton!
    @IBOutlet weak var arabicConstraint: NSLayoutConstraint!
    @IBOutlet weak var englishConstraint: NSLayoutConstraint!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var wifiPass: UIImageView!
    
    var isExpand: Bool = false
    var isWifiOpen: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func lanuageAction(_ sender: UIButton) {
        if !isExpand { //Expand
            isExpand = true
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                
                self.arabicConstraint.constant = 10
                self.englishConstraint.constant = 10
                self.arabicBtn.alpha = 1
                self.englishBtn.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
                print("completed")
            }
        }else{ //Decollaspe
            isExpand = false
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
               
                self.arabicConstraint.constant = -70
                self.englishConstraint.constant = -60
                self.view.layoutIfNeeded()
            }) { (success) in
                self.arabicBtn.alpha = 0
                self.englishBtn.alpha = 0
            }
        }
    }
    
    @IBAction func englishAction(_ sender: UIButton) {
        
    }
    
    @IBAction func arabicAction(_ sender: UIButton) {
        
    }
    
    @IBAction func wifiAction(_ sender: UIButton) {
        sender.pulsate()
        if !isWifiOpen { //Expand
            isWifiOpen = true
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                
                self.wifiPass.alpha = 1
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }else{
            isWifiOpen = false
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                
                self.wifiPass.alpha = 0
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }
        
    }
}
