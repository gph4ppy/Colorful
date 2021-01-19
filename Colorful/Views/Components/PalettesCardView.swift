//
//  PalettesCardView.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 17/01/2021.
//

import SwiftUI

struct PalettesCardView: View {
    // MARK: Properties
    @State var palette: PaletteModel
    let id: UUID
    let pasteboard = NSPasteboard.general
    
    var body: some View {
        HStack {
            Spacer()
            // Saved Colors
            ForEach(palette.colors.indices, id: \.self) { index in
                VStack(alignment: .center) {
                    Color(NSColor(hex: palette.hexes[index]) ?? NSColor(hex: "#000000")!)
                        .cornerRadius(4)
                        .frame(width: 40, height: 30, alignment: .center)
                        .shadow(color: Color.black.opacity(0.2), radius: 5)
                        .padding([.top, .leading], 10)
                    Text(palette.hexes[index])
                        .font(.system(size: 8))
                }
            }
            Spacer()
        }
        .contextMenu {
            // Right click menu
            ForEach(palette.hexes.indices) { index in
                Button(action: {
                    pasteboard.clearContents()
                    pasteboard.setString(palette.hexes[index], forType: .string)
                }) {
                    Text("Copy #\(index + 1) HEX value")
                }
            }
            
            Button(action: {
                pasteboard.clearContents()
                pasteboard.setString("\(palette.hexes)", forType: .string)
            }) {
                Text("Copy all values")
            }
        }
        .padding()
    }
}
