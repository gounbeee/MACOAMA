//
//  TextData+CoreDataProperties.swift
//  
//
//  Created by Si Young Choi on 2023/04/28.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TextData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextData> {
        return NSFetchRequest<TextData>(entityName: "TextData")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?

}

extension TextData : Identifiable {

}
