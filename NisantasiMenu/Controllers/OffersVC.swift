//
//  OffersVC.swift
//  NisantasiMenu
//
//  Created by owner on 6/19/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class OffersVC: UIViewController {
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    
    var itemList: [Item] = []
    let offerNIB: String = "OffersCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        HelperManager.RTLBtn(backBtn)
        registerNibs()
        
        
        if let model = DefaultManager.getOffersDefault() {
            print("Offline mode")
            getOfflineOffers(model: model)
        }else{
            getOffers()
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getOffers(){
        showLoadingView()
        APIManager.offersAPI(view: self.view) { (error, success, model) in
            self.hideLoadindView()
            if error != nil || !success{
                return
            }
            DefaultManager.saveOfferDefault(model: model!)
            if let items = model?.data?.items {
                self.itemList = items
                self.mCollectionView.reloadData()
            }
        }
    }
    
    func getOfflineOffers(model: OfferModel){
        if let items = model.data?.items {
            self.itemList = items
            self.mCollectionView.reloadData()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.mCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            print("page at centre = \(currentPage)")
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.mCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    func registerNibs() {
        
        mCollectionView.showsHorizontalScrollIndicator = false
        
        mCollectionView.register(UINib(nibName: offerNIB, bundle: nil), forCellWithReuseIdentifier: offerNIB)
        
        let floawLayout = UPCarouselFlowLayout()
        floawLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 160.0, height: mCollectionView.frame.size.height)
        floawLayout.scrollDirection = .horizontal
        floawLayout.sideItemScale = 0.8
        floawLayout.sideItemAlpha = 1.0
        floawLayout.spacingMode = .fixed(spacing: 5.0)
        mCollectionView.collectionViewLayout = floawLayout
    }
}


extension OffersVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:OffersCell = collectionView.dequeueReusableCell(withReuseIdentifier: offerNIB, for: indexPath) as! OffersCell
        
        if let trans = itemList[indexPath.row].trans {
            if !trans.isEmpty {
                if let title = trans[0].name {
                    cell.titleLabel.text = title
                }
                if let details = trans[0].tranDescription {
                    cell.detailsLabel.text = details
                }
            }
        }
        if let images = itemList[indexPath.row].images {
            if !images.isEmpty {
                if let mURL = images[0].url {
                    cell.setImage(url: mURL)
                }
            }else{
                cell.imageView.image = UIImage(named: Config.placeholderImage)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
            if let id = itemList[indexPath.row].id {
                desVC.itemID = "\(id)"
            }
            present(desVC, animated: true)
        }
    }
}
