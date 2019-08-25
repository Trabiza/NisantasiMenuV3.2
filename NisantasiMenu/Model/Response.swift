//
//  Response.swift
//  NisantasiMenu
//
//  Created by owner on 6/16/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

struct Response : Codable{
    
    let response: Bool
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
}

struct ResponseUpdate : Codable{
    
    let response: Bool?
    let data: String?
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
        case data
    }
}
