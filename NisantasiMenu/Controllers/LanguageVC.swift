//
//  LanguageVC.swift
//  NisantasiMenu
//
//  Created by owner on 6/19/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class LanguageVC: UIViewController {
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    let languageNIB: String = "LanguageCell"
    
    var languageList: [Language] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        HelperManager.RTLBtn(backBtn)
        mTableView.separatorStyle = .none
        setXIB()
        
        if let model = DefaultManager.getLanguageListDefault(){
            print("offline mode")
            loadOffline(model: model)
        }else{
            getLanguage()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func setXIB(){
        mTableView.register(UINib(nibName: languageNIB, bundle: nil), forCellReuseIdentifier: languageNIB)
    }
    
    func getLanguage(){
        APIManager.languageAPI(view: self.view) { (error, success, model) in
            if error != nil || !success{
                return
            }
            DefaultManager.saveLanguageListDefault(model: model!)
            guard let list = model?.data else{
                return
            }
            self.languageList = list
            self.mTableView.reloadData()
        }
    }
    
    func loadOffline(model: LanguageModel){
        guard let list = model.data else{
            return
        }
        self.languageList = list
        self.mTableView.reloadData()
    }
}


extension LanguageVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LanguageCell = tableView.dequeueReusableCell(withIdentifier: languageNIB, for: indexPath) as! LanguageCell
        
        cell.selectionStyle = .none
        if let title = languageList[indexPath.row].name {
            cell.titleLabel.text = title
        }
        if let code = languageList[indexPath.row].code {
            if code == UserDataManager.getUserLanguage() {
                cell.mImageView.image = #imageLiteral(resourceName: "radio-button-fill")
            }else{
                cell.mImageView.image = #imageLiteral(resourceName: "radio-button")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let code = languageList[indexPath.row].code {
            if code == Config.Arabic {
                arabicAction(code)
            }else{
                englishAction(code)
            }
        }
    }
    
    func arabicAction(_ language: String){
        let mLang = DefaultManager.getLanguageDefault()
        if mLang != Config.Arabic {
            DefaultManager.saveLanguageDefault(value: Config.Arabic)
            
            L102Language.setAppleLAnguageTo(lang: Config.Arabic)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            UIView.transition(with: mainwindow, duration: 0.4, animations: {}) { (finished) in
            }
        }else{
            dismiss(animated: false, completion: nil)
        }
    }
    
    func englishAction(_ language: String){
        let mLang = DefaultManager.getLanguageDefault()
        if mLang != Config.English {
            DefaultManager.saveLanguageDefault(value: Config.English)
            
            L102Language.setAppleLAnguageTo(lang: Config.English)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            UIView.transition(with: mainwindow, duration: 0.4, animations: {}) { (finished) in
            }
        }else{
            dismiss(animated: false, completion: nil)
        }
    }
    
}
