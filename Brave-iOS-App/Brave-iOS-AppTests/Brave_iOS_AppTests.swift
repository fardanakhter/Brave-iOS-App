//
//  Brave_iOS_AppTests.swift
//  Brave-iOS-AppTests
//
//  Copyright © 2022 Onseen. All rights reserved.
//

import XCTest
import Combine
@testable import Brave_iOS_App

class Brave_iOS_AppTests: XCTestCase {

    var testDataFetcher: AssetDataFetcher!
    var testAssets: [AssetDataModel]!
    var testViewModel: AssetListViewModel!
    var testSubscription: AnyCancellable?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        testDataFetcher = AssetDataFetcher()
        testAssets = [AssetDataModel(name: "Bitcoin", symbol: "BTC",
                                     usd: 53535.0, btc: 1.0),
                      AssetDataModel(name: "Etherium", symbol: "ETH",
                                     usd: 5343.0, btc: 0.3123),
                      AssetDataModel(name: "Binance Coin", symbol: "BNB",
                                     usd: 5343.0, btc: 0.3123),
                      AssetDataModel(name: "Doge Coin", symbol: "DOGE",
                                     usd: 5343.0, btc: 0.3123)]
        testViewModel = AssetListViewModel(testAssets)
    }

    override func tearDownWithError() throws {
        testDataFetcher = nil
        testAssets = nil
        testViewModel = nil
        testSubscription?.cancel()
        
        super.tearDown()
    }
    
    func testFetchCoin() throws {
        var testAsset: AssetDataModel!
        let exp = XCTestExpectation(description: "received completion")
        testDataFetcher.loadData(for: .btc) { result in
            switch result {
            case .success(let asset):
                testAsset = asset
                exp.fulfill()
            case .failure:
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5.0)
        XCTAssertNotNil(testAsset)
    }
    
    func testFetchAllCoins() throws {
        let exp = XCTestExpectation(description: "received completion")
        testSubscription = testDataFetcher.loadDataForAllCoins()
            .sink { assets in
                self.testAssets = assets
                exp.fulfill()
            }
        wait(for: [exp], timeout: 5.0)
        XCTAssertFalse(testAssets.isEmpty)
    }
    
    func testCoinsFilteringWithSearchText() throws {
        let filteredResults = testViewModel.filterAssets(with: "Bi")
        XCTAssertTrue(filteredResults.count == 2, "results success")
    }
}
