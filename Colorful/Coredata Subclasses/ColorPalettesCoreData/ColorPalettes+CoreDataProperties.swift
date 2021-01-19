//
//  ColorPalettes+CoreDataProperties.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 17/01/2021.
//
//

import Foundation
import CoreData


extension ColorPalettes {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorPalettes> {
        return NSFetchRequest<ColorPalettes>(entityName: "ColorPalettes")
    }

    @NSManaged public var hexes: [String]
}

extension ColorPalettes : Identifiable {
}
