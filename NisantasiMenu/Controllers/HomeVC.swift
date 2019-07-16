//
//  HomeVC.swift
//  NisantasiMenu
//
//  Created by owner on 6/10/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import DropDown

class HomeVC: BaseVC {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var offerBtn: UIButton!
    
    var languageList: [Language] = []
    var languageListV1: [String] = []
    var categoryList: [Category] = []
    
    let toCategorySegue = "toCategory"
    let toMenuSegu = "toMenu"
    let toLanguageSegue: String = "toLanguage"
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //showLoadingView()
        getLanguage()
        if let model = DefaultManager.getCategoryDefault() {
            print("Offline Mode")
            self.filterCategoryModel(model: model)
        }else{
            getCategories()
        }
    }
    
    func getLanguage(){
        APIManager.languageAPI(view: self.view) { (error, success, model) in
            if error != nil || !success{
                return
            }
            guard let list = model?.data else{
                return
            }
            self.languageList = list
            self.languageList.forEach({ (item) in
                if let title = item.name {
                    self.languageListV1.append(title)
                }
            })
            self.setDropDown(on: self.languageBtn, list: self.languageListV1)
        }
    }
    
    func getCategories(){
        APIManager.categoryAPI(view: self.view) { (error, success, model) in
            if error != nil || !success{
                return
            }
            DefaultManager.saveCategoryDefault(model: model!)
            self.filterCategoryModel(model: model!)
        }
    }
    
    func filterCategoryModel(model: CategoryModel){
        guard let list = model.data else{
            return
        }
        list.forEach { (item) in
            if let tran = item.trans {
                if !tran.isEmpty {
                    self.categoryList.append(item)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }

    @IBAction func enterMenuAction(_ sender: Any) {
        if !categoryList.isEmpty {
            if categoryList.count == 1 {
                performSegue(withIdentifier: toMenuSegu, sender: nil)
            }else{
                performSegue(withIdentifier: toCategorySegue, sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toMenuSegu {
            let desVC = segue.destination as! MainMenuVC
            desVC.category = categoryList[0]
        }
    }
    
    @IBAction func languageAction(_ sender: Any) {
        //dropDown.show()
        performSegue(withIdentifier: toLanguageSegue, sender: nil)
    }
    
    @IBAction func offerAction(_ sender: Any) {
        HelperManager.toOffersVC(self)
    }
    
    @IBAction func guestCommentAction(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ReviewVC") as? ReviewVC {
            present(desVC, animated: true)
        }
    }
    
    func setDropDown(on View: UIView ,list: [String]){
        HelperManager.configureDropDown(dropDown: dropDown)
        dropDown.anchorView = View
        dropDown.dataSource = list
        dropDown.bottomOffset = CGPoint(x: 0, y: -130)
        dropDown.selectionAction = { (index: Int, item: String) in
            if let code = self.languageList[index].code {
                if code == Config.Arabic {
                    print("Arabic")
                    self.arabicAction(Config.Arabic)
                }else{
                    print("English")
                    self.englishAction(Config.English)
                }
            }
        }
        if UserDataManager.getUserLanguage() == Config.English {
            dropDown.selectRow(0)
        }else{
            dropDown.selectRow(1)
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
