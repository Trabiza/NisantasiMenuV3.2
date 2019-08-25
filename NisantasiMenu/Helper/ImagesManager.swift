//
//  ImagesManager.swift
//  NisantasiMenu
//
//  Created by owner on 6/17/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import Kingfisher

public class ImagesManager {
    public static func setImage(url: String, image: UIImageView){
        
        KingfisherManager.shared.cache.maxCachePeriodInSecond = .infinity
        
        let mUrl = "\(URLManager.imageURL)\(url)"
        print("image url is \(mUrl)")
        guard let urlString = mUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        
        let placeholderImage = UIImage(named: Config.placeholderImage)
        //let processor = RoundCornerImageProcessor(cornerRadius: 20)
        image.kf.indicatorType = .activity
        let resource = ImageResource(downloadURL: url, cacheKey:  urlString)
        //image.kf.setImage(with: resource, placeholder: placeholderImage , options: [])
        image.kf.setImage(with: resource, placeholder: placeholderImage, options: []) { (mImage, error, imageCacheType, imageUrl) in
            if error != nil {
                image.image = UIImage(named: Config.placeholderImage)
            }
        }
    }
    
    public static func cacheImage(cacheKey: String, image: UIImageView){
        let mUrl = "\(URLManager.imageURL)\(cacheKey)"
        KingfisherManager.shared.cache.maxCachePeriodInSecond = .infinity
        
        let cache = ImageCache.default
        let cached = cache.imageCachedType(forKey: mUrl).cached
        if cached {
            print("image cached ya man")
        }else{
            setImage(url: cacheKey, image: image)
            print("image cached not ya man")
        }
    }
    
    public static func clearCaching(){
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
}
