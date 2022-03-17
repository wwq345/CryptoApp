//
//  CoinImageViewModel.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/17.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject{
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private var cancellable = Set<AnyCancellable>()
    private let coin: CoinModel
    private let dataService: CoinImageService
    
    init(coin: CoinModel){
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        dataService.$image
            .sink { [weak self](_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellable)
    }
    
}
