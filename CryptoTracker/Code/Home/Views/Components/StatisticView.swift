//
//  StatisticView.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/18.
//

import SwiftUI

struct StatisticView: View {
    let stat: StatisticModel
    var body: some View {
        VStack(alignment: .leading){
            Text(self.stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(self.stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            
            HStack {
                
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (self.stat.percentageChange ?? 0 >= 0) ? 0 : 180))
                
                
                Text(self.stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((self.stat.percentageChange ?? 0 >= 0) ? .theme.green : .theme.red)
            .opacity((self.stat.percentageChange == nil) ? 0 : 1)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(stat: dev.statvm3)
    }
}
