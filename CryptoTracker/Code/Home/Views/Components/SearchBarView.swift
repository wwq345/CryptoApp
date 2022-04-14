//
//  SearchBarView.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/18.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.secondaryText)
            
            TextField("Search by name or symbol", text: $searchText)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .padding()
                        .foregroundColor(Color.theme.accent)
                        .opacity(self.searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText.removeAll()
                        }
                    , alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: .theme.accent.opacity(0.3), radius: 10, x: 0, y: 0)
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant("ss"))
    }
}
