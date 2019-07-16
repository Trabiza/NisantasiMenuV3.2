//
//  Extensions+Loading.swift
//  NisantasiMenu
//
//  Created by owner on 6/20/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {
    
    func showLoadingView(){
        //let backGroundColor = UIColor(red: 228, green: 228, blue: 228, alpha: 0.5)
        let size = CGSize(width: 80, height: 80)
        startAnimating(size, type: NVActivityIndicatorType(rawValue: 2), color: UIColor(named: "MainColor"), padding: 0, backgroundColor: UIColor.clear)
    }
    
    func hideLoadindView(){
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
}
