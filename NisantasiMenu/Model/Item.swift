//
//  Item.swift
//  NisantasiMenu
//
//  Created by owner on 6/17/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct ItemModel: Codable {
    let response: Bool?
    let data: [SectionItem]?
    let lang: String?
}

// MARK: - Datum
struct SectionItem: Codable {
    let id: Int?
    let menuID, status: Int?
    let trans: [SectionItemTran]?
    let items: [Item]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case menuID = "menu_id"
        case status
        case trans, items
    }
}

// MARK: - Item
struct Item: Codable {
    let id, sectionID: Int?
    let menuID: Int?
    let createAt: String?
    let preperationTime: Int?
    let recommendedItem: String?
    let markAsNew, markAsDignature, status: Int?
    let salesRanking: Int?
    let deliverable: Int?
    let rate: Float?
    let ingredientWarnings: String?
    let trans: [ItemTran]?
    let images: [Image]?
    let prices: [Prices]?
    let videos: [Videos]?
    let recommendedItems: [RecommendedItem]?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case sectionID = "section_id"
        case menuID = "menu_id"
        case preperationTime = "preperation_time"
        case recommendedItem = "recommended_item"
        case markAsNew = "mark_as_new"
        case markAsDignature = "mark_as_signature"
        case status
        case deliverable
        case salesRanking = "sales_ranking"
        case createAt = "created_at"
        case ingredientWarnings = "ingredient_warnings"
        case recommendedItems = "recommended_items"
        case trans, images
        case rate
        case videos
        case prices
    }
}

struct Videos: Codable{
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}

struct Prices: Codable{
    let price: String?
    
    enum CodingKeys: String, CodingKey {
        case price
    }
}


// MARK: - ItemTran
struct ItemTran: Codable {
    let id, itemID: Int?
    let lang, name, tranDescription: String?
    
    let status: Int?

    
    enum CodingKeys: String, CodingKey {
        case id
        case itemID = "item_id"
        case lang, name
        case tranDescription = "description"
        
        case status
    }
}

// MARK: - DatumTran
struct SectionItemTran: Codable {
    let id, sectionID: Int?
    let lang, name, tranDescription, note: String?
    let displayAs: String?
    let nOfColumns: Int?
    let gridViewTitlePosition: String?
    let displaySimilarItems, markAsNew, markAsDignature, status: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sectionID = "section_id"
        case lang, name
        case tranDescription = "description"
        case note
        case displayAs = "display_as"
        case nOfColumns = "n_of_columns"
        case gridViewTitlePosition = "grid_view_title_position"
        case displaySimilarItems = "display_similar_items"
        case markAsNew = "mark_as_new"
        case markAsDignature = "mark_as_dignature"
        case status
    }
}
