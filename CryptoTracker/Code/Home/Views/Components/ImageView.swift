//
//  ImageView.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/17.
//

import SwiftUI

struct ImageView: View {
    @StateObject var ivm: CoinImageViewModel
    
    init(coin: CoinModel){
        _ivm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack{
            if let image = ivm.image{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 80, height: 80)
            }else if ivm.isLoading{
                ProgressView()
            }else{
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(coin: dev.coin)
    }
}
