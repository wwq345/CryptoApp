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
    @State private var showLaunchView: Bool = true
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                NavigationView{
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(hvm)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: self.$showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
