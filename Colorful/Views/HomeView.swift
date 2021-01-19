//
//  HomeView.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/01/2021.
//

import SwiftUI

struct HomeView: View {
    // MARK: Properties
    var screen = NSScreen.main!.visibleFrame
    @StateObject var homeData = HomeViewModel()
    
    var body: some View {
        HStack {
            // SideBar Buttons
            VStack(spacing: 10) {
                TabButton(image: "eyedropper.halffull", title: "Picker", selectedTab: $homeData.selectedTab)
                TabButton(image: "square.grid.3x2", title: "Palettes", selectedTab: $homeData.selectedTab)
                TabButton(image: "bubble.left.and.bubble.right", title: "Discord Roles", selectedTab: $homeData.selectedTab)
                Spacer()
                TabButton(image: "gear", title: "Settings", selectedTab: $homeData.selectedTab)
            }
            .padding()
            .padding(.top, 50)
            .background(BlurView())
            .ignoresSafeArea()
            .shadow(radius: 20)
            
            ZStack {
                // Main View
                switch homeData.selectedTab {
                case "Picker": Picker()
                case "Palettes": PalettesView()
                case "Discord Roles": DiscordRolesView()
                case "Settings": SettingsView()
                default: Text("")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: WindowSizeViewModel().minWidth, maxWidth: WindowSizeViewModel().maxWidth,
               minHeight: WindowSizeViewModel().minHeight, maxHeight: WindowSizeViewModel().maxHeight)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
