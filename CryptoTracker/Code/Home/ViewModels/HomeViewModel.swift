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
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "Title", value: "Value", percentageChange: 33.2),
        StatisticModel(title: "Title2", value: "Value2", percentageChange: 13.2),
        StatisticModel(title: "Title3", value: "Value3", percentageChange: 34.2),
        StatisticModel(title: "Title4", value: "Value4", percentageChange: -29.2)
    ]
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataSerivice = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellable = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
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
            .combineLatest(coinDataService.$allCoins, $sortOption)
        //this will delay for 0.5 seconds before map(DispathQueue) workded
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        //transform output into some data(get value)
            .map{ (text, startingCoins, sort) -> [CoinModel] in
                guard !text.isEmpty else{
                    return startingCoins
                }
                let lowerText = text.lowercased()
                let filteredCoins = startingCoins.filter { (coin) -> Bool in
                    return coin.name.lowercased().contains(lowerText) ||
                    coin.symbol.lowercased().contains(lowerText) ||
                    coin.id.lowercased().contains(lowerText)
                }
//                let returnedCoins = self.sortCoins(sort: sort, coins: filteredCoins)
                return filteredCoins
            }
        //use value
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.allCoins = self.sortCoins(coins: returnedCoins)
            }
            .store(in: &cancellable)
        
        $allCoins
            .combineLatest(portfolioDataService.$saveEntity)
            .map{ (coinModel, portfolioEntity) -> [CoinModel] in
                coinModel
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntity.first(where: { $0.coinID == coin.id}) else{
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnCoins)
            }
            .store(in: &cancellable)
        
        marketDataSerivice.$marketData
            .combineLatest($portfolioCoins)
            .map({ (marketDataModel, portfolioCoins) -> [StatisticModel] in
                var stats: [StatisticModel] = []
                
                guard let data = marketDataModel else{
                    return stats
                }
                
                let marketCap = StatisticModel(title: "MarketCap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                    
                let volume = StatisticModel(title: "24h Volumn", value: data.volume)
                
                let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
                
                let portfolioValue = portfolioCoins.map { (coin) -> Double in
                    return coin.currentHoldingsValue
                }
                    .reduce(0, +)
                
                let previousValue = portfolioCoins.map { (coin) ->Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                    let previousValue = currentValue / (1 + percentChange)
                    return previousValue
                }
                    .reduce(0, +)
                
                let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
                
                let portfolio = StatisticModel(title: "PortFolio", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
                
                stats.append(contentsOf: [
                    marketCap,
                    volume,
                    btcDominance,
                    portfolio
                ])
                return stats
            })
            .sink { [weak self] (returnStats) in
                self?.statistics = returnStats
                self?.isLoading = false
            }
            .store(in: &cancellable)
        
       
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(amount: amount, coin: coin)
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataSerivice.getData()
        HapticManager.notification(type: .success)
    }
    
    private func sortCoins(coins:  [CoinModel]) -> [CoinModel]{
        switch sortOption {
        case .rank, .holdings:
            return coins.sorted(by: { $0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
            return coins.sorted(by: { $0.rank > $1.rank })
        case .price:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice })
        case .priceReversed:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        //will only sort by holdings or reverseHoldings if needs
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
}
