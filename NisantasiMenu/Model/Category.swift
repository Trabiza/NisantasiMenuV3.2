//
//  Category.swift
//  NisantasiMenu
//
//  Created by owner on 6/17/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct CategoryModel: Codable {
    let response: Bool?
    let data: [Category]?
    let lang: String?
}

// MARK: - Datum
struct Category: Codable {
    let id, status: Int?
    let trans: [CategoryTran]?
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case trans
    }
}

// MARK: - Tran
struct CategoryTran: Codable {
    let id, menuID: Int?
    let lang, title, tranDescription: String?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case menuID = "menu_id"
        case lang, title
        case tranDescription = "description"
        case status
    }
}
