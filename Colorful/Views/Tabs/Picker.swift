//
//  Picker.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/01/2021.
//

import SwiftUI

struct Picker: View {
    // MARK: Properties
    let pasteboard = NSPasteboard.general
    
    // Colors
    @State var selectedColor = Color.white
    var hexColor: String { return "#\(selectedColor.nsColor().toHexString()!)" }
    
    var rgbColor: String {
        let r = round(selectedColor.nsColor().redComponent * 255.0)
        let g = round(selectedColor.nsColor().greenComponent * 255.0)
        let b = round(selectedColor.nsColor().blueComponent * 255.0)
        let a = String(format: "%.2f", selectedColor.nsColor().alphaComponent)
        
        return "(R: \(r), G: \(g), B: \(b), A: \(a))"
    }
    
    var hsbColor: String {
        let color = selectedColor.nsColor().hsbColor
        var h = Int(round(color.hue * 360))
        let s = Int(round(color.saturation * 100))
        let b = Int(round(color.brightness * 100))
        let a = Int(round(color.alpha * 100))
        
        if h == 360 {
            h = 0
        }
        
        return "(H: \(h)°, S: \(s)%, B: \(b)%, A: \(a)%)"
    }
    
    // Backend
    @EnvironmentObject var darkMode: DarkModeViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: LovedColor.entity(), sortDescriptors: [])
    var colors: FetchedResults<LovedColor>
    
    
    var body: some View {
        let lovedColor = ColorModel(color: selectedColor, hex: hexColor, rgb: rgbColor, hsb: hsbColor, id: UUID())
        
        VStack {
            Text("Color Picker")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            HStack {
                // Selected Color
                selectedColor
                    .frame(width: 100, height: 100, alignment: .leading)
                    .addBorder(Color.white, width: 3, cornerRadius: 30)
                    .padding()
                VStack(alignment: .leading) {
                    HStack {
                        Text("Selected Color: ")
                            .font(.title3)
                        ColorPicker("", selection: $selectedColor)
                        Button(action: {
                            addLovedColor(lovedColor)
                        }, label: {
                            Text("Love")
                                .font(.title3)
                            Image(systemName: "heart.fill")
                        })
                        .foregroundColor(darkMode.isDark ? .white : .black)
                        .padding(2)
                        .background(darkMode.isDark ? Color.red : Color.white)
                        .addBorder(Color.black.opacity(0.5), cornerRadius: 5)
                        .padding(.horizontal, 8)
                    }
                    // Color Values
                    VStack(alignment: .leading, spacing: 3) {
                        Text("HEX Value: \(hexColor)")
                        Text("RGB Value: \(rgbColor)")
                        Text("HSB Value: \(hsbColor)")
                    }
                }
                Spacer()
            }
            .contextMenu {
                // Right click menu
                Button(action: {
                    pasteboard.clearContents()
                    pasteboard.setString(hexColor, forType: .string)
                }) {
                    Text("Copy HEX Color")
                }
                Button(action: {
                    pasteboard.clearContents()
                    pasteboard.setString(rgbColor, forType: .string)
                }) {
                    Text("Copy RGB Color")
                }
                Button(action: {
                    pasteboard.clearContents()
                    pasteboard.setString(hsbColor, forType: .string)
                }) {
                    Text("Copy HSB Color")
                }
            }
            .padding(.horizontal, 50)
            
            // Loved Colors
            VStack {
                Text("Loved Colors")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding()
                
                // Color Card Views
                List {
                    ForEach(colors) { color in
                        let colorModel = ColorModel(color: Color(NSColor(hex: color.hex)!), hex: color.hex, rgb: color.rgb, hsb: color.hsb, id: color.id)
                        HStack {
                            Button(action: { delete(at: colors.firstIndex(where: { $0.id == color.id }) ?? 0)
                            }){
                                Image(systemName: "minus.circle.fill")
                            }.foregroundColor(Color(NSColor.systemRed))
                            .padding()
                            CardView(color: colorModel, id: UUID())
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewContext.delete(colors[index])
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
    
    /// This function adds selected color to loved section and saves it by using Core Data.
    /// - Parameter color: Color Model, which includes hex value, rgb value and ID.
    func addLovedColor(_ color: ColorModel) {
        let lovedColor = LovedColor(context: viewContext)
        lovedColor.hex = color.hex
        lovedColor.rgb = color.rgb
        lovedColor.id = color.id
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// This function removes the selected loved color.
    /// - Parameter index: A selected position, which is about to be removed.
    func delete(at index: Int) {
        viewContext.delete(colors[index])
        
        DispatchQueue.main.async {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct Picker_Previews: PreviewProvider {
    static var previews: some View {
        Picker().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
