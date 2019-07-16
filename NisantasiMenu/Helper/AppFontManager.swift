//
//  AppFontManager.swift
//  NisantasiMenu
//
//  Created by owner on 6/23/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

import UIKit

enum AppFontWeight: String {
    case bold = "Bold"
    case regular = "Regular"
}

class AppFontManager: NSObject {
    static func font(size: CGFloat, weight: AppFontWeight) -> UIFont {
        let name = "Merriweather" + "-" + weight.rawValue
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
