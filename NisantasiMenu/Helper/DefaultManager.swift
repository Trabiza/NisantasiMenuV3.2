//
//  DefaultManager.swift
//  NisantasiMenu
//
//  Created by owner on 6/17/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

public class DefaultManager {
    
    static func saveLanguageDefault(value: String) {
        UserDefaults.standard.set(value , forKey: Config.languageDefault)
    }
    
    static func getLanguageDefault() -> String? {
        var language: String? = nil
        if let lang = UserDefaults.standard.string(forKey: Config.languageDefault) {
            language = lang
        }
        return language
    }
    
    static func saveCategoryDefault(model: CategoryModel) {
        
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: Config.categoryModel)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getCategoryDefault() -> CategoryModel? {
        
        var user: CategoryModel?
        if let userData = UserDefaults.standard.data(forKey: Config.categoryModel),
            let userDefault = try? JSONDecoder().decode(CategoryModel.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func saveMenuDefault(model: MenuModel) {
        
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: Config.menuModel)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getMenuDefault() -> MenuModel? {
        
        var user: MenuModel?
        if let userData = UserDefaults.standard.data(forKey: Config.menuModel),
            let userDefault = try? JSONDecoder().decode(MenuModel.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func saveSectionDefault(model: ItemModel, key: String) {
        
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: key + " " + Config.sectionDefault)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getSectionDefault(key: String) -> ItemModel? {
        
        var user: ItemModel?
        if let userData = UserDefaults.standard.data(forKey: key + " " + Config.sectionDefault),
            let userDefault = try? JSONDecoder().decode(ItemModel.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func saveItemDefault(model: ItemDetailsModel, key: String) {
        
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: key + " " + Config.itemDefault)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getItemDefault(key: String) -> ItemDetailsModel? {
        
        var user: ItemDetailsModel?
        if let userData = UserDefaults.standard.data(forKey: key + " " + Config.itemDefault),
            let userDefault = try? JSONDecoder().decode(ItemDetailsModel.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func saveOfferDefault(model: OfferModel) {
        
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: Config.offerModel)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getOffersDefault() -> OfferModel? {
        
        var user: OfferModel?
        if let userData = UserDefaults.standard.data(forKey: Config.offerModel),
            let userDefault = try? JSONDecoder().decode(OfferModel.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func saveLanguageListDefault(model: LanguageModel) {
        
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: Config.languageDefault)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getLanguageListDefault() -> LanguageModel? {
        
        var user: LanguageModel?
        if let userData = UserDefaults.standard.data(forKey: Config.languageDefault),
            let userDefault = try? JSONDecoder().decode(LanguageModel.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func saveVideoDefault(value: String, key: String) {
        UserDefaults.standard.set(value , forKey: key)
    }
    
    static func getVideoDefault(key: String) -> String? {
        var language: String? = nil
        if let lang = UserDefaults.standard.string(forKey: key) {
            language = lang
        }
        return language
    }
}
