//
//  ContentView.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/01/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        HomeView()
            .sheet(isPresented: $homeVM.showingCustomSheet, content: {
                InstructionAlert()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
