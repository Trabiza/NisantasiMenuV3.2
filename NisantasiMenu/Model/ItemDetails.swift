//
//  ItemDetails.swift
//  NisantasiMenu
//
//  Created by owner on 6/18/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct ItemDetailsModel: Codable {
    let response: Bool?
    let data: ItemDetails?
    let lang: String?
}

// MARK: - DataClass
struct ItemDetails: Codable {
    let items: [Item]?
    let recommendedItems: [RecommendedItem]?
    let rating: Float?
    
    enum CodingKeys: String, CodingKey {
        case items
        case recommendedItems = "recommended_items"
        case rating
    }
}

// MARK: - RecommendedItem
struct RecommendedItem: Codable {
    let id: Int?
    let sectionID, menuID: Int?
    let preperationTime, markAsNew, markAsDignature, markAsOffer: Int?
    let createdAt: String?
    let name, recommendedItemDescription: String?
    let ingredientWarnings: String?
    let imagesURL, videosURL: String?
    let price: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sectionID = "section_id"
        case menuID = "menu_id"
        case preperationTime = "preperation_time"
        case markAsNew = "mark_as_new"
        case markAsDignature = "mark_as_dignature"
        case markAsOffer = "mark_as_offer"
        case createdAt = "created_at"
        case name
        case price
        case recommendedItemDescription = "description"
        case ingredientWarnings = "ingredient_warnings"
        case imagesURL = "images_url"
        case videosURL = "videos_url"
    }
}
