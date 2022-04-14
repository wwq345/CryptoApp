//
//  MarkDataModel.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/19.
//

import Foundation

struct GlobalData: Codable{
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
//    let activeCryptocurrencies, upcomingIcons, ongoingIcons, endIcons: Int?
//    let markets: Int?
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
//    let updatedAt: Int?
    
    //做列映射
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
//            return "\(item.value)"
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
//    var marketCao: String{
//        if let item = totalMarketCap.first(where: { (key, value) -> Bool in
//            return key == "usd"
//        }){
//            return "\(item.value)"
//        }
//        return ""
//    }
    
    
//    var volume: String{
//        if let item = totalVolume.first(where: { $0.key == "usd"}){
//            return "\(item.value)"
//        }
//        return ""
//    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }

    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
    
}
