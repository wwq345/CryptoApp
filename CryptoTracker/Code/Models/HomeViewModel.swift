//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/17.
//

import Foundation
import Combine
import CoreText

class HomeViewModel: ObservableObject{
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "Title", value: "Value", percentageChange: 33.2),
        StatisticModel(title: "Title2", value: "Value2", percentageChange: 13.2),
        StatisticModel(title: "Title3", value: "Value3", percentageChange: 34.2),
        StatisticModel(title: "Title4", value: "Value4", percentageChange: -29.2)
    ]
    
    private let coindataService = CoinDataService()
    private let marketdataSerivice = MarketDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init(){
       addSubScribers()
    }
    
    func addSubScribers(){
        
        //subscribe who
//        dataService.$allCoins
//            .sink { [weak self] (returnedCoins) in
//                self?.allCoins = returnedCoins
//            }
//            .store(in: &cancellable)
        
        $searchText
            .combineLatest(coindataService.$allCoins)
        //this will delay for 0.5 seconds before map(DispathQueue) workded
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        //transform output into some data(get value)
            .map{ (text, startingCons) -> [CoinModel] in
                guard !text.isEmpty else{
                    return startingCons
                }
                let lowerText = text.lowercased()
                let filteredCoins = startingCons.filter { (coin) -> Bool in
                    return coin.name.lowercased().contains(lowerText) ||
                    coin.symbol.lowercased().contains(lowerText) ||
                    coin.id.lowercased().contains(lowerText)
                }
                return filteredCoins
            }
        //use value
            .sink { (returnedCoins) in
                self.allCoins = returnedCoins
            }
            .store(in: &cancellable)
        
        marketdataSerivice.$marketData
            .map { (markDataModel) -> [StatisticModel] in
                var stats: [StatisticModel] = []
                
                guard let data = markDataModel else{
                    return stats
                }
                
                let marketCap = StatisticModel(title: "MarketCap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
//                stats.append(marketCap)
                
                let volume = StatisticModel(title: "24h Volumn", value: data.volume)
//                stats.append(volume)
                
                let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
                
                let portfolio = StatisticModel(title: "PortFolio", value: "$0.0", percentageChange: 0)
                
                stats.append(contentsOf: [
                    marketCap,
                    volume,
                    btcDominance,
                    portfolio
                ])
                return stats
            }
            .sink { [weak self] (returnStats) in
                self?.statistics = returnStats
            }
            .store(in: &cancellable)
    }
}
