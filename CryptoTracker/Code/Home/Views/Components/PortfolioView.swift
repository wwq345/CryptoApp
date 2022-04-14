//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/19.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var hvm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 20){
                    SearchBarView(searchText: self.$hvm.searchText)
                    
                    coinLogoListView
                    
                    if selectedCoin != nil{
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    HStack{
                        Image(systemName: self.showCheckmark ? "checkmark" : "")
                        
                        Button {
                            saveButtonPressed()
                        } label: {
                            Text("SAVE")
                        }
                        .opacity(
                            (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
                        )
                    }
                }
            }
            .onChange(of: hvm.searchText) { newValue in
                if newValue == ""{
                    removeSelectedCoin()
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PortfolioView()
                .environmentObject(dev.hvm)
        }
    }
}

extension PortfolioView{
    private var coinLogoListView: some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing: 30){
                ForEach(hvm.searchText == "" ? hvm.portfolioCoins : hvm.allCoins){item in
                    CoinLogoView(coin: item)
                        .onTapGesture {
                            withAnimation(.easeIn){
                                selectedCoin = item
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == item.id ? Color.theme.green : Color.clear, lineWidth: 2)
                        )
                }
            }
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel){
        selectedCoin = coin
        
        if let portfolioCoin = hvm.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        }else{
            quantityText = ""
        }
        
    }
    
    private func getCurrentValue() -> Double{
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portfolioInputSection: some View{
        VStack(alignment: .leading) {
            HStack(spacing: 20){
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            .padding()
            Divider()
            
            HStack{
                Text("Amount in your portfolio")
                
                TextField("Ex: 1.4", text: $quantityText)
//                                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            .padding()
            
            Divider()
            
            HStack{
                Text("Current Value")

                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
            .padding()
        }
    }
    
    private func saveButtonPressed(){
        guard let coin = selectedCoin,
              let amount = Double(quantityText)
        else { return }
        
        hvm.updatePortfolio(coin: coin, amount: amount)
        
        
        withAnimation(.easeIn){
            showCheckmark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut){
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        hvm.searchText = ""
    }
}
