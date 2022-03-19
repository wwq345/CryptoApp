//
//  HomeView.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/16.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var hvm: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortFolioView: Bool = false
    
    var body: some View {
        ZStack{
            Color.theme.background
            //new sheet has new environment
                .sheet(isPresented: self.$showPortFolioView, onDismiss: {}) {
                    PortfolioView()
                        .environmentObject(self.hvm)
                }
            
            
            VStack {
                headerView
                
                HomeStatsView(showPortfolio: self.$showPortfolio)
                
                SearchBarView(searchText: $hvm.searchText)
                
                columnTitleView
                
                if !showPortfolio{
                    listOfIconsView
                        .listStyle(PlainListStyle())
                        .transition(.move(edge: .leading))
                }else{
                    listOfPortfolioIconsView
                        .listStyle(PlainListStyle())
                        .transition(.move(edge: .trailing))
                }
                
                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.hvm)
        
    }
}

extension HomeView{
    private var headerView: some View{
        HStack{
            CircleButtonView(icon: self.showPortfolio ? "plus": "info")
                .animation(.none, value: self.showPortfolio)
                .onTapGesture {
                    if showPortfolio{
                        showPortFolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: self.$showPortfolio)
                )
            
            Spacer()
            
            Text(self.showPortfolio ? "Portfolio" :"Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            
            Spacer()
            
            CircleButtonView(icon: "chevron.right")
                .rotationEffect(Angle(degrees: self.showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var listOfIconsView: some View{
        List{
            ForEach(hvm.allCoins){ coin in
                CoinRowView(coin: coin, showHoldingColumn: self.$showPortfolio)
            }
        }
        .listStyle(PlainListStyle())
        .transition(.move(edge: .leading))
    }
    
    private var listOfPortfolioIconsView: some View{
        List{
            ForEach(hvm.allCoins){ coin in
                CoinRowView(coin: coin, showHoldingColumn: self.$showPortfolio)
            }
        }
        .listStyle(PlainListStyle())
        .transition(.move(edge: .leading))
    }
    
    private var columnTitleView: some View{
        HStack{
            Text("Coin")
            Spacer()
            if self.showPortfolio{
                Text("Holding")
            }
            
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}

