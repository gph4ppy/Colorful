//
//  SettingsView.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 10/01/2021.
//

import SwiftUI

struct SettingsView: View {
    // MARK: Properties
    @EnvironmentObject var darkMode: DarkModeViewModel
    
    let year = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            
            // Switch Dark Mode
            HStack {
                Text("Dark mode")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
                Toggle("", isOn: $darkMode.isDark)
                    .toggleStyle(SwitchToggleStyle())
                    .onChange(of: darkMode.isDark, perform: { _ in
                        UserDefaults.standard.setValue(darkMode.isDark, forKey: "DarkMode")
                    })
            }
            .padding()
            
            Spacer()
            
            Text("©\(year) Jakub \"GPH4PPY\" Dąbrowski").opacity(0.5)
                .padding()
        }
    }
}
