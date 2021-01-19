//
//  TabButton.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/01/2021.
//

import SwiftUI

struct TabButton: View {
    // MARK: Properties
    let image: String
    let title: String
    @Binding var selectedTab: String
    @EnvironmentObject var darkMode: DarkModeViewModel
    
    var body: some View {
        Button(action: {
            selectedTab = title
        }, label: {
            HStack(spacing: 8) {
                Image(systemName: image)
                    .font(.system(size: 15, weight: .semibold, design: .default))
                    .foregroundColor(darkMode.isDark ? (selectedTab == title ? .white : .gray) : (selectedTab == title ? .white : .black))
                
                Text(title)
                    .font(.system(size: 10, weight: .semibold, design: .default))
                    .foregroundColor(darkMode.isDark ? (selectedTab == title ? .white : .gray) : (selectedTab == title ? .white : .black))
            }
            .padding(.vertical, 10)
            .frame(width: 125)
            .background(Color.primary.opacity(0.2))
            .cornerRadius(10)
        })
        .buttonStyle(PlainButtonStyle())
    }
}

struct TabButton_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
