//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/18.
//

import Foundation
import SwiftUI

extension UIApplication{
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
