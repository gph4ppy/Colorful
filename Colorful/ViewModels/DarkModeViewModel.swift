//
//  DarkModeViewModel.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 10/01/2021.
//

import SwiftUI

class DarkModeViewModel: ObservableObject {
    @Published var isDark: Bool = UserDefaults.standard.value(forKey: "DarkMode") as? Bool ?? true
}
