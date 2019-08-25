//
//  MainVC.swift
//  NisantasiMenu
//
//  Created by owner on 7/16/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import SwiftyGif
import Photos
import AudioToolbox

class MainVC: BaseVC {
    
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var arabicBtn: UIButton!
    @IBOutlet weak var englishBtn: UIButton!
    @IBOutlet weak var arabicConstraint: NSLayoutConstraint!
    @IBOutlet weak var englishConstraint: NSLayoutConstraint!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var wifiPass: UIImageView!
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var cacheImageView: UIImageView!
    
    @IBOutlet weak var menuWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    
    var isExpand: Bool = false
    var isWifiOpen: Bool = false
    
    var menuList: [NistansiMenu] = []
    
    let toCategorySegue = "toCategory"
    let toMenuSegu = "toMenu"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        photoPermissionRequest()
        
        loadGIF()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        menuHeightConstraint.constant = 300
        menuWidthConstraint.constant = 300
        
        checkUpdate()
        
        loadGIF()
        print("language is \(UserDataManager.getUserLanguage())")
        if UserDataManager.getUserLanguage() == Config.English {
            languageBtn.setImage(UIImage(named: "arabicNonSelected.png"), for: .normal)
        }else{
            languageBtn.setImage(UIImage(named: "englishSelected.png"), for: .normal)
        }
        
        if DefaultManager.isLanguageChangedDefault() != nil {
            UserDefaults.standard.removeObject(forKey: Config.changeLanguageDefault)
        }
    }
    
    func loadData(){
        if let model = DefaultManager.getAllModelsDefault(key: UserDataManager.getUserLanguage()) {
            print("Offline Mode")
            self.filterCategoryModel(model: model)
        }else{
            getAllData()
            getAllDataArabic()
        }
    }
    
    func checkUpdate(){
        APIManager.updateAPI(view: self.view) { (error, success, data)  in
            if error != nil || !success{
                return
            }
            if let oldDate = DefaultManager.getUpdateDefault() {
                if oldDate != data {
                    DefaultManager.removeAll()
                    DefaultManager.saveUpdateDefault(value: data!)
                    self.loadData()
                }
            }else{
                DefaultManager.saveUpdateDefault(value: data!)
            }
        }
    }
    
    func loadGIF(){
        /*DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
         let gif = UIImage(gifName: "mmvideo.gif")
         self.mImageView.setGifImage(gif, loopCount: -1)
         })*/
        if !mImageView.isAnimating {
            let gif = UIImage(gifName: "mmvideo.gif")
            self.mImageView.setGifImage(gif, loopCount: -1)
        }
        
    }
    
    func getAllData(){
        showLoadingView()
        APIManager.nistansiAPI(lang: Config.English, view: self.view) { (error, success, model) in
            self.hideLoadindView()
            if error != nil || !success{
                return
            }
            DefaultManager.saveAllModelsDefault(model: model!, key: Config.English)
            if UserDataManager.getUserLanguage() == Config.English {
                self.filterCategoryModel(model: model!)
            }
        }
    }
    
    func getAllDataArabic(){
        showLoadingView()
        APIManager.nistansiAPI(lang: Config.Arabic, view: self.view) { (error, success, model) in
            self.hideLoadindView()
            if error != nil || !success{
                return
            }
            DefaultManager.saveAllModelsDefault(model: model!, key: Config.Arabic)
            if UserDataManager.getUserLanguage() == Config.Arabic {
                self.filterCategoryModel(model: model!)
            }
        }
    }
    
    func filterCategoryModel(model: NistansiModel){
        self.menuList.removeAll()
        self.cacheImages(model: model)
        guard let list = model.data else{
            return
        }
        list.forEach { (item) in
            if let tran = item.trans {
                if !tran.isEmpty {
                    self.menuList.append(item)
                }
            }
        }
        print("menu list is \(self.menuList.count)")
    }
    
    func cacheImages(model: NistansiModel){
        
        model.data?.forEach({ (menu) in
            if let sections = menu.sections {
                sections.forEach({ (section) in
                    cacheSectionImage(section: section)
                    if let items = section.items {
                        items.forEach({ (item) in
                            cacheItemImage(item: item)
                        })
                    }
                })
            }
        })
    }
    
    func cacheSectionImage(section: Section){
        if let images = section.images {
            if !images.isEmpty {
                images.forEach { (image) in
                    if let url = image.url {
                        ImagesManager.cacheImage(cacheKey: url, image: cacheImageView)
                    }
                }
            }
        }
    }
    
    func cacheItemImage(item: Item){
        if let images = item.images {
            if !images.isEmpty {
                images.forEach { (image) in
                    if let url = image.url {
                        ImagesManager.cacheImage(cacheKey: url, image: cacheImageView)
                    }
                }
            }
        }
        if let recommedList = item.recommendedItems {
            if !recommedList.isEmpty {
                recommedList.forEach { (image) in
                    if let url = image.imagesURL {
                        ImagesManager.cacheImage(cacheKey: url, image: cacheImageView)
                    }
                }
            }
        }
    }
    
    func photoPermissionRequest(){
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("Photo Authorized")
                }
            })
        }
    }
    
    @IBAction func aboutAction(_ sender: UIButton) {
        if isWifiOpen {
            wifiAnimation()
        }
        if isExpand {
            languageAnimation()
        }
        performSegue(withIdentifier: "aboutSegue", sender: nil)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        if isWifiOpen {
            wifiAnimation()
        }
        if isExpand {
            languageAnimation()
        }
        performSegue(withIdentifier: "shareSegue", sender: nil)
    }
    
    @IBAction func lanuageAction(_ sender: UIButton) {
        languageAnimation()
    }
    
    func languageAnimation(){
        
        if isWifiOpen {
            wifiAnimation()
        }
        
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
        LanguageManager.englishAction(Config.Arabic, VC: self)
    }
    
    @IBAction func arabicAction(_ sender: UIButton) {
        LanguageManager.arabicAction(language: Config.Arabic, VC: self)
    }
    
    @IBAction func wifiAction(_ sender: UIButton) {
        if isExpand {
            languageAnimation()
        }
        sender.pulsate()
        wifiAnimation()
    }
    
    func wifiAnimation(){
        
        if isExpand {
            languageAnimation()
        }
        
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
    
    @IBAction func enterMenu(_ sender: UIButton) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        if isWifiOpen {
            wifiAnimation()
        }
        if isExpand {
            languageAnimation()
        }
        //let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        //feedbackGenerator.impactOccurred()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.menuWidthConstraint.constant = self.menuWidthConstraint.constant - 40
            self.menuHeightConstraint.constant = self.menuHeightConstraint.constant - 40
            self.view.layoutIfNeeded()
        }) { (success) in
            if !self.menuList.isEmpty {
                if self.menuList.count == 1 {
                    self.performSegue(withIdentifier: self.toMenuSegu, sender: nil)
                }else{
                    self.performSegue(withIdentifier: self.toCategorySegue, sender: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toMenuSegu {
            DefaultManager.saveEnteredMenuDefault(value: 0)
            toMainMenuVC()
            /*let desVC = segue.destination as! MainMenuVC
             guard let list = menuList[0].sections else {
             return
             }
             desVC.menuList = reloadData(mList: list)
             desVC.searchMenuList = reloadData(mList: list)*/
        }else if segue.identifier == toCategorySegue {
            let desVC = segue.destination as! CategoryMenuVC
            desVC.categoryList = menuList
        }
    }
    
    func toMainMenuVC(){
        
        guard let list = menuList[0].sections else {
            return
        }
        let mList: [Section] = reloadData(mList: list)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "MainContainerVC") as? MainContainerVC {
            desVC.menuList = mList
            desVC.section = mList[0]
            desVC.row = 0
            //DefaultManager.saveSelectedRowDefault(value: indexPath.row)
            self.present(desVC, animated: true)
        }
    }
    
    func reloadData(mList: [Section]) -> [Section]{
        var list: [Section] = []
        mList.forEach { (item) in
            if let trans = item.trans {
                if !trans.isEmpty {
                    list.append(item)
                }
            }
        }
        return list
    }
}
