//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/17.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    private let dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init(){
       addSubScribers()
    }
    
    func addSubScribers(){
        
        dataService.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellable)
    }
}
