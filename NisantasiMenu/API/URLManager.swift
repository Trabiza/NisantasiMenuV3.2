//
//  URLManager.swift
//  NisantasiMenu
//
//  Created by owner on 6/16/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

struct URLManager {
    
    private static let main                         = "https://egybusiness.net/api/"
    public static let imageURL                      = "https://egybusiness.net/"
    
    public static let languageURL                   = main + "locale"
    public static let menusURL                      = main + "menus"
    public static let offersURL                     = main + "offers"
    public static let reviewsURL                    = main + "add/review"
    public static let updateURL                     = main + "update"
    public static let allURL                        = main + "all"
    
    public static func getMenus(id: String) -> String {
        return main + "menu/\(id)"
    }
    public static func getItems(id: String) -> String {
        return main + "section/\(id)"
    }
    public static func getItemDetails(id: String) -> String {
        return main + "item/\(id)"
    }
    public static func rateAPI(itemID: String, rate: String) -> String {
        return main + "item/rate/\(itemID)/\(rate)"
    }
}
