//
//  SideBarVC.swift
//  NisantasiMenu
//
//  Created by owner on 7/17/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class SideBarVC: UIViewController {
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var languagehBtn: UIButton!
    let sideBarNIB = "SideBarCell"
    let sideBarColapsedNIB = "SideBarCollapsedCell"
    var items: [SideBar] = []
    var sectionsArr: [Section] = []
    var subItemArr: [String] = [NSLocalizedString("beef", comment: ""),
                                NSLocalizedString("lamp", comment: ""),
                                NSLocalizedString("chicken", comment: "")]
    
    var drinksSubItemArr: [String] = [NSLocalizedString("soft_drinks", comment: ""),
                                      NSLocalizedString("cold_drinks", comment: ""),
                                      NSLocalizedString("fresh_jucies", comment: ""),
                                      NSLocalizedString("iced_drinks", comment: ""),
                                      NSLocalizedString("milk_shake", comment: ""),
                                      NSLocalizedString("coffee_mixes", comment: "")]
    var sectionID: String = "0"
    var mCollapsedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadSections(_:)), name: .didPassSections, object: nil)
        
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
                        if title.lowercased() == Config.collapsedMenu.lowercased() || title.lowercased() == Config.collapsedMenuAR.lowercased() {
                            items.append(SideBar(id: "\(id)", name: title, image: "", itemArr: subItemArr, collapsed: false))
                        }else if title.lowercased() == Config.drinksCollapsedMenu.lowercased() || title.lowercased() == Config.drinksCollapsedMenuAR.lowercased(){
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
                if let name = item.name {
                    if name.lowercased() == Config.collapsedMenu.lowercased() || name.lowercased() == Config.collapsedMenuAR.lowercased(){
                        items[index].collapsed = true
                    }else if name.lowercased() == Config.drinksCollapsedMenu.lowercased() || name.lowercased() == Config.drinksCollapsedMenuAR.lowercased(){
                        items[index].collapsed = true
                    }else{
                        items[index].collapsed = false
                    }
                }
                DefaultManager.saveSelectedRowDefault(value: index)
                let indexPath = IndexPath(row: 0, section: index)
                self.mTableView.reloadData()
                self.mTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
                //mTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func registerNibs() {
        mTableView.separatorStyle = .none
        mTableView.register(UINib(nibName: sideBarNIB, bundle: nil), forCellReuseIdentifier: sideBarNIB)
        mTableView.register(UINib(nibName: sideBarColapsedNIB, bundle: nil), forCellReuseIdentifier: sideBarColapsedNIB)
    }
    
    @IBAction func languageAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: .didLanuage, object: nil)
    }
}



extension SideBarVC: UITableViewDelegate, UITableViewDataSource {
    
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
        //let cell = self.mTableView.cellForRow(at: indexPath) as? SideBarCell
        if indexPath.row == 0 {
            
            DefaultManager.saveSelectedRowDefault(value: indexPath.section)
            if !items[indexPath.section].itemArr.isEmpty {
                print("response array")
                //cell?.mView.backgroundColor = UIColor.red
                self.mCollapsedIndex = indexPath.section
                if items[indexPath.section].collapsed {
                    items[indexPath.section].collapsed = false
                    let sections = IndexSet.init(integer: indexPath.section)
                    mTableView.reloadSections(sections, with: .none)
                }else{
                    items[indexPath.section].collapsed = true
                    let sections = IndexSet.init(integer: indexPath.section)
                    mTableView.reloadSections(sections, with: .none)
                    mTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
                    
                    mTableView.scrollToRow(at: IndexPath(row: items[indexPath.section].itemArr.count, section: indexPath.section), at: .none , animated: true)
                }
            }else{
                collapsedSections()
                if !sectionsArr.isEmpty {
                    let mSection:[String: Section] = ["section": self.sectionsArr[indexPath.section]]
                    NotificationCenter.default.post(name: .didPassSection, object: nil, userInfo: mSection)
                }
                print("response not array")
            }
        }else{
            print("sub section is \(indexPath.row - 1)")
            DefaultManager.saveSelectedRowDefault(value: indexPath.section)
            DefaultManager.saveSubSectionRowDefault(value: indexPath.row - 1)
            DefaultManager.saveIfSubSectionDefault(value: "changed")
            if let subSections = self.sectionsArr[indexPath.section].sections {
                if !subSections.isEmpty {
                    if let items = subSections[indexPath.row - 1].items {
                        let mItems:[String: Any] = ["items": items, "section": self.sectionsArr[indexPath.section]]
                        NotificationCenter.default.post(name: .didPassSubSections, object: nil, userInfo: mItems)
                    }
                }
            }
        }
    }
    
    func collapsedSections(){
        for (index, item) in items.enumerated() {
            if item.collapsed {
                items[index].collapsed = false
                let sections = IndexSet.init(integer: index)
                self.mTableView.reloadSections(sections, with: .none)
                //self.mTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        }
        return 50
    }
    
}
