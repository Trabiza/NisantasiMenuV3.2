//
//  UserDataManager.swift
//  NisantasiMenu
//
//  Created by owner on 6/17/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


public class UserDataManager {
    
    public static func getUserLanguage() -> String {
        
        let lang: String?
        if let language = DefaultManager.getLanguageDefault(){
            if language.isEmpty{
                lang = Config.English
            }else{
                lang = language
            }
        }else{
            let deviceLang = Locale.current.languageCode
            if (deviceLang?.isEmpty)! || deviceLang == nil {
                lang = Config.English
            }else{
                lang = deviceLang
            }
        }
        return lang!
    }
    
}
