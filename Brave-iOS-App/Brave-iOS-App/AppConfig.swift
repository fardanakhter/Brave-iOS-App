//
//  AppCongif.swift
//  Brave-iOS-App
//
//  Copyright © 2022 Onseen. All rights reserved.
//

import Foundation

struct AppConfig {
    struct Network {
        static let refreshDuration: Double = 60 * 2 // In seconds
        static let networkTimeout: TimeInterval = 2.0 // In seconds
    }
}
