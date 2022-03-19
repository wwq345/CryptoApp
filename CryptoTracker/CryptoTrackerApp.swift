//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/16.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    
    @StateObject var hvm = HomeViewModel()
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            
            .environmentObject(hvm)
        }
    }
}
