//
//  NistansiModel.swift
//  NisantasiMenu
//
//  Created by owner on 7/28/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

struct NistansiModel: Codable {
    let response: Bool?
    let data: [NistansiMenu]?
    let lang: String?
}

// MARK: - Datum
struct NistansiMenu: Codable {
    let id, status: Int?
    let createdAt, updatedAt: String?
    let itemsCount: Int?
    let trans: [MenuTran]?
    let sections: [Section]?
    let images: [Image]?
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case itemsCount = "items_count"
        case trans, sections, images
    }
}

