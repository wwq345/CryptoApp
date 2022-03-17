//
//  ImageService.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/17.
//

import Foundation
import UIKit
import Combine

class CoinImageService{
    
    @Published var image: UIImage? = nil
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    var imageSubscripiton: AnyCancellable?
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: self.folderName){
            image = savedImage
//            print("Retrieved image from File Manager")
        }else{
            downloadCoinImage()
//            print("Downloading image now")
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscripiton = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink( receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadImage = returnedImage else { return }
                self.image = returnedImage
                self.imageSubscripiton?.cancel()
                self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
