//
//  StringExtension.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/4/14.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
