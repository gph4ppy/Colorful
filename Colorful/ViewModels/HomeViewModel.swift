//
//  HomeViewModel.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/01/2021.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var selectedTab = "Picker"
    @Published var showingCustomSheet = UserDefaults.standard.value(forKey: "ShowingAlert") as? Bool ?? true
}
