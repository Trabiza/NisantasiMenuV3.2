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
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var vatLael: UILabel!
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchConstraint: NSLayoutConstraint!
    var isSearchExpand: Bool = false
    
    let menuCell: String = "MainMenuCell"
    let titleCell: String = "MenuTitleCell"
    
    var sectionDic = [Sections.title: 0, Sections.menu: 1]
    
    var category: Category?
    var menuList: [Section] = []
    var searchMenuList: [Section] = []
    var menuTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        RTL()
        setSearchUI()
        setupMenu()
        setMenuTitle()
        //getMenuId()
    }
    
    func RTL(){
        if UserDataManager.getUserLanguage() == Config.Arabic {
            searchBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            searchBar.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    func setSearchUI(){
        //HelperManager.searchBarStyle(searchBar: searchBar)
        if UserDataManager.getUserLanguage() == Config.Arabic {
            searchBar.setRightPaddingPoints(70)
        }else{
            searchBar.setLeftPaddingPoints(70)
        }
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
                    return (trans[0].name?.lowercased().contains(searchText.lowercased()))!
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
    
    
    func loadMenus(id: String){
        setMenuTitle()
        if let mMenu = DefaultManager.getMenuDefault() {
             print("Offline Mode")
            offlineMenus(id: id, model: mMenu)
        }else{
            onlineMenus(id: id)
        }
    }
    
    func offlineMenus(id: String, model: MenuModel){
        self.checkTrans(model: model)
    }
    
    func onlineMenus(id: String){
        showLoadingView()
        APIManager.menuAPI(id: id, view: self.view) { (error, success, model) in
            self.hideLoadindView()
            if error != nil || !success{
                return
            }
            DefaultManager.saveMenuDefault(model: model!)
            self.checkTrans(model: model!)
        }
    }
    
    func checkTrans(model: MenuModel){
        if let data = model.data {
            if !data.isEmpty {
                if let list = data[0].sections {
                    list.forEach { (item) in
                        if let trans = item.trans {
                            if !trans.isEmpty {
                                self.menuList.append(item)
                                self.searchMenuList.append(item)
                            }
                        }
                    }
                    self.mCollectionView.reloadData()
                }
            }
        }
    }
    
    func setMenuTitle(){
        menuTitleLabel.text = menuTitle
    }
    
    func setupMenu() {
        mCollectionView.register(UINib(nibName: menuCell, bundle: nil), forCellWithReuseIdentifier: menuCell)
        mCollectionView.register(UINib(nibName: titleCell, bundle: nil), forCellWithReuseIdentifier: titleCell)
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
            self.searchBar.becomeFirstResponder()
            self.searchConstraint.constant = 300
            //self.searchBtnConstraint.constant = 0
            self.searchBar.alpha = 1
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
            self.searchBar.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            print("completed")
        }
    }
}

extension MainMenuVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchMenuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:MainMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCell, for: indexPath) as! MainMenuCell
        cell.shadowAndBorderForCell(cell: cell)
        //cell.setImage(url: "storage/app/public/images/item/1564656415.jpg")
        
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
        /*if let itemCount = searchMenuList[indexPath.row].itemsCount {
            cell.itemsCountLabel.text = "\(itemCount) items"
        }
        if let mDate = searchMenuList[indexPath.row].createdAt {
            if let dateAsDate = HelperManager.getDateFromStringV2(dateString: mDate) {
                cell.dateLabel.text = HelperManager.convertDate(date: dateAsDate)
            }
        }*/
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = mCollectionView.cellForItem(at: indexPath) as? MainMenuCell
        mCollectionView.bringSubview(toFront: selectedCell!)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: [], animations: {
            selectedCell?.transform = CGAffineTransform(scaleX: 1.5, y: 1.1)
        }) { (success) in
            
            selectedCell?.transform = .identity
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "MainContainerVC") as? MainContainerVC {
                desVC.menuList = self.searchMenuList
                desVC.section = self.searchMenuList[indexPath.row]
                desVC.row = indexPath.row
                //DefaultManager.saveSelectedRowDefault(value: indexPath.row)
                self.present(desVC, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let unselectedCell = mCollectionView.cellForItem(at: indexPath)  as? MainMenuCell
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
            unselectedCell?.transform = .identity
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width / 2) - 15
        return CGSize(width: width, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    /*func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? MainMenuCell {
                cell.imageView.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? MainMenuCell {
                cell.imageView.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }*/
}


extension MainMenuVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}



