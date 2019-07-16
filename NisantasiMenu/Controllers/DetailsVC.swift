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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timrLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rateImage: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    
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
        
        HelperManager.RTLBtn(backBtn)
        player = BMPlayer()
        setupCollections()
        //loadItem()
        rateAction()
        
        if let model = DefaultManager.getItemDefault(key: itemID) {
            print("Offline mode")
            setItem(model: model)
        }else{
            loadItem()
        }
    }
    
    func rateAction(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailsVC.rateFun))
        rateLabel.isUserInteractionEnabled = true
        rateImage.isUserInteractionEnabled = true
        rateLabel.addGestureRecognizer(tap)
        rateImage.addGestureRecognizer(tap)
    }
    
    @objc func rateFun(sender:UITapGestureRecognizer) {
        print("tap working")
        performSegue(withIdentifier: "toRating", sender: nil)
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        setupCollections()
        loadItem()
    }*/
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        /*if mItem?.id == nil {
            return
        }
        performSegue(withIdentifier: ratingSegue, sender: nil)*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ratingSegue {
            let desVC = segue.destination as! RatingVC
            desVC.itemID = itemID
        }
    }
    
    func loadItem() {
        showLoadingView()
        APIManager.itemDetailsAPI(id: itemID, view: self.view) { (error, success, model) in
            self.hideLoadindView()
            if error != nil || !success{
                return
            }
            DefaultManager.saveItemDefault(model: model!, key: self.itemID)
            self.setItem(model: model!)
        }
    }
    
    func setItem(model: ItemDetailsModel){
        if let items = model.data?.items {
            if !items.isEmpty {
                
                if let videos = items[0].videos {
                    self.itemVideos = videos
                    self.imagesCollection.reloadData()
                }
                
                if let images = items[0].images {
                    self.itemImages = images
                    self.imagesCollection.reloadData()
                }
            }
            
            self.setUI(mItem: items[0])
        }
        
        if let rating = model.data?.rating {
            self.rateLabel.text = "\(rating) rate"
        }
        
        
        if let recommendedItem = model.data?.recommendedItems {
            if recommendedItem.isEmpty {
                self.recommendedLabel.isHidden = true
                self.recommendedConstraint.constant = 1
            }else{
                self.recommendedItem = recommendedItem
                self.recommenedCollection.reloadData()
            }
        }
        
        if let items = model.data?.items {
            if !items.isEmpty {
                if let gradient = items[0].ingredientWarnings {
                    print("warnings are \(gradient)")
                    self.itemWarnings = HelperManager.splitString(text: gradient)
                    if self.itemWarnings.isEmpty {
                        self.warningsL.isHidden = true
                        self.warningConstraint.constant = 1
                    }else{
                        self.ingredientCollection.reloadData()
                    }
                }else{
                    self.warningsL.isHidden = true
                }
            }
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
                    priceLabel.text = "\(price)"
                }
            }
        }
        
        if let preparetionTime = mItem.preperationTime {
            timrLabel.text = "\(preparetionTime) min"
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
            
            if let name = recommendedItem[indexPath.row].name {
                cell.titleLabel.text = name
            }
            if let url = recommendedItem[indexPath.row].imagesURL {
                cell.setImage(url: url)
            }
            if let mDate = recommendedItem[indexPath.row].createdAt {
                if let dateAsDate = HelperManager.getDateFromStringV2(dateString: mDate) {
                    cell.dateLabel.text = HelperManager.convertDate(date: dateAsDate)
                }
            }
            return cell
        }else{
            let cell: IngredientCell = ingredientCollection.dequeueReusableCell(withReuseIdentifier: ingredientCell, for: indexPath) as! IngredientCell
            cell.imageView.image = UIImage(named: itemWarnings[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let width = UIScreen.main.bounds.width
            return CGSize(width: width, height: imagesCollection.frame.height)
        }else if collectionView.tag == 1{
            let width = UIScreen.main.bounds.width / 4
            return CGSize(width: width, height: recommenedCollection.frame.height)
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
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 0
        }else if collectionView.tag == 1{
            return 6
        }else{
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 0
        }else if collectionView.tag == 1{
            return 6
        }else{
            return 8
        }
    }
}
