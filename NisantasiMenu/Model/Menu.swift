//
//  Menu.swift
//  NisantasiMenu
//
//  Created by owner on 6/17/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct MenuModel: Codable {
    let response: Bool?
    let data: [Menu]?
    let lang: String?
}

// MARK: - Datum
struct Menu: Codable {
    let id, status: Int?
    let trans: [MenuTran]?
    let sections: [Section]?
    let images: [Image]?
    
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case trans, sections, images
    }
}

// MARK: - Image
struct Image: Codable {
    let id: Int?
    let menuID, sectionID: Int?
    let itemID: Int?
    let url: String?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case menuID = "menu_id"
        case sectionID = "section_id"
        case itemID = "item_id"
        case url, status
    }
}


// MARK: - Section
struct Section: Codable {
    let id: Int?
    let sectionID: Int?
    let menuID, status: Int?
    let createdAt: String?
    let sectionsCount, itemsCount: Int?
    let trans: [SectionTran]?
    let images: [Image]?
    let items: [Item]?
    let sections: [Section]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sectionID = "section_id"
        case menuID = "menu_id"
        case status
        case createdAt = "created_at"
        case sectionsCount = "sections_count"
        case itemsCount = "items_count"
        case trans, images, items, sections
    }
}

// MARK: - SectionTran
struct SectionTran: Codable {
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

// MARK: - MenuTran
struct MenuTran: Codable {
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
