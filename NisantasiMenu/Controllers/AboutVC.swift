//
//  AboutVC.swift
//  NisantasiMenu
//
//  Created by mac on 8/6/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDataManager.getUserLanguage() == Config.English {
            titleLabel.text = "Nişantaşı, Cairo's newest destination for Turkish cuisine, is owned by International Food Academy. The restaurant is run by a team of travel enthusiasts who spent years researching the secrets of Turkey's gastronomic splendor. The name Nişantaşı originally refers to an exclusive quarter of the Şişli district on the European side of Istanbul. Nişantaşı's menu is brimming with history and generational cooking techniques, displaying the extensive variety of dishes and drinks; from home-baked bread and flavorful meats, everything on the menu is inevitably protagonist."
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
