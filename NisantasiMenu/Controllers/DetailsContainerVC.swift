//
//  DetailsContainerVC.swift
//  NisantasiMenu
//
//  Created by owner on 7/22/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class DetailsContainerVC: UIViewController{

    var itemID: String = ""
    var menuList: [Section] = []
    var section: Section?
    var item: Item?
    var row: Int?

    @IBOutlet weak var sideBarContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("selected section \(DefaultManager.getSelectedRowDefault())   \(DefaultManager.getDetailsRowDefault())   \(DefaultManager.getSubSectionRowDefault())")
        
        loadData()
        
        let mList:[String: Any] = ["itemID": itemID, "item": item!, "section": section!]
        NotificationCenter.default.post(name: .didPassItemID, object: nil, userInfo: mList)
        
        let mSection:[String: Any] = ["list": menuList, "key": section?.id ?? 0]
        NotificationCenter.default.post(name: .didPassSectionsDetails, object: nil, userInfo: mSection)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissDetails), name: .didDismissDetails, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeLanguage), name: .didDetailsLanuage, object: nil)
    }
    
    func loadData(){
        if DefaultManager.isDetailsLanguageChangedDefault() != nil {
            row = DefaultManager.getSelectedRowDefault()
            reloadData()
        }
    }
    
    @objc func dismissDetails() {
        if DefaultManager.isDetailsLanguageChangedDefault() != nil {
            HelperManager.backToVC(self, mName: "MainContainerVC")
        }else{
           dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        if DefaultManager.isDetailsLanguageChangedDefault() != nil {
            //UserDefaults.standard.removeObject(forKey: Config.changeLanguageDefault)
            //UserDefaults.standard.removeObject(forKey: Config.detailsLanguageDefault)
            HelperManager.backToVC(self, mName: "MainContainerVC")
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func changeLanguage(){
        DefaultManager.detailsChangeLanguageDefault(value: "changed")
        HelperManager.change(self, mName: "DetailsContainerVC")
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
            self.section = menuList[DefaultManager.getSelectedRowDefault()]
        }
        
        if DefaultManager.isSubSectionDefault() == nil {
            print("4raaaaaaaaaaaa")
            if section != nil {
                if let items = section?.items {
                    if !items.isEmpty  {
                        self.item = items[DefaultManager.getDetailsRowDefault()]
                    }
                }
            }
        }else{
            print("5raaaaaaaaaaaa")
            UserDefaults.standard.removeObject(forKey: Config.isSubSectionRowDefault)
            let subSectionRow = DefaultManager.getSubSectionRowDefault()
            if let subSections = self.menuList[DefaultManager.getSelectedRowDefault()].sections {
                if !subSections.isEmpty {
                    if let items = subSections[subSectionRow].items {
                        if !items.isEmpty  {
                            self.item = items[DefaultManager.getDetailsRowDefault()]
                        }
                    }
                }
            }
        }
        
    }

}
