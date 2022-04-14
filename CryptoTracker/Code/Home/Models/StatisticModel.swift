//
//  StatisticModel.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/18.
//

import Foundation

struct StatisticModel: Identifiable{
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil){
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}


