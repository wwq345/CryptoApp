//
//  Double.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/17.
//

import Foundation

extension Double {
    ///Convert Double into a Currency with 2decimal places
    ///```
    ///Convert 1234.56 to $1,234.56
    ///Convert 1.23456 to $1.23
    ///Convert 0.1234567 to $0.12
    ///```
    private var currencyFormatter2: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
    
    ///Convert Double into a String with 2 decimal places
    ///```
    ///Convert 1234.56 to "$1,234.56"
    ///Convert 1.23456 to "$1.23"
    ///Convert 0.1234567 to "$0.12"
    ///```
    func asCurrencyWith2Decimals() -> String{
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
   
    ///Convert Double into a Currency with 2-6 decimal places
    ///```
    ///Convert 1234.56 to $1,234.56
    ///Convert 1.23456 to $1.23456
    ///Convert 0.1234567 to $0.123456
    ///```
    private var currencyFormatter6: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 2
        return formatter
    }
    
    ///Convert Double into a String with 2-6 decimal places
    ///```
    ///Convert 1234.56 to "$1,234.56"
    ///Convert 1.23456 to "$1.23456"
    ///Convert 0.1234567 to "$0.123456"
    ///```
    func asCurrencyWith6Decimals() -> String{
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    ///Convert Double into a String representation
    ///```
    ///Convert 1234.56 to "1234.56"
    ///Convert 1.23456 to "1.23456"
    ///Convert 0.1234567 to "0.123456"
    ///```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    func asPercentString() -> String{
        return asNumberString() + "%"
    }
    
    func formattedWithAbbreviations() -> String{
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        switch num{
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0:
            return self.asNumberString()
            
        default:
            return "\(sign)\(self)"
        }
    }
}
