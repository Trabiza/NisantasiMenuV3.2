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
            UserDefaults.standard.set(encoded, forKey: Config.categoryModel + UserDataManager.getUserLanguage())
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getCategoryDefault() -> CategoryModel? {
        
        var user: CategoryModel?
        if let userData = UserDefaults.standard.data(forKey: Config.categoryModel + UserDataManager.getUserLanguage()),
            let userDefault = try? JSONDecoder().decode(CategoryModel.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func saveMenuDefault(model: MenuModel) {
        
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: Config.menuModel + UserDataManager.getUserLanguage())
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getMenuDefault() -> MenuModel? {
        
        var user: MenuModel?
        if let userData = UserDefaults.standard.data(forKey: Config.menuModel + UserDataManager.getUserLanguage()),
            let userDefault = try? JSONDecoder().decode(MenuModel.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func saveSectionDefault(model: ItemModel, key: String) {
        
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: key + " " + Config.sectionDefault + UserDataManager.getUserLanguage())
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getSectionDefault(key: String) -> ItemModel? {
        
        var user: ItemModel?
        if let userData = UserDefaults.standard.data(forKey: key + " " + Config.sectionDefault + UserDataManager.getUserLanguage()),
            let userDefault = try? JSONDecoder().decode(ItemModel.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func saveItemDefault(model: ItemDetailsModel, key: String) {
        
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: key + " " + Config.itemDefault + UserDataManager.getUserLanguage())
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getItemDefault(key: String) -> ItemDetailsModel? {
        
        var user: ItemDetailsModel?
        if let userData = UserDefaults.standard.data(forKey: key + " " + Config.itemDefault + UserDataManager.getUserLanguage()),
            let userDefault = try? JSONDecoder().decode(ItemDetailsModel.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func saveOfferDefault(model: OfferModel) {
        
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: Config.offerModel + UserDataManager.getUserLanguage())
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getOffersDefault() -> OfferModel? {
        
        var user: OfferModel?
        if let userData = UserDefaults.standard.data(forKey: Config.offerModel + UserDataManager.getUserLanguage()),
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
        UserDefaults.standard.set(value , forKey: key + UserDataManager.getUserLanguage())
    }
    
    static func getVideoDefault(key: String) -> String? {
        var language: String? = nil
        if let lang = UserDefaults.standard.string(forKey: key + UserDataManager.getUserLanguage()) {
            language = lang
        }
        return language
    }
    
    static func saveUpdateDefault(value: String) {
        UserDefaults.standard.set(value , forKey: Config.updateDefault)
    }
    
    static func getUpdateDefault() -> String? {
        var language: String? = nil
        if let lang = UserDefaults.standard.string(forKey: Config.updateDefault) {
            language = lang
        }
        return language
    }
    
    static func removeAll(){
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            print("key is \(key)")
            defaults.removeObject(forKey: key)
        }
    }
    
    static func saveAllModelsDefault(model: NistansiModel, key: String) {
        
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static func getAllModelsDefault(key: String) -> NistansiModel? {
        
        var user: NistansiModel?
        if let userData = UserDefaults.standard.data(forKey: key),
            let userDefault = try? JSONDecoder().decode(NistansiModel.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func saveEnteredMenuDefault(value: Int) {
        UserDefaults.standard.set(value , forKey: Config.enteredMenuDefault)
    }
    
    static func getEnteredMenuDefault() -> Int {
        var value: Int = 0
        value = UserDefaults.standard.integer(forKey: Config.enteredMenuDefault)
        return value
    }
    
    static func saveSelectedRowDefault(value: Int) {
        UserDefaults.standard.set(value , forKey: Config.selectedRowDefault)
    }
    
    static func getSelectedRowDefault() -> Int {
        var value: Int = 0
        value = UserDefaults.standard.integer(forKey: Config.selectedRowDefault)
        return value
    }
    
    static func saveDetailsRowDefault(value: Int) {
        UserDefaults.standard.set(value , forKey: Config.detailsRowDefault)
    }
    
    static func getDetailsRowDefault() -> Int {
        var value: Int = 0
        value = UserDefaults.standard.integer(forKey: Config.detailsRowDefault)
        return value
    }
    
    static func changeLanguageDefault(value: String) {
        UserDefaults.standard.set(value , forKey: Config.changeLanguageDefault)
    }
    
    static func isLanguageChangedDefault() -> String? {
        var language: String? = nil
        if let lang = UserDefaults.standard.string(forKey: Config.changeLanguageDefault) {
            language = lang
        }
        return language
    }
    
    static func saveSubSectionRowDefault(value: Int) {
        UserDefaults.standard.set(value , forKey: Config.subSectionRowDefault)
    }
    
    static func getSubSectionRowDefault() -> Int {
        var value: Int = 0
        value = UserDefaults.standard.integer(forKey: Config.subSectionRowDefault)
        return value
    }
    
    static func saveIfSubSectionDefault(value: String) {
        UserDefaults.standard.set(value , forKey: Config.isSubSectionRowDefault)
    }
    
    static func isSubSectionDefault() -> String? {
        var language: String? = nil
        if let lang = UserDefaults.standard.string(forKey: Config.isSubSectionRowDefault) {
            language = lang
        }
        return language
    }
    
    static func detailsChangeLanguageDefault(value: String) {
        UserDefaults.standard.set(value , forKey: Config.detailsLanguageDefault)
    }
    
    static func isDetailsLanguageChangedDefault() -> String? {
        var language: String? = nil
        if let lang = UserDefaults.standard.string(forKey: Config.detailsLanguageDefault) {
            language = lang
        }
        return language
    }
}
