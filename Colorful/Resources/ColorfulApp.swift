//
//  ColorfulApp.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/01/2021.
//

import SwiftUI

@main
struct ColorfulApp: App {
    // MARK: Properties
    @StateObject var darkMode = DarkModeViewModel()
    @StateObject var showAlert = HomeViewModel()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(darkMode.isDark ? .dark : .light)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(darkMode)
                .environmentObject(showAlert)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
