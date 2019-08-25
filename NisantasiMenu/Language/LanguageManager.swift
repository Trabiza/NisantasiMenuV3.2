//
//  LanguageManager.swift
//  NisantasiMenu
//
//  Created by owner on 7/17/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit


public class LanguageManager {
    
    public static func arabicAction(language: String, VC: UIViewController){
        let mLang = DefaultManager.getLanguageDefault()
        if mLang != Config.Arabic {
            DefaultManager.saveLanguageDefault(value: Config.Arabic)
            
            L102Language.setAppleLAnguageTo(lang: Config.Arabic)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            rootviewcontroller.rootViewController = VC.storyboard?.instantiateViewController(withIdentifier: "MainVC")
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            UIView.transition(with: mainwindow, duration: 0.4, animations: {}) { (finished) in
            }
        }else{
            VC.dismiss(animated: false, completion: nil)
        }
    }
    
    public static func englishAction(_ language: String, VC: UIViewController){
        let mLang = DefaultManager.getLanguageDefault()
        if mLang != Config.English {
            DefaultManager.saveLanguageDefault(value: Config.English)
            
            L102Language.setAppleLAnguageTo(lang: Config.English)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            rootviewcontroller.rootViewController = VC.storyboard?.instantiateViewController(withIdentifier: "MainVC")
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            UIView.transition(with: mainwindow, duration: 0.4, animations: {}) { (finished) in
            }
        }else{
            VC.dismiss(animated: false, completion: nil)
        }
    }
}
