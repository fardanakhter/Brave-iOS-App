//
//  AssetList.swift
//  Brave-iOS-App
//
//  Copyright © 2022 Onseen. All rights reserved.
//

import SwiftUI

struct AssetList: View {
    @StateObject var viewModel: AssetListViewModel
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(viewModel.filterAssets(with: searchText), id: \.self) { asset in
                        AssetRow(viewModel: AssetRowViewModel(asset))
                            .frame(height: 70)
                    }
                } header: {
                    Text("Assets")
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}

struct AssetList_Previews: PreviewProvider {
    static var previews: some View {
        let model = [AssetDataModel(name: "Bitcoin", symbol: "BTC",
                                    usd: 53535.0, btc: 1.0),
                     AssetDataModel(name: "Etherium", symbol: "ETH",
                                    usd: 5343.0, btc: 0.3123),
                     AssetDataModel(name: "Binance Coin", symbol: "BNB",
                                    usd: 5343.0, btc: 0.3123),
                     AssetDataModel(name: "Doge Coin", symbol: "DOGE",
                                    usd: 5343.0, btc: 0.3123)]
        let viewModel = AssetListViewModel(model)
        AssetList(viewModel: viewModel, searchText: .constant(""))
    }
}
