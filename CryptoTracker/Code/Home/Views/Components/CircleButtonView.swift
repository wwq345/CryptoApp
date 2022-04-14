//
//  CircleButtonView.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/16.
//

import SwiftUI

struct CircleButtonView: View {
    
    var icon: String = " "
    
    var body: some View {
        VStack(alignment: .center){
            Image(systemName: icon)
                .font(.title2)
        }
        .frame(width: 50, height: 50)
        .background(Color.theme.background)
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 0)
        .padding()
            
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(icon: "heart.fill")
    }
}
