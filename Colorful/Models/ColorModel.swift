//
//  ColorModel.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/01/2021.
//

import SwiftUI

struct ColorModel: Identifiable, Hashable {
    var color: Color
    var hex: String
    var rgb: String
    var hsb: String
    var id: UUID
}
