//
//  SubDetailsVC.swift
//  NisantasiMenu
//
//  Created by owner on 7/22/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class SubDetailsVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var languagehBtn: UIButton!
    
    let sideBarNIB = "SideBarCell"
    let sideBarColapsedNIB = "SideBarCollapsedCell"
    var items: [SideBar] = []
    var sectionsArr: [Section] = []
    var sectionID: String = "0"
    
    var subItemArr: [String] = [NSLocalizedString("beef", comment: ""),
                                NSLocalizedString("lamp", comment: ""),
                                NSLocalizedString("chicken", comment: "")]
    
    var drinksSubItemArr: [String] = [NSLocalizedString("soft_drinks", comment: ""),
                                      NSLocalizedString("cold_drinks", comment: ""),
                                      NSLocalizedString("fresh_jucies", comment: ""),
                                      NSLocalizedString("iced_drinks", comment: ""),
                                      NSLocalizedString("milk_shake", comment: ""),
                                      NSLocalizedString("coffee_mixes", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadSections(_:)), name: .didPassSectionsDetails, object: nil)
        
        if UserDataManager.getUserLanguage() == Config.English {
            languagehBtn.setImage(UIImage(named: "arabicNonSelected.png"), for: .normal)
        }else{
            languagehBtn.setImage(UIImage(named: "englishSelected.png"), for: .normal)
        }
    }
    
    @objc func loadSections(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let id = dict["key"] as? Int {
                sectionID = "\(id)"
            }
            
            if let list = dict["list"] as? [Section]{
                print("sections are \(list.count)")
                self.sectionsArr = list
                sections(list: list)
            }
        }
    }
    
    func sections(list: [Section]){
        items.removeAll()
        list.forEach { (item) in
            if let trans = item.trans , let id = item.id{
                if !trans.isEmpty {
                    if let title = trans[0].name {
                        if title.lowercased() == Config.collapsedMenu.lowercased() {
                            items.append(SideBar(id: "\(id)", name: title, image: "", itemArr: subItemArr, collapsed: false))
                        }else if title.lowercased() == Config.drinksCollapsedMenu.lowercased(){
                            items.append(SideBar(id: "\(id)", name: title, image: "", itemArr: drinksSubItemArr, collapsed: false))
                        }else{
                            items.append(SideBar(id: "\(id)", name: title, image: "", itemArr: [], collapsed: false))
                        }
                    }
                }
            }
        }
        
        for (index, item) in items.enumerated() {
            if item.id == sectionID {
                print("section sub id \(sectionID)")
                if let name = item.name {
                    if name.lowercased() == Config.collapsedMenu.lowercased() {
                        items[index].collapsed = true
                    }else if name.lowercased() == Config.drinksCollapsedMenu.lowercased(){
                        items[index].collapsed = true
                    }else{
                        items[index].collapsed = false
                    }
                }
                let indexPath = IndexPath(row: 0, section: index)
                self.mTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            }
        }
        
    }
    
    func registerNibs() {
        mTableView.separatorStyle = .none
        mTableView.register(UINib(nibName: sideBarNIB, bundle: nil), forCellReuseIdentifier: sideBarNIB)
        mTableView.register(UINib(nibName: sideBarColapsedNIB, bundle: nil), forCellReuseIdentifier: sideBarColapsedNIB)
    }
    
    @IBAction func languageAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didDetailsLanuage, object: nil)
    }
}



extension SubDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items[section].collapsed {
            return items[section].itemArr.count + 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        if indexPath.row == 0 {
            let cell: SideBarCell = mTableView.dequeueReusableCell(withIdentifier: sideBarNIB, for: indexPath) as! SideBarCell
            cell.selectionStyle = .none
            cell.mTitle.text = items[indexPath.section].name
            return cell
        }else{
            let cell: SideBarCollapsedCell = mTableView.dequeueReusableCell(withIdentifier: sideBarColapsedNIB, for: indexPath) as! SideBarCollapsedCell
            cell.selectionStyle = .none
            cell.mTitle.text = items[indexPath.section].itemArr[dataIndex]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            /*if !items[indexPath.section].itemArr.isEmpty {
                print("response array")
                if items[indexPath.section].collapsed {
                    items[indexPath.section].collapsed = false
                    let sections = IndexSet.init(integer: indexPath.section)
                    mTableView.reloadSections(sections, with: .none)
                }else{
                    items[indexPath.section].collapsed = true
                    let sections = IndexSet.init(integer: indexPath.section)
                    mTableView.reloadSections(sections, with: .none)
                }
            }else{
                if !sectionsArr.isEmpty {
                    
                    let mList:[String: Any] = ["menuList": self.sectionsArr, "section": self.sectionsArr[indexPath.section]]
                    NotificationCenter.default.post(name: .didUpdateMainContainer, object: nil, userInfo: mList)
                    NotificationCenter.default.post(name: .didDismissDetails, object: nil)
                }
                print("response not array")
            }*/
            if !sectionsArr.isEmpty {
                DefaultManager.saveSelectedRowDefault(value: indexPath.section)
                let mList:[String: Any] = ["menuList": self.sectionsArr, "section": self.sectionsArr[indexPath.section]]
                NotificationCenter.default.post(name: .didUpdateMainContainer, object: nil, userInfo: mList)
                NotificationCenter.default.post(name: .didDismissDetails, object: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }
        return 50
    }
    
}
