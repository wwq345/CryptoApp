//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/19.
//

import Foundation
import Combine

class MarketDataService: ObservableObject{
    @Published var marketData: MarketDataModel? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    init(){
        getData()
    }
    
    func getData(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink( receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.marketData = returnedCoins.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
