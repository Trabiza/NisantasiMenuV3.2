//
//  VideoCell.swift
//  NisantasiMenu
//
//  Created by owner on 6/18/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import AudioToolbox
import BMPlayer
import Photos

class VideoCell: UICollectionViewCell {
    
    @IBOutlet weak var mView: UIView!
    
    func playVideo(url: String, player: BMPlayer){
        
        if let videoPath = DefaultManager.getVideoDefault(key: url){
            offlinePlay(url: videoPath, player: player)
        }else{
            onlinePLay(url: url, player: player)
            downloadVideo(url: url)
        }
    }
    
    func onlinePLay(url: String, player: BMPlayer){
        print("Online video")
        let mURL = URLManager.imageURL + url
        
        BMPlayerConf.enablePlaytimeGestures = false
        BMPlayerConf.enableBrightnessGestures = false
        BMPlayerConf.enableVolumeGestures = false
        BMPlayerConf.topBarShowInCase = .none
        
        let asset = BMPlayerResource(url: URL(string: mURL)!,
                                     name: " ")
        //player = BMPlayer()
        player.setVideo(resource: asset)
        mView.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(mView).offset(0)
            make.left.right.equalTo(mView)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            // make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
            make.height.equalTo(400)
        }
    }
    
    func offlinePlay(url: String, player: BMPlayer){
        print("Offile video")
        //let mURL = "file:///var/mobile/Media/DCIM/100APPLE/IMG_0016.MP4"
        let mURL = url
        
        print("Video url \(url)")
        
        BMPlayerConf.enablePlaytimeGestures = false
        BMPlayerConf.enableBrightnessGestures = false
        BMPlayerConf.enableVolumeGestures = false
        BMPlayerConf.topBarShowInCase = .none
        
        /*let asset = BMPlayerResource(url: URL(string: mURL)!,
         name: " ")*/
        let asset = BMPlayerResource(url: URL(string: mURL)!)
        //player = BMPlayer()
        player.setVideo(resource: asset)
        mView.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(mView).offset(0)
            make.left.right.equalTo(mView)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            // make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
            make.height.equalTo(400)
        }
    }
    
    func downloadVideo(url: String){
        let videoImageUrl = URLManager.imageURL + url
        let mURL: String = url
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: videoImageUrl),
                let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/tempFile.mp4"
                print("filePath is \(filePath)")
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            let fetchOptions = PHFetchOptions()
                            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                            
                            // After uploading we fetch the PHAsset for most recent video and then get its current location url
                            
                            let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions).lastObject
                            PHImageManager().requestAVAsset(forVideo: fetchResult!, options: nil, resultHandler: { (avurlAsset, audioMix, dict) in
                                let newObj = avurlAsset as! AVURLAsset
                                print("saved url   \(newObj.url.absoluteString)")
                                DefaultManager.saveVideoDefault(value: newObj.url.absoluteString, key: mURL)
                                
                                // This is the URL we need now to access the video from gallery directly.
                                print("Video is saved!")
                            })
                        }
                    }
                }
            }
        }
    }

}
