//
//  CardView.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 09/01/2021.
//

import SwiftUI

struct CardView: View {
    // MARK: Properties
    var color: ColorModel
    let id: UUID
    let pasteboard = NSPasteboard.general
    
    var body: some View {
        HStack {
            // Color informations
            VStack(alignment: .leading, spacing: 5) {
                Text(color.hex)
                    .font(.headline)
                Text(color.rgb)
                    .font(.subheadline)
            }
            
            Spacer()
            
            // Color preview
            color.color
                .cornerRadius(4)
                .frame(width: 100, height: 30, alignment: .center)
                .shadow(color: Color.black.opacity(0.2), radius: 5)
                .padding([.top, .leading], 10)
        }
        .contextMenu {
            // Right click menu
            Button(action: {
                pasteboard.clearContents()
                pasteboard.setString(color.hex, forType: .string)
            }) {
                Text("Copy HEX Color")
            }
            Button(action: {
                pasteboard.clearContents()
                pasteboard.setString(color.rgb, forType: .string)
            }) {
                Text("Copy RGB Color")
            }
        }
        .padding()
    }
}
