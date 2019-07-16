//
//  APIManager.swift
//  NisantasiMenu
//
//  Created by owner on 6/16/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIManager : NSObject {
    
    class func languageAPI(view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ data: LanguageModel?)->Void) {
        
        let url = URLManager.languageURL
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("language results are \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let data = Parsing.parseLanguage(jsonData: response){
                            completion(nil, true, data)
                        }else{
                            completion(nil, false, nil)
                        }
                    }else{
                        completion(nil, false, nil)
                        print("Language Failed")
                    }
                }
        }
    }
    
    
    class func categoryAPI(view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ data: CategoryModel?)->Void) {
        
        let url = URLManager.menusURL
        
        let parameters = ["lang": UserDataManager.getUserLanguage()]
        
        Alamofire.request(url, method: .get, parameters: parameters,encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("Category results are \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let data = Parsing.parseCategory(jsonData: response){
                            completion(nil, true, data)
                        }else{
                            completion(nil, false, nil)
                        }
                    }else{
                        completion(nil, false, nil)
                        print("Category Failed")
                    }
                }
        }
    }
    class func menuAPI(id: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ data: MenuModel?)->Void) {
        
        let url = URLManager.getMenus(id: id)
        
        let parameters = ["lang": UserDataManager.getUserLanguage()]
        
        Alamofire.request(url, method: .get, parameters: parameters,encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("Menu results are \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let data = Parsing.parseMenu(jsonData: response){
                            completion(nil, true, data)
                        }else{
                            completion(nil, false, nil)
                        }
                    }else{
                        completion(nil, false, nil)
                        print("Menu Failed")
                    }
                }
        }
    }
    
    class func itemsAPI(id: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ data: ItemModel?)->Void) {
        
        let url = URLManager.getItems(id: id)
        
        let parameters = ["lang": UserDataManager.getUserLanguage()]
        
        Alamofire.request(url, method: .get, parameters: parameters,encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("Items results are \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let data = Parsing.parseItem(jsonData: response){
                            completion(nil, true, data)
                        }else{
                            completion(nil, false, nil)
                        }
                    }else{
                        completion(nil, false, nil)
                        print("Items Failed")
                    }
                }
        }
    }
    
    class func itemDetailsAPI(id: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ data: ItemDetailsModel?)->Void) {
        
        let url = URLManager.getItemDetails(id: id)
        
        let parameters = ["lang": UserDataManager.getUserLanguage()]
        
        Alamofire.request(url, method: .get, parameters: parameters,encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("Items results are \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let data = Parsing.parseItemDetails(jsonData: response){
                            completion(nil, true, data)
                        }else{
                            completion(nil, false, nil)
                        }
                    }else{
                        completion(nil, false, nil)
                        print("Items Failed")
                    }
                }
        }
    }
    
    class func offersAPI(view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ data: OfferModel?)->Void) {
        
        let url = URLManager.offersURL
        
        let parameters = ["lang": UserDataManager.getUserLanguage()]
        
        Alamofire.request(url, method: .get, parameters: parameters,encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("Items results are \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let data = Parsing.parseOffers(jsonData: response){
                            completion(nil, true, data)
                        }else{
                            completion(nil, false, nil)
                        }
                    }else{
                        completion(nil, false, nil)
                        print("Items Failed")
                    }
                }
        }
    }
    
    class func ratingAPI(itemID: String, rate: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.rateAPI(itemID: itemID, rate: rate)
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("Items results are \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        completion(nil, true)
                    }else{
                        completion(nil, false)
                        print("Items Failed")
                    }
                }
        }
    }
    
    class func reviewsAPI(meal: String, food_quality: String, beverages_quality: String, hospitality: String,overall_experience: String, hear_about_us: String,visit_date: String, guest_name: String,guest_mobile: String, guest_address: String, guest_email: String, comment: String,view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.reviewsURL
        
        let parameters = ["meal": meal,
                          "food_quality": food_quality,
                          "beverages_quality": beverages_quality,
                          "hospitality": hospitality,
                          "overall_experience": overall_experience,
                          "hear_about_us": hear_about_us,
                          "comment": comment,
                          "visit_date": visit_date,
                          "guest_name": guest_name,
                          "guest_mobile": guest_mobile,
                          "guest_address": guest_address,
                          "guest_email": guest_email]
        
        print("fokin url \(url)")
        
        Alamofire.request(url, method: .post,parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("Review results are \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        completion(nil, true)
                    }else{
                        completion(nil, false)
                        print("Items Failed")
                    }
                }
        }
    }
}


