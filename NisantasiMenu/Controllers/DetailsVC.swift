//
//  DetailsVC.swift
//  NisantasiMenu
//
//  Created by owner on 6/10/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import BMPlayer

class DetailsVC: BaseVC {
    
    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var recommenedCollection: UICollectionView!
    @IBOutlet weak var ingredientCollection: UICollectionView!
    
    @IBOutlet weak var warningConstraint: NSLayoutConstraint!
    @IBOutlet weak var recommendedConstraint: NSLayoutConstraint!
    @IBOutlet weak var warningsL: UILabel!
    @IBOutlet weak var recommendedLabel: UILabel!
    
    @IBOutlet weak var ingredientImage: UIImageView!
    @IBOutlet weak var recommendedView: UIView!
    @IBOutlet weak var recommendImage: UIImageView!
    @IBOutlet weak var otlobImage: UIImageView!
    @IBOutlet weak var uberEatsImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBOutlet weak var servedLabel: UILabel!
    @IBOutlet weak var servedConstraint: NSLayoutConstraint!
    
    let imagesCell: String = "ImagesCell"
    let recommendCell: String = "SubMenuCell"
    let videoCell: String = "VideoCell"
    let ingredientCell: String = "IngredientCell"
    
    let ratingSegue: String = "toRating"
    
    var mItem: Item?
    var itemID: String = ""
    
    var recommendedItem: [RecommendedItem] = []
    var itemImages: [Image] = []
    var itemVideos: [Videos] = []
    var itemWarnings: [String] = []
    
    var player: BMPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RTL()
        player = BMPlayer()
        setupCollections()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getItemID(_:)), name: .didPassItemID, object: nil)
    }
    
    func RTL(){
        if UserDataManager.getUserLanguage() == Config.Arabic {
            rightBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            leftBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    @objc func getItemID(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let id = dict["itemID"] as? String, let item = dict["item"] as? Item {
                itemID = "\(id)"
                setItem(model: item)
            }
            if let section = dict["section"] as? Section {
                showServedLabel(section: section)
            }
        }
    }
    
    @IBAction func nextRecommended(_ sender: Any) {
        if UserDataManager.getUserLanguage() == Config.Arabic {
            toPrevious()
        }else{
            toNext()
        }
        
    }
    
    @IBAction func perviousRecommended(_ sender: Any) {
        if UserDataManager.getUserLanguage() == Config.Arabic {
            toNext()
        }else{
           toPrevious()
        }
    }
    
    func toNext(){
        guard let indexPath = recommenedCollection.indexPathsForVisibleItems.first.flatMap({
            IndexPath(item: $0.row + 1, section: $0.section)
        }), recommenedCollection.cellForItem(at: indexPath) != nil else {
            return
        }
        recommenedCollection.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func toPrevious(){
        guard let indexPath = recommenedCollection.indexPathsForVisibleItems.first.flatMap({
            IndexPath(item: $0.row + 1, section: $0.section)
        }), recommenedCollection.cellForItem(at: indexPath) != nil else {
            return
        }
        print("clickeed \(indexPath.row)")
        recommenedCollection.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ratingSegue {
            let desVC = segue.destination as! RatingVC
            desVC.itemID = itemID
        }
    }
    
    func loadItem(section: Section) {
        showLoadingView()
   
    }
    
    func setItem(model: Item){
        
        
        if let videos = model.videos {
            self.itemVideos = videos
            self.imagesCollection.reloadData()
        }
        if let images = model.images {
            self.itemImages = images
            self.imagesCollection.reloadData()
        }
        self.setUI(mItem: model)
        
        if let recommenedations = model.recommendedItems {
            print("recommenedations \(recommenedations.count)")
            if recommenedations.isEmpty {
                self.recommendedLabel.isHidden = true
                self.recommendedView.isHidden = true
                self.recommendImage.isHidden = true
            }else{
                self.recommendedItem = recommenedations
                self.recommenedCollection.reloadData()
            }
        }else{
            self.recommendedLabel.isHidden = true
            self.recommendedView.isHidden = true
            self.recommendImage.isHidden = true
        }
        
        if let warnings = model.ingredientWarnings {
            if !warnings.isEmpty {
                self.itemWarnings = HelperManager.splitString(text: warnings)
                if self.itemWarnings.isEmpty {
                    self.warningsL.isHidden = true
                    //self.warningConstraint.constant = 1
                    self.ingredientImage.isHidden = true
                }else{
                    self.ingredientCollection.reloadData()
                }
            }else{
                self.ingredientImage.isHidden = true
                self.warningsL.isHidden = true
            }
        }else{
            self.ingredientImage.isHidden = true
            self.warningsL.isHidden = true
        }
    }
    
    
    func setUI(mItem: Item){
        if let trans = mItem.trans {
            if !trans.isEmpty {
                if let title = trans[0].name {
                    titleLabel.text = title
                }
                if let details = trans[0].tranDescription {
                    detailsLabel.text = details
                }
            }
        }
        
        if let prices = mItem.prices {
            if !prices.isEmpty {
                if let price = prices[0].price {
                    priceLabel.text = "\(price) \(NSLocalizedString("currency", comment: ""))"
                }
            }
        }
        if let delviered = mItem.deliverable {
            if delviered == 0 {
                self.uberEatsImage.alpha = 0.5
                self.otlobImage.alpha = 0.5
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
                servedConstraint.constant = 45
            }
        }
    }
    
    func setupCollections() {
        imagesCollection.register(UINib(nibName: videoCell, bundle: nil), forCellWithReuseIdentifier: videoCell)
        imagesCollection.register(UINib(nibName: imagesCell, bundle: nil), forCellWithReuseIdentifier: imagesCell)
        recommenedCollection.register(UINib(nibName: recommendCell, bundle: nil), forCellWithReuseIdentifier: recommendCell)
        ingredientCollection.register(UINib(nibName: ingredientCell, bundle: nil), forCellWithReuseIdentifier: ingredientCell)
    }
}


extension DetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 0 {
            return 2
        }else if collectionView.tag == 1{
            return 1
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            if section == 0 {
                return itemVideos.count
            }else{
                return itemImages.count
            }
        }else if collectionView.tag == 1{
            return recommendedItem.count
        }else{
            return itemWarnings.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            
            if indexPath.section == 0 {
                let cell: VideoCell = imagesCollection.dequeueReusableCell(withReuseIdentifier: videoCell, for: indexPath) as! VideoCell
                if let url = itemVideos[indexPath.row].url {
                    cell.playVideo(url: url, player: player!)
                }
                return cell
            }else{
                let cell: ImagesCell = imagesCollection.dequeueReusableCell(withReuseIdentifier: imagesCell, for: indexPath) as! ImagesCell
                if let url = itemImages[indexPath.row].url {
                    cell.setImage(url: url)
                }
                return cell
            }
        }else if collectionView.tag == 1{
            let cell: SubMenuCell = recommenedCollection.dequeueReusableCell(withReuseIdentifier: recommendCell, for: indexPath) as! SubMenuCell
            cell.shadowAndBorderForCell(cell: cell)
            
            if let name = recommendedItem[indexPath.row].name {
                cell.titleLabel.text = name
            }
            if let url = recommendedItem[indexPath.row].imagesURL {
                cell.setImage(url: url)
            }
            if let price = recommendedItem[indexPath.row].price {
                cell.priceLabel.text = "\(price) \(NSLocalizedString("currency", comment: ""))"
            }
            cell.specialImage.isHidden = true
            cell.rankingImage.isHidden = true
            return cell
        }else{
            let cell: IngredientCell = ingredientCollection.dequeueReusableCell(withReuseIdentifier: ingredientCell, for: indexPath) as! IngredientCell
            cell.imageView.image = UIImage(named: itemWarnings[indexPath.row])
            cell.imageView.image = cell.imageView.image?.withRenderingMode(.alwaysTemplate)
            cell.imageView.tintColor = UIColor.darkGray
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let width = self.view.bounds.width
            return CGSize(width: width, height: imagesCollection.frame.height)
        }else if collectionView.tag == 1{
            let width = (recommenedCollection.bounds.width / 2) - 20
            return CGSize(width: width, height: recommenedCollection.frame.height - 20)
        }else {
            let width = ingredientCollection.frame.height
            return CGSize(width: width, height: ingredientCollection.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard let id = recommendedItem[indexPath.row].id else {
                return
            }
            itemID = "\(id)"
            self.player?.pause()
            viewDidLoad()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else if collectionView.tag == 1 {
            return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 0
        }else if collectionView.tag == 1{
            return 8
        }else{
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 0
        }else if collectionView.tag == 1{
            return 8
        }else{
            return 8
        }
    }
}
