//
//  HelperManager.swift
//  NisantasiMenu
//
//  Created by owner on 6/17/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import DropDown

public class HelperManager {
    
    static func searchBarStyle(searchBar: UITextField){
        searchBar.tintColor = UIColor.lightGray
        searchBar.setIcon(#imageLiteral(resourceName: "search"))
    }
    
    static func getDateFromStringV2(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dateFromString = dateFormatter.date(from: dateString) {
            print(dateFromString)   // "2015-08-19 09:00:00 +0000"
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a Z"
            dateFormatter.timeZone = .current
            dateFormatter.string(from: dateFromString)  // 19-08-2015 06:00 AM -0300"
            return dateFromString
        }
        return nil
    }
    
    static func getMonthName(month: Int) -> String{
        return DateFormatter().monthSymbols[month - 1]
    }
    
    static func convertDate(date: Date) -> String{
        
        var mDate: String = " "
        let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        if let day = calanderDate.day, let month = calanderDate.month, let year = calanderDate.year {
            mDate = "\(getMonthName(month: month)) \(day), \(year)"
        }
        return mDate
    }
    
    static func toOffersVC(_ vc: UIViewController){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "OffersVC") as? OffersVC {
            vc.present(desVC, animated: true)
        }
    }
    
    public static func splitString(text: String) -> [String] {
        return text.components(separatedBy: ",")
    }
    
    public static func configureDropDown(dropDown: DropDown){
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = AppFontManager.font(size: 22, weight: .regular)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.gray
        DropDown.appearance().cornerRadius = 10
        DropDown.appearance().cellHeight = 60
        
        dropDown.width = 300
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
    }
    
    public static func RTLBtn(_ btn: UIButton){
        if UserDataManager.getUserLanguage() == Config.Arabic {
            if let _img = btn.imageView?.image {
                btn.imageView?.image = UIImage(cgImage: _img.cgImage!, scale: _img.scale, orientation: UIImageOrientation.upMirrored)
            }
        }
    }
    
    public static func change(_ mViewController: UIViewController, mName: String){
        mViewController.dismiss(animated: false, completion: nil)
        if UserDataManager.getUserLanguage() == Config.English {
            DefaultManager.saveLanguageDefault(value: Config.Arabic)
            L102Language.setAppleLAnguageTo(lang: Config.Arabic)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            DefaultManager.saveLanguageDefault(value: Config.English)
            L102Language.setAppleLAnguageTo(lang: Config.English)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = mViewController.storyboard?.instantiateViewController(withIdentifier: mName)
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.4, animations: {}) { (finished) in
        }
    }
    
    public static func backToVC(_ mViewController: UIViewController, mName: String){
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = mViewController.storyboard?.instantiateViewController(withIdentifier: mName)
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.4, animations: {}) { (finished) in
        }
    }
    
    public static func backToMain(_ mViewController: UIViewController){
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = mViewController.storyboard?.instantiateViewController(withIdentifier: "MainVC")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.4, animations: {}) { (finished) in
        }
    }
    
    public static func changeLanguageCode(_ mViewController: UIViewController, mName: String){
        if UserDataManager.getUserLanguage() == Config.English {
            DefaultManager.saveLanguageDefault(value: Config.Arabic)
            L102Language.setAppleLAnguageTo(lang: Config.Arabic)
            //UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            DefaultManager.saveLanguageDefault(value: Config.English)
            L102Language.setAppleLAnguageTo(lang: Config.English)
            //UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}
