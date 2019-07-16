//
//  BaseVC.swift
//  NisantasiMenu
//
//  Created by owner on 6/18/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

extension UIViewController {

    func loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if (subView is UIImageView) && subView.tag < 0 {
                    let toRightArrow = subView as! UIImageView
                    if let _img = toRightArrow.image {
                        toRightArrow.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.upMirrored)
                        //toRightArrow.tintColor = UIColor.darkGray
                    }
                }
                loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: subView.subviews)
            }
        }
    }
}

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if L102Language.currentAppleLanguage() == Config.Arabic {
            loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: self.view.subviews)
        }
    }

}
