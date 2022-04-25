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
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    @State private var showSetting: Bool = false
    
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
                    ZStack(alignment: .top) {
                        if hvm.portfolioCoins.isEmpty && hvm.searchText.isEmpty {
                            portfolioEmptyView
                        } else {
                            listOfPortfolioIconsView
                                .listStyle(PlainListStyle())
                                .transition(.move(edge: .trailing))
                        }
                    }
                }
                
                Spacer()
            }
            .sheet(isPresented: $showSetting) {
                SettingsView()
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() }
            )
        )
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
                    } else {
                        showSetting.toggle()
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
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
        .transition(.move(edge: .leading))
    }
    
    private var listOfPortfolioIconsView: some View{
        List{
            ForEach(hvm.portfolioCoins){ coin in
                CoinRowView(coin: coin, showHoldingColumn: self.$showPortfolio)
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
        .transition(.move(edge: .leading))
    }
    
    private var portfolioEmptyView: some View {
        Text("You haven't added any coins. Please click + button to get started")
            .font(.callout)
            .foregroundColor(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    private func segue(coin: CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columnTitleView: some View{
        HStack{
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((hvm.sortOption == .rank || hvm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: hvm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                hvm.sortOption = (hvm.sortOption == .rank ? .rankReversed : .rank)
            }
            
            Spacer()
            if self.showPortfolio{
                HStack {
                    Text("Holding")
                    Image(systemName: "chevron.down")
                        .opacity((hvm.sortOption == .holdings || hvm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: hvm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    hvm.sortOption = (hvm.sortOption == .holdings ? .holdingsReversed : .holdings)
                }
            }
            
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((hvm.sortOption == .price || hvm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: hvm.sortOption == .price ? 0 : 180))
                
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                hvm.sortOption = (hvm.sortOption == .price ? .priceReversed : .price)
            }
            
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    hvm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: hvm.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}

