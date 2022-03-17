//
//  CoinRowView.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/17.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    @Binding var showHoldingColumn: Bool
    
    var body: some View {
        HStack {
            leftColumn
            Spacer()
            
            if self.showHoldingColumn{
                mediumColumn
            }
            
            rightColumn
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHoldingColumn: .constant(true))
    }
}

extension CoinRowView{
    private var leftColumn: some View{
        HStack{
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            ImageView(coin: self.coin)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var mediumColumn: some View{
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColumn: some View{
        VStack{
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "0.0%")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red
                )
        }
    }
}
