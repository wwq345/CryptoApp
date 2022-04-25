//
//  ColorSwift.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/16.
//

import Foundation
import SwiftUI

extension Color{
    static let theme: ColorTheme = ColorTheme()
    static let launch: LaunchTheme = LaunchTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}

struct LaunchTheme {
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
