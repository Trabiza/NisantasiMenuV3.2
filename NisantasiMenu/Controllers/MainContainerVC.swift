//
//  MainContainerVC.swift
//  NisantasiMenu
//
//  Created by owner on 7/18/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class MainContainerVC: UIViewController {
    
    var menuList: [Section] = []
    var section: Section?
    var row: Int?
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBtnConstraint: NSLayoutConstraint!
    var isSearchExpand: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey: Config.isSubSectionRowDefault)
        
        loadData()
        setSearchUI()
        RTL()
        notificationPosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateVC(_:)), name: .didUpdateMainContainer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeLanguage), name: .didLanuage, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.updateRow(_:)), name: .didPassRow, object: nil)
    }
    
    @IBAction func mainAction(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func loadData(){
        if DefaultManager.isLanguageChangedDefault() != nil || DefaultManager.isDetailsLanguageChangedDefault() != nil{
    
            row = DefaultManager.getSelectedRowDefault()
            reloadData()
        }
    }
    
    func RTL(){
        if UserDataManager.getUserLanguage() == Config.Arabic {
            //backBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            searchField.transform = CGAffineTransform(scaleX: -1, y: 1)
            searchBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    @objc func updateVC(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let list = dict["menuList"] as? [Section] {
                self.menuList = list
            }
            
            if let section = dict["section"] as? Section{
                self.section = section
            }
            self.notificationPosts()
        }
    }
    
    @objc func updateRow(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            
            if let row = dict["row"] as? Int{
                self.row = row
                //DefaultManager.saveSelectedRowDefault(value: row)
            }
        }
    }
    
    func notificationPosts(){
        let mList:[String: Any] = ["list": menuList, "key": section?.id ?? 0]
        NotificationCenter.default.post(name: .didPassSections, object: nil, userInfo: mList)
        
        let mSection:[String: Section] = ["section": section!]
        NotificationCenter.default.post(name: .didPassSection, object: nil, userInfo: mSection)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        if DefaultManager.isLanguageChangedDefault() != nil || (DefaultManager.isDetailsLanguageChangedDefault() != nil){
            UserDefaults.standard.removeObject(forKey: Config.changeLanguageDefault)
            UserDefaults.standard.removeObject(forKey: Config.detailsLanguageDefault)
            HelperManager.backToMain(self)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        
        if !isSearchExpand {
            beginSearch()
        }else{
            endSearch()
        }
    }
    
    func beginSearch(){
        isSearchExpand = true
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.searchField.becomeFirstResponder()
            self.searchConstraint.constant = 300
            //self.searchBtnConstraint.constant = 0
            self.searchField.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            print("completed")
        }
    }
    
    func endSearch(){
        isSearchExpand = false
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            
            self.searchConstraint.constant = 0
            //self.searchBtnConstraint.constant = 60
            self.searchField.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            print("completed")
        }
    }
    
    func setSearchUI(){
        hideKeyboardWhenTappedAround()
        searchField.delegate = self
        if UserDataManager.getUserLanguage() == Config.Arabic {
            searchField.setRightPaddingPoints(70)
        }else{
            searchField.setLeftPaddingPoints(70)
        }
        searchField.addTarget(self, action: #selector(searchWorkersAsPerText(_ :)), for: .editingChanged)
    }
    
    @objc func searchWorkersAsPerText(_ textfield:UITextField) {
        
        guard let searchText = searchField.text else {
            return
        }
        
        let mSection:[String: String] = ["search": searchText]
        NotificationCenter.default.post(name: .didPassSearch, object: nil, userInfo: mSection)
    }
    
    @objc func changeLanguage(){
        DefaultManager.changeLanguageDefault(value: "changed")
        HelperManager.change(self, mName: "MainContainerVC")
        //reloadData()
    }
    
    func reloadData(){
        if let model = DefaultManager.getAllModelsDefault(key: UserDataManager.getUserLanguage()) {
            self.filterData(model: model)
        }
    }
    
    func filterData(model: NistansiModel){
        guard let list = model.data else{
            return
        }
        
        guard let mSections = list[DefaultManager.getEnteredMenuDefault()].sections else {
            return
        }
        self.menuList.removeAll()
        mSections.forEach { (item) in
            if let tran = item.trans {
                if !tran.isEmpty {
                    self.menuList.append(item)
                }
            }
        }
        
        if !menuList.isEmpty {
            if row != nil {
                self.section = menuList[row!]
            }
        }
        
        //notificationPosts()
    }
    
}

extension MainContainerVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


