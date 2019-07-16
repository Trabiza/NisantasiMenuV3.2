//
//  SubMenuVC.swift
//  NisantasiMenu
//
//  Created by owner on 6/10/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

enum SubMenuSections {
    case title
    case menu
}

class SubMenuVC: BaseVC {
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    
    let menuCell: String = "SubMenuCell"
    let titleCell: String = "MenuTitleCell"
    
    var sectionDic = [SubMenuSections.title: 0, SubMenuSections.menu: 1]
    
    var section: Section?
    var itemList: [Item] = []
    var searchItemList: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HelperManager.RTLBtn(backBtn)
        hideKeyboardWhenTappedAround()
        setupMenu()
        setSearchUI()
        
        guard let id = section?.id else{
            return
        }
        if let model = DefaultManager.getSectionDefault(key: "\(id)"){
            print("offline mode")
            loadItemOffilne(model: model)
        }else{
            loadItems()
        }
    }
    
    
    func setSearchUI(){
        HelperManager.searchBarStyle(searchBar: searchBar)
        searchBar.addTarget(self, action: #selector(searchWorkersAsPerText(_ :)), for: .editingChanged)
    }
    
    @IBAction func offerAction(_ sender: Any) {
        HelperManager.toOffersVC(self)
    }
    
    @objc func searchWorkersAsPerText(_ textfield:UITextField) {
        
        guard let searchText = searchBar.text else {
            searchItemList = itemList
            mCollectionView.reloadData()
            return
        }
        
        if searchText.isEmpty {
            searchItemList = itemList
            mCollectionView.reloadData()
            return
        }
        
        searchItemList = itemList.filter({ (item) -> Bool in
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
    
    func setupMenu() {
        mCollectionView.register(UINib(nibName: menuCell, bundle: nil), forCellWithReuseIdentifier: menuCell)
        mCollectionView.register(UINib(nibName: titleCell, bundle: nil), forCellWithReuseIdentifier: titleCell)
    }
    
    func loadItems(){
        guard let id = section?.id else{
            return
        }
        showLoadingView()
        APIManager.itemsAPI(id: "\(id)", view: self.view) { (error, success, model) in
            self.hideLoadindView()
            if error != nil || !success{
                return
            }
            DefaultManager.saveSectionDefault(model: model!, key: "\(id)")
            guard let data = model?.data else {
                return
            }
            guard let items = data[0].items else{
                return
            }
            self.itemList = items
            self.searchItemList = items
            self.mCollectionView.reloadData()
        }
    }
    
    func loadItemOffilne(model: ItemModel){
        guard let data = model.data else {
            return
        }
        guard let items = data[0].items else{
            return
        }
        self.itemList = items
        self.searchItemList = items
        self.mCollectionView.reloadData()
    }

}


extension SubMenuVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionDic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == sectionDic[.title] {
            return 1
        }else if section == sectionDic[.menu] {
            return searchItemList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == sectionDic[.title] {
            let cell:MenuTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCell, for: indexPath) as! MenuTitleCell
            if let trans = section?.trans {
                if !trans.isEmpty {
                    if let title = trans[0].name {
                        cell.titleLabel.text = title
                    }
                    if let description = trans[0].tranDescription {
                        cell.detailsLabel.text = description
                    }
                }
            }
            return cell
        }else {
            let cell:SubMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCell, for: indexPath) as! SubMenuCell
            if let trans = searchItemList[indexPath.row].trans {
                if !trans.isEmpty {
                    if let title = trans[0].name {
                        cell.titleLabel.text = title
                    }
                }
            }
            if let images = searchItemList[indexPath.row].images {
                if !images.isEmpty {
                    if let mURL = images[0].url {
                        cell.setImage(url: mURL)
                    }
                }else{
                    cell.imageView.image = UIImage(named: Config.placeholderImage)
                }
            }
            if let mDate = searchItemList[indexPath.row].createAt {
                if let dateAsDate = HelperManager.getDateFromStringV2(dateString: mDate) {
                    cell.dateLabel.text = HelperManager.convertDate(date: dateAsDate)
                }
            }
            if let rate = searchItemList[indexPath.row].rate {
                cell.rateLabel.text = "\(rate)"
            }
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let itemID = searchItemList[indexPath.row].id else {
            return
        }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
            desVC.itemID = "\(itemID)"
            present(desVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == sectionDic[.title] {
            return CGSize(width: view.frame.width, height: 120)
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
