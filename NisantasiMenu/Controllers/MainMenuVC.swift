//
//  MainMenuVC.swift
//  NisantasiMenu
//
//  Created by owner on 6/10/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

enum Sections {
    case title
    case menu
}

class MainMenuVC: BaseVC {

    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    
    let menuCell: String = "MainMenuCell"
    let titleCell: String = "MenuTitleCell"
    
    var sectionDic = [Sections.title: 0, Sections.menu: 1]
    
    var category: Category?
    var menuList: [Section] = []
    var searchMenuList: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        setSearchUI()
        setupMenu()
        getMenuId()
        
        HelperManager.RTLBtn(backBtn)
    }
    
    func setSearchUI(){
        HelperManager.searchBarStyle(searchBar: searchBar)
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(searchWorkersAsPerText(_ :)), for: .editingChanged)
    }
    
    @IBAction func offerAction(_ sender: Any) {
        HelperManager.toOffersVC(self)
    }
    
    @objc func searchWorkersAsPerText(_ textfield:UITextField) {
        
        guard let searchText = searchBar.text else {
            searchMenuList = menuList
            mCollectionView.reloadData()
            return
        }
        
        if searchText.isEmpty {
            searchMenuList = menuList
            mCollectionView.reloadData()
            return
        }
        
        searchMenuList = menuList.filter({ (item) -> Bool in
            if let trans = item.trans {
                if !trans.isEmpty {
                    return (trans[0].name?.contains(searchText))!
                }
            }
            return false
            //return (item.?.containsIgnoringCase(find: searchText))!
        })
        mCollectionView.reloadData()
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func getMenuId(){
        if let trans = category?.trans {
            if !trans.isEmpty {
                if let categoryID = trans[0].menuID {
                    loadMenus(id: "\(categoryID)")
                }
            }
        }
    }
    
    func loadMenus(id: String){
        if let mMenu = DefaultManager.getMenuDefault() {
             print("Offline Mode")
            offlineMenus(id: id, model: mMenu)
        }else{
            onlineMenus(id: id)
        }
    }
    
    func offlineMenus(id: String, model: MenuModel){
        if let data = model.data {
            if !data.isEmpty {
                if let list = data[0].sections {
                    self.menuList = list
                    self.searchMenuList = list
                    self.mCollectionView.reloadData()
                }
            }
        }
    }
    
    func onlineMenus(id: String){
        showLoadingView()
        APIManager.menuAPI(id: id, view: self.view) { (error, success, model) in
            self.hideLoadindView()
            if error != nil || !success{
                return
            }
            DefaultManager.saveMenuDefault(model: model!)
            if let data = model?.data {
                if !data.isEmpty {
                    if let list = data[0].sections {
                        self.menuList = list
                        self.searchMenuList = list
                        self.mCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func setupMenu() {
        mCollectionView.register(UINib(nibName: menuCell, bundle: nil), forCellWithReuseIdentifier: menuCell)
        mCollectionView.register(UINib(nibName: titleCell, bundle: nil), forCellWithReuseIdentifier: titleCell)
    }

}

extension MainMenuVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionDic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == sectionDic[.title] {
            return 1
        }else if section == sectionDic[.menu] {
            return searchMenuList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == sectionDic[.title] {
            let cell:MenuTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCell, for: indexPath) as! MenuTitleCell
            if let trans = category?.trans {
                if !trans.isEmpty {
                    if let title = trans[0].title {
                        cell.titleLabel.text = title
                    }
                    if let details = trans[0].tranDescription {
                        cell.detailsLabel.text = details
                    }
                }
            }
            return cell
        }else {
            let cell:MainMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCell, for: indexPath) as! MainMenuCell
            if let images = searchMenuList[indexPath.row].images {
                if !images.isEmpty {
                    if let mURL = images[0].url {
                        cell.setImage(url: mURL)
                    }
                }else{
                    cell.imageView.image = UIImage(named: Config.placeholderImage)
                }
            }
            if let trans = searchMenuList[indexPath.row].trans {
                if !trans.isEmpty {
                    if let title = trans[0].name {
                        cell.titleLabel.text = title
                    }
                }
            }
            if let itemCount = searchMenuList[indexPath.row].itemsCount {
                cell.itemsCountLabel.text = "\(itemCount) items"
            }
            if let mDate = searchMenuList[indexPath.row].createdAt {
                if let dateAsDate = HelperManager.getDateFromStringV2(dateString: mDate) {
                    cell.dateLabel.text = HelperManager.convertDate(date: dateAsDate)
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "SubMenuVC") as? SubMenuVC {
            desVC.section = searchMenuList[indexPath.row]
            present(desVC, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == sectionDic[.title] {
            return CGSize(width: view.frame.width, height: 100)
        }else {
            let width = (view.frame.width / 3) - 16
            return CGSize(width: width, height: width)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == sectionDic[.menu] {
            return 6
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == sectionDic[.menu] {
            return 6
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == sectionDic[.menu] {
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


extension MainMenuVC: UITextFieldDelegate {
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("a7aaaaaa \(string)")
        
        return true
    }*/
    
}



