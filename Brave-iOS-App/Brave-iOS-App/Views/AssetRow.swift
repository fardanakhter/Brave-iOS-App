//
//  AssetRow.swift
//  Brave-iOS-App
//
//  Copyright © 2022 Onseen. All rights reserved.
//

import SwiftUI

struct AssetRow: View {
    let viewModel: AssetRowViewModel

    var body: some View {
        HStack {
            viewModel.image()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(viewModel.asset.name)
                    .font(Font.body.weight(.semibold))
                Text(viewModel.asset.symbol.uppercased())
                    .font(Font.footnote.weight(.light))
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("$\(viewModel.asset.marketData.currentPrice.usd)")
                    .font(Font.body.weight(.medium))
                if let btcValue = viewModel.asset.marketData.currentPrice.btc{
                    Text("\(btcValue) BTC")
                        .font(Font.body.weight(.light))
                }
            }
        }
    }
}

struct AssetRow_Previews: PreviewProvider {
    static var previews: some View {
        let model =  AssetDataModel(name: "Etherium", symbol: "ETH",
                                    usd: 0.3123, btc: 1.0)
        let viewModel = AssetRowViewModel(model)
        AssetRow(viewModel: viewModel)
    }
}
