//
//  AssetViewModel.swift
//  Brave-iOS-App
//
//  Copyright © 2022 Onseen. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class AssetListViewModel: ObservableObject {
    @Published var assets = [AssetDataModel]()
    private var cancellables: Set<AnyCancellable> = []
    private var dataFetcher = AssetDataFetcher()
    var timer: Timer?

    init(_ asset: [AssetDataModel] = []) {
        timer = Timer.scheduledTimer(withTimeInterval: AppConfig.Network.refreshDuration,
                                     repeats: true, block: { _ in
            self.refresh()
        })
        self.assets = asset
    }

    deinit {
        timer?.invalidate()
    }

    func refresh() {
        dataFetcher.loadDataForAllCoins()
            .sink { assets in
                self.assets = assets
            }
            .store(in: &cancellables)
    }
    
    func filterAssets(with searchText: String) -> [AssetDataModel] {
        return assets.filter{
            searchText.isEmpty || $0.name.hasPrefix(searchText)
        }
    }
}
