//
//  HighScore+CoreDataProperties.swift
//  demoStuff
//
//  Created by Abby Jamieson on 12/8/18.
//  Copyright © 2018 Zachary Chucka. All rights reserved.
//
//

import Foundation
import CoreData


extension HighScore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HighScore> {
        return NSFetchRequest<HighScore>(entityName: "HighScore")
    }

    @NSManaged public var score: Int32
    @NSManaged public var position: Int16

}
