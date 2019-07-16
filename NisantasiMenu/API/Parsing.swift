//
//  Parsing.swift
//  NisantasiMenu
//
//  Created by owner on 6/16/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import Alamofire


public class Parsing {
    
    //Get response from server {TRUE or FALSE}
    static func getResponse(jsonData: DataResponse<Any>?) -> Bool {
        
        var response: Bool = false
        
        do{
            let resultObject = try JSONDecoder().decode(Response.self, from: (jsonData?.data!)!)
            if resultObject.response {
                response = true
            }else{
                response = false
            }
        }catch {
            print("Error: \(error)")
        }
        
        return response
    }
    
    
    static func parseLanguage(jsonData: DataResponse<Any>?) -> LanguageModel? {
        
        var shops: LanguageModel??
        do{
            shops = try JSONDecoder().decode(LanguageModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return shops!
    }
    
    static func parseCategory(jsonData: DataResponse<Any>?) -> CategoryModel? {
        
        var shops: CategoryModel??
        do{
            shops = try JSONDecoder().decode(CategoryModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return shops!
    }

    static func parseMenu(jsonData: DataResponse<Any>?) -> MenuModel? {
        
        var shops: MenuModel??
        do{
            shops = try JSONDecoder().decode(MenuModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return shops!
    }
    static func parseItem(jsonData: DataResponse<Any>?) -> ItemModel? {
        
        var shops: ItemModel??
        do{
            shops = try JSONDecoder().decode(ItemModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return shops!
    }
    static func parseItemDetails(jsonData: DataResponse<Any>?) -> ItemDetailsModel? {
        
        var shops: ItemDetailsModel??
        do{
            shops = try JSONDecoder().decode(ItemDetailsModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return shops!
    }
    static func parseOffers(jsonData: DataResponse<Any>?) -> OfferModel? {
        
        var shops: OfferModel??
        do{
            shops = try JSONDecoder().decode(OfferModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return shops!
    }
}
