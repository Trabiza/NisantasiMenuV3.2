//
//  Language.swift
//  NisantasiMenu
//
//  Created by owner on 6/16/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct LanguageModel: Codable {
    let response: Bool?
    let data: [Language]?
    let lang: String?
}

// MARK: - Datum
struct Language: Codable {
    let id: Int?
    let name, code, flag: String?
    let status: Int?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, code, flag, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
