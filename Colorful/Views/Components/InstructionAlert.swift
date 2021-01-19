//
//  InstructionAlert.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 14/01/2021.
//

import SwiftUI

struct InstructionAlert: View {
    // MARK: Properties
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        ZStack {
            // Alert Window
            Rectangle()
                .fill(Color(NSColor(hex: "#212326")!))
                .frame(width: 512, height: 350)
                .transition(.move(edge: .bottom))
                .overlay(
                    // Carousel
                    GeometryReader { geometry in
                        CarouselView(numberOfViews: 4) {
                            // 1 - Welcome
                            VStack(spacing: 10) {
                                Text("Welcome in Colorful!")
                                    .font(.largeTitle)
                                    .padding(.top)
                                
                                Text("""
                                    Colorful is a tool thanks to which you will always have your favorite colors at hand.
                                    """)
                                    .font(.caption)
                                
                                Image("DarkModePicker")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            
                            // 2 - Dark Mode
                            VStack(spacing: 10) {
                                Text("Dark Mode")
                                    .font(.largeTitle)
                                    .padding(.top)
                                
                                Text("""
                                        Bored with the current appearance? We have something for you!
                                        Go to the settings tab and switch dark mode. We respect people who prefer bright mode.
                                        Dark Mode will be turned on when you close this window.
                                        The default mode is dark.
                                        """)
                                    .font(.caption)
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.center)
                                
                                Image("LightModePicker")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .offset(x: -5)
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            
                            // 3 - Copy Informations
                            VStack(spacing: 10) {
                                Text("Copy Values")
                                    .font(.largeTitle)
                                    .padding(.top)
                                
                                Text("""
                                        Need to quickly copy color data? With the Colorful app, you can do it with two clicks!
                                        Right-click in the area of the information you want to copy and select an option from the menu.
                                        """)
                                    .font(.caption)
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.center)
                                
                                Image("CopyColor")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .offset(x: -11)
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            
                            // 4 - That's all
                            VStack(spacing: 10) {
                                Text("Let's go!")
                                    .font(.largeTitle)
                                    .padding(.top)
                                
                                // Multiline String not working here. Inserting Text() instead.
                                VStack {
                                    Text("Do you already know everything about Colorful?")
                                    Text("- If your answer is \"yes\", click the button below to disable this window.")
                                    Text("You won't see it again.")
                                    Text("- If your answer is \"no\", wait 6 seconds.")
                                    Text("The slides advance every 6 seconds.")
                                    Text("Read everything carefully again and click the button when you're ready.")
                                }
                                .font(.caption)
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.center)
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        homeVM.showingCustomSheet = false
                                        UserDefaults.standard.setValue(homeVM.showingCustomSheet, forKey: "ShowingAlert")
                                    }, label: {
                                        Text("Close this window - I don't want to see it anymore at startup.")
                                    })
                                    Spacer()
                                }
                            }
                            .offset(x: -12)
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                        }
                    }
                )
        }
    }
}
