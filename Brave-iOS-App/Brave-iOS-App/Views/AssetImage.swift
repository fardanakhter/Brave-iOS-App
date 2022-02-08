//
//  AssetImage.swift
//  Brave-iOS-App
//
//  Copyright © 2022 Onseen. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct AssetImage: View {
    @ObservedObject fileprivate var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    
    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}

fileprivate class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    private static let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
    
    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        downloadImage(url: url)
    }
    
    private let cache = NSCache<NSString, NSData>()
    
    private func downloadImage(url: URL) {
        let cacheID = url.absoluteString
        
        if let cachedData = cache.object(forKey: NSString(string: cacheID)) {
            self.data = cachedData as Data
        }else{
            let task = ImageLoader.urlSession.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.data = data
                }
            }
            task.resume()
        }
    }
}
