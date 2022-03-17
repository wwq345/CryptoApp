//
//  CircleButtonAnimationView.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/16.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate: Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(self.animate ? 1 : 0)
            .opacity(self.animate ? 0 : 1)
            .animation(self.animate ? Animation.easeOut(duration: 0.5): .none, value: self.animate)
        
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
    }
}
