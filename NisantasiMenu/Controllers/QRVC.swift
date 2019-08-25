//
//  QRVC.swift
//  NisantasiMenu
//
//  Created by owner on 7/16/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class QRVC: UIViewController {
    
    @IBOutlet weak var mConstraint: NSLayoutConstraint!
    @IBOutlet weak var mImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mConstraint.constant = self.view.frame.width / 3
        setUI()
    }
    
    func setUI(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(QRVC.dismissFilter))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissFilter(){
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
