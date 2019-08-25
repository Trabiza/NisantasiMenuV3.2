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
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var servedLabel: UILabel!
    
    let menuCell: String = "SubMenuCell"
    let titleCell: String = "MenuTitleCell"
    
    var sectionDic = [SubMenuSections.title: 0, SubMenuSections.menu: 1]
    
    var section: Section?
    
    var itemList: [Item] = []
    var searchItemList: [Item] = []
    
    var mSectionID: String = ""
    var sectionsArr: [Section] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        setupMenu()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadSection(_:)), name: .didPassSection, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchAction(_:)), name: .didPassSearch, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadSections(_:)), name: .didPassSections, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadSubSection(_:)), name: .didPassSubSections, object: nil)
    }
    
    
    @objc func loadSections(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let id = dict["key"] as? Int {
                mSectionID = "\(id)"
            }
            
            if let list = dict["list"] as? [Section]{
                print("sections are \(list.count)")
                self.sectionsArr = list
            }
        }
    }
    
    @objc func loadSection(_ notification: NSNotification) {
        print(notification.userInfo ?? "")
        
        if let dict = notification.userInfo as NSDictionary? {
            if let mSection = dict["section"] as? Section{
                self.section = mSection
                setUpSection()
                showServedLabel(section: mSection)
            }
        }
    }
    
    @objc func loadSubSection(_ notification: NSNotification) {
        
        if let dict = notification.userInfo as NSDictionary? {
            if let items = dict["items"] as? [Item], let mSection = dict["section"] as? Section{
                print("sub sections \(items.count)")
                self.section = mSection
                self.itemList = items
                self.searchItemList = items
                self.mCollectionView.reloadData()
            }
        }
    }
    
    func showServedLabel(section: Section){
        
        guard let trans = section.trans else{
            return
        }
        if trans.isEmpty {
            return
        }
        if let title = trans[0].name {
            if title.lowercased() == Config.BREAKFAST.lowercased() || title.lowercased() == Config.arBREAKFAST.lowercased(){
                servedLabel.isHidden = false
            }else{
                servedLabel.isHidden = true
            }
        }
    }
    
    @objc func searchAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let txt = dict["search"] as? String{
                print("text is \(txt)")
                searchFunc(txt)
            }
        }
    }
    
    func setUpSection(){
        itemList.removeAll()
        searchItemList.removeAll()
        mCollectionView.reloadData()
        
        if let trans = section?.trans {
            if !trans.isEmpty {
                if let title = trans[0].name {
                    sectionTitle.text = title
                }
            }
        }
        loadItems()
        /*if let model = DefaultManager.getSectionDefault(key: "\(id)"){
            print("offline mode")
            loadItemOffilne(model: model)
        }else{
            loadItems()
        }*/
        mCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
       
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
    
    @objc func searchFunc(_ searchText:String) {
        
        if searchText.isEmpty {
            searchItemList = itemList
            mCollectionView.reloadData()
            return
        }
        searchItemList.removeAll()
        sectionsArr.forEach { (section) in
            if let items = section.items {
                items.forEach({ (item) in
                    if let trans = item.trans {
                        if !trans.isEmpty {
                            if let name = trans[0].name {
                                if name.lowercased().contains(searchText.lowercased()) {
                                    searchItemList.append(item)
                                }
                            }
                        }
                    }
                })
            }
        }
        
        /*searchItemList = itemList.filter({ (item) -> Bool in
            if let trans = item.trans {
                if !trans.isEmpty {
                    return (trans[0].name?.lowercased().contains(searchText.lowercased()))!
                }
            }
            return false
        })*/
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
        print("items loading....")
        guard let id = section?.id else{
            return
        }
        if let model = DefaultManager.getAllModelsDefault(key: UserDataManager.getUserLanguage()) {
            print("items loading.....\(UserDataManager.getUserLanguage())")
            guard let menus = model.data else{
                return
            }
            print("defalut entered menu \(DefaultManager.getEnteredMenuDefault())")
            guard let mSections = menus[DefaultManager.getEnteredMenuDefault()].sections else {
                return
            }
            mSections.forEach { (mSection) in
                if mSection.id == id {
                    guard let mItems = mSection.items else {
                        return
                    }
                    self.itemList = mItems
                    self.searchItemList = mItems
                    self.mCollectionView.reloadData()
                }
            }
        }
    }

}


extension SubMenuVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return searchItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:SubMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCell, for: indexPath) as! SubMenuCell
        
        cell.shadowAndBorderForCell(cell: cell)
        cell.imageView.layer.cornerRadius = 12
        
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
        if let prices = searchItemList[indexPath.row].prices {
            if !prices.isEmpty {
                if let price = prices[0].price {
                    cell.priceLabel.text = "\(price) \(NSLocalizedString("currency", comment: ""))"
                }
            }
        }
        if let special = searchItemList[indexPath.row].markAsDignature {
            print("markAsDignature is \(special)")
            if special == 0 {
                cell.specialImage.isHidden = true
            }else{
                cell.specialImage.isHidden = false
            }
        }
        if let ranking = searchItemList[indexPath.row].salesRanking {
            if ranking == 0 {
                cell.rankingImage.isHidden = true
            }else{
                cell.rankingImage.isHidden = false
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*if DefaultManager.isLanguageChangedDefault() != nil {
            UserDefaults.standard.removeObject(forKey: Config.changeLanguageDefault)
        }*/
        
        guard let itemID = searchItemList[indexPath.row].id else {
            return
        }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailsContainerVC") as? DetailsContainerVC {
            desVC.itemID = "\(itemID)"
            desVC.menuList = self.sectionsArr
            desVC.section = self.section
            desVC.item = searchItemList[indexPath.row]
            desVC.row = indexPath.row
            DefaultManager.saveDetailsRowDefault(value: indexPath.row)
            present(desVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width / 2) - 8
        return CGSize(width: width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
}



