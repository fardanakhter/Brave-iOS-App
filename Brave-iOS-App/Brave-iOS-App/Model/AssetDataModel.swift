//
//  Asset.swift
//  Brave-iOS-App
//
//
import SwiftUI

struct AssetDataModel: AssetDataModelProtocol {
    let name: String
    let symbol: String
    var image: AssetImage?
    let marketData: AssetMarketData
    
    struct AssetImage: Decodable {
        let large: String
    }

    struct AssetMarketData: Decodable {
        let currentPrice: AssetPrice
    }

    struct AssetPrice: Decodable {
        let usd: Double
        let btc: Double
    }

    init(name: String, symbol: String, image: String? = nil, usd: Double, btc: Double){
        self.name = name
        self.symbol = symbol
        if let image = image {
            self.image = AssetImage(large: image)
        }
        self.marketData = AssetMarketData(currentPrice: AssetPrice(usd: usd, btc: btc))
    }
}

extension AssetDataModel: Hashable {
    static func == (lhs: AssetDataModel, rhs: AssetDataModel) -> Bool {
        lhs.name == rhs.name && lhs.symbol == rhs.symbol
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(symbol)
    }
}
