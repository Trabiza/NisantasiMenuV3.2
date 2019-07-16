//
//  RatingVC.swift
//  NisantasiMenu
//
//  Created by owner on 6/20/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import Cosmos

class RatingVC: UIViewController {
    
    @IBOutlet weak var ratingView: CosmosView!
    
    var itemID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func ratingAction(_ sender: Any) {
        
        APIManager.ratingAPI(itemID: itemID, rate: "\(ratingView.rating)", view: self.view) { (error, success) in
            if error != nil || !success{
                return
            }
            self.showToast(message: "Thanks for your rating", controller: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
