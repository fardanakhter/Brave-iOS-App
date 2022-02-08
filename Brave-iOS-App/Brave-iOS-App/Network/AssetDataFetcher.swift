//
//  AssetData.swift
//  Brave-iOS-App
//
//  Copyright © 2022 Onseen. All rights reserved.
//
import Foundation
import Combine

typealias Completion<T: AssetDataModelProtocol> = (Result<T, Network.NetworkError>) -> Void

protocol AssetDataFetchable {
    associatedtype T: AssetDataModelProtocol
    func loadData(for coin: Coins, completion: @escaping Completion<T>)
    func loadDataForAllCoins() -> Future<[T], Never>
    func parse(data: Data) throws -> T
}

protocol AssetDataModelProtocol: Decodable {}

// Refer to https://api.coingecko.com/api/v3/coins/list for coin ids
enum Coins: CaseIterable {
    case btc
    case eth
    case bnb
    case bat
    case usdt
    case tata
    case doge
    
    var id: String {
        switch self {
        case .btc: return "bitcoin"
        case .eth: return "ethereum"
        case .bnb: return "binancecoin"
        case .bat: return "basic-attention-token"
        case .usdt: return "tether"
        case .tata: return "tata-coin"
        case .doge: return "dogecoin"
        }
    }
}

struct AssetDataFetcher: AssetDataFetchable {
    
    typealias T = AssetDataModel
    
    private let network = Network()
    private let dataDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func loadData(for coin: Coins, completion: @escaping Completion<AssetDataModel>) {
        do {
            let request = try network.urlRequest(withMethod: .get, path: "/coins/\(coin.id)", timeout: AppConfig.Network.networkTimeout)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    return completion(.failure(.network))
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return completion(.failure(.network))
                }
                guard let data = data else {
                    return completion(.failure(.dataNotFound))
                }
                do {
                    let asset = try parse(data: data)
                    completion(.success(asset))
                } catch {
                    completion(.failure(error as? Network.NetworkError ?? .network))
                }
            }
            .resume()
        }
        catch {
            completion(.failure(error as? Network.NetworkError ?? .network))
        }
    }

    func loadDataForAllCoins() -> Future<[AssetDataModel], Never> {
        return Future(){ promise in
            var assets = [AssetDataModel]()
            
            let group = DispatchGroup()
            Coins.allCases.forEach{ coin in
                group.enter()
                loadData(for: coin) { result in
                    switch result {
                    case .success(let asset):
                        assets.append(asset)
                        group.leave()
                    case .failure(let error):
                        print(error)
                        group.leave()
                    }
                }
            }
            group.wait()
            group.notify(queue: .main) {
                promise(.success(assets))
            }
        }
    }

    func parse(data: Data) throws -> AssetDataModel {
        do {
            let asset = try dataDecoder.decode(AssetDataModel.self, from: data)
            return asset
        } catch {
            throw Network.NetworkError.decoding
        }
    }
}

