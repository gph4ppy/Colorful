//
//  PalettesView.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 12/01/2021.
//

import SwiftUI

struct PalettesView: View {
    // MARK: Properties
    let pasteboard = NSPasteboard.general
    
    // Colors
    @State private var selectedColor: Color = Color.white
    @State private var colors: [Color] = [.black, .black, .black, .black, .black, .black, .black, .black]
    @State private var saved: [Bool] = [false, false, false, false, false, false, false, false]
    @State private var hexes: [String] = ["", "", "", "", "", "", "", ""]
    @State private var currentIndex: Int = 0
    @State var nsColorsArr: [NSColor] = [.black, .black, .black, .black, .black, .black, .black, .black]
    
    var hexColor: String {
        return "#\(selectedColor.nsColor().toHexString()!)"
    }
    
    // Backend
    @EnvironmentObject var darkMode: DarkModeViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: ColorPalettes.entity(), sortDescriptors: [])
    var palettes: FetchedResults<ColorPalettes>
    
    var body: some View {
        let newPalette = PaletteModel(colors: nsColorsArr, hexes: hexes)
        VStack {
            HStack {
                // Clear Button
                Button(action: reset, label: {
                    Text("Clear palette")
                        .font(.title3)
                    Image(systemName: "minus.circle.fill")
                })
                .foregroundColor(darkMode.isDark ? .white : .black)
                .padding(2)
                .background(darkMode.isDark ? Color.red : Color.white)
                .addBorder(Color.black.opacity(0.5), cornerRadius: 5)
                
                Text("Color Palettes")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding()
                
                // Save Button
                Button(action: {
                    savePalette(newPalette)
                    reset()
                }, label: {
                    Text("Save palette")
                        .font(.title3)
                    Image(systemName: "plus.circle.fill")
                })
                .foregroundColor(darkMode.isDark ? .white : .black)
                .padding(2)
                .background(darkMode.isDark ? Color.green : Color.white)
                .addBorder(Color.black.opacity(0.5), cornerRadius: 5)
            }
            
            // Palette Preview
            VStack {
                HStack(spacing: 3) {
                    ForEach(colors.indices) { index in
                        VStack {
                            colors[index]
                                .frame(width: 75, height: 100)
                                .addBorder(Color.white, width: 2, cornerRadius: 10)
                            Text(currentIndex == index ? hexColor : (saved[index] ? hexes[index] : ""))
                        }
                    }
                }
                .padding(5)
                
                // Color Selection
                HStack(spacing: 10) {
                    Spacer()
                    ColorPicker("", selection: $selectedColor)
                    Button(action: {
                        // Add Color to palette
                        colors[currentIndex] = selectedColor
                        saved[currentIndex] = true
                        hexes[currentIndex] = hexColor
                        
                        nsColorsArr[currentIndex] = colors[currentIndex].nsColor()
                        
                        if currentIndex < 8 {
                            if currentIndex != 7 {
                                currentIndex += 1
                            }
                        }
                    }, label: {
                        Text("Add color to the palette")
                            .font(.title3)
                    })
                    .foregroundColor(darkMode.isDark ? .white : .black)
                    .padding(2)
                    .background(darkMode.isDark ? Color.gray : Color.white)
                    .addBorder(Color.black.opacity(0.5), cornerRadius: 5)
                    .padding(.horizontal, 8)
                    Spacer()
                }
                .padding()
                
                // Palettes Card Views
                List {
                    ForEach(palettes) { palette in
                        let paletteModel = PaletteModel(colors: nsColorsArr, hexes: palette.hexes)
                        HStack {
                            Button(action: {
                                delete(at: palettes.firstIndex(where: { $0.id == palette.id }) ?? 0)
                            }){
                                Image(systemName: "minus.circle.fill")
                            }.foregroundColor(Color(NSColor.systemRed))
                            .padding()
                            PalettesCardView(palette: paletteModel, id: UUID())
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewContext.delete(palettes[index])
                        }
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .id(UUID())
                // Hide List Indicator
                .onNSView(added: { nsview in
                    let root = nsview.subviews[0] as! NSScrollView
                    root.hasVerticalScroller = false
                    root.hasHorizontalScroller = false
                })
            }
        }
    }
    
    /// This function adds selected palette and saves it by using Core Data.
    /// - Parameter palette: Palette Model, which includes hex value.
    func savePalette(_ palette: PaletteModel) {
        let savedPalette = ColorPalettes(context: viewContext)
        savedPalette.hexes = palette.hexes
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// This function removes the selected palette.
    /// - Parameter index: A selected position, which is about to be removed.
    func delete(at index: Int) {
        viewContext.delete(palettes[index])
        
        DispatchQueue.main.async {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func reset() {
        selectedColor = Color.white
        colors = [.black, .black, .black, .black, .black, .black, .black, .black,]
        saved = [false, false, false, false, false, false, false, false]
        hexes = ["", "", "", "", "", "", "", ""]
        currentIndex = 0
    }
}
