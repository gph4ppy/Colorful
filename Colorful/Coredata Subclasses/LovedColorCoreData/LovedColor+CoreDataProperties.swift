//
//  LovedColor+CoreDataProperties.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 15/01/2021.
//
//

import Foundation
import CoreData


extension LovedColor {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LovedColor> {
        return NSFetchRequest<LovedColor>(entityName: "LovedColor")
    }

    @NSManaged public var hex: String
    @NSManaged public var hsb: String
    @NSManaged public var id: UUID
    @NSManaged public var rgb: String
}

extension LovedColor : Identifiable {

}
