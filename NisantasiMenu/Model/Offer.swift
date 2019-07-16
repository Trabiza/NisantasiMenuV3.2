//
//  Offer.swift
//  NisantasiMenu
//
//  Created by owner on 6/19/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct OfferModel: Codable {
    let response: Bool?
    let data: Offer?
    let lang: String?
}

// MARK: - DataClass
struct Offer: Codable {
    let items: [Item]?
}
