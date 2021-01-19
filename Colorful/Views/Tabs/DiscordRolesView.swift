//
//  DiscordRolesView.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 13/01/2021.
//

import SwiftUI

struct DiscordRolesView: View {
    // MARK: Properties
    let pasteboard = NSPasteboard.general
    @ObservedObject var roleName = TextLimiter(limit: 24)
    @ObservedObject var username = TextLimiter(limit: 32)
    @ObservedObject var message = TextLimiter(limit: 100)
    @State private var selectedColor = Color.white
    
    var hexColor: String {
        return "#\(selectedColor.nsColor().toHexString()!)"
    }
    
    var body: some View {
        VStack {
            Text("Discord Roles")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            
            // TextFields
            VStack(spacing: 10) {
                TextField("Role name", text: $roleName.value)
                TextField("Username", text: $username.value)
                TextField("Message", text: $message.value)
            }
            .padding(.horizontal)
            
            HStack {
                HStack {
                    // Selected Color
                    selectedColor
                        .frame(width: 50, height: 50, alignment: .leading)
                        .addBorder(Color.white, width: 2, cornerRadius: 10)
                        .padding()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Selected Color: ")
                                .font(.title3)
                            ColorPicker("", selection: $selectedColor)
                        }
                        Text("HEX Value: \(hexColor)")
                            .font(.title3)
                    }
                    Spacer()
                }
                .contextMenu {
                    // Right Click Menu
                    Button(action: {
                        pasteboard.clearContents()
                        pasteboard.setString(hexColor, forType: .string)
                    }) {
                        Text("Copy HEX Value")
                    }
                }
                
                // Discord Roles Tab
                VStack(spacing: 5) {
                    Text("Roles Tab")
                        .font(.caption)
                    Text(roleName.value)
                        .padding()
                        .frame(width: 175, height: 25, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                        .foregroundColor(selectedColor)
                }
                VStack(spacing: 5) {
                    Text("Selected Tab")
                        .font(.caption)
                    Text(roleName.value)
                        .padding()
                        .frame(width: 175, height: 25, alignment: .center)
                        .background(selectedColor)
                        .cornerRadius(5)
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            // Message
            Text("Message example")
                .font(.caption)
            HStack {
                // Image
                Image(systemName: "person.circle")
                    .font(.system(size: 25, weight: .medium, design: .default))
                VStack(alignment: .leading, spacing: 3) {
                    Text(username.value)
                        .font(.headline)
                        .foregroundColor(selectedColor)
                    Text(message.value)
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .frame(minWidth: 125, idealWidth: 250, maxWidth: .infinity, minHeight: 30, idealHeight: 40, maxHeight: 50, alignment: .center)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(5, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding(.horizontal)
        }
    }
}

struct DiscordRolesView_Previews: PreviewProvider {
    static var previews: some View {
        DiscordRolesView()
    }
}
