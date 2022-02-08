//
//  AssetRowViewModel.swift
//  Brave-iOS-App
//
//  Copyright © 2022 Onseen. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class AssetRowViewModel: ObservableObject {
    var asset: AssetDataModel
    
    init(_ asset: AssetDataModel){
        self.asset = asset
    }
    
    func image() -> AssetImage {
        AssetImage(withURL: asset.image?.large ?? "")
    }
}
