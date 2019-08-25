//
//  Extenions+Notification.swift
//  NisantasiMenu
//
//  Created by owner on 7/18/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didPassSections              = Notification.Name("PassSections")
    static let didPassSectionsDetails       = Notification.Name("PassSectionsDetails")
    static let didPassSection               = Notification.Name("PassSection")
    static let didPassSearch                = Notification.Name("PassSearch")
    static let didPassItemID                = Notification.Name("PassItemID")
    static let didDismissDetails            = Notification.Name("DismissDetails")
    static let didUpdateMainContainer       = Notification.Name("UpdateMainContainer")
    static let didLanuage                   = Notification.Name("didLanuage")
    static let didDetailsLanuage            = Notification.Name("didDetailsLanuage")
    static let didPassSubSections           = Notification.Name("didPassSubSections")
    static let didPassRow                   = Notification.Name("didPassRow")
}
