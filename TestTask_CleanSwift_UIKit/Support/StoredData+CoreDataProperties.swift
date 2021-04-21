//
//  StoredData+CoreDataProperties.swift
//  TestTask_CleanSwift_UIKit
//
//  Created by Владимир Костин on 14.04.2021.
//
//

import Foundation
import CoreData


extension StoredData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredData> {
        return NSFetchRequest<StoredData>(entityName: "StoredData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var objectId: String?
    @NSManaged public var name: String?
    @NSManaged public var magnitude: Double
    @NSManaged public var hazard: Bool
    @NSManaged public var sentry: Bool
    @NSManaged public var diamMin: Double
    @NSManaged public var diamMax: Double
    @NSManaged public var approach: String?
    @NSManaged public var kmPerSec: Double
    @NSManaged public var kmPerHour: Double
    @NSManaged public var distancKM: Double
    @NSManaged public var distanceAE: Double

}

extension StoredData : Identifiable {

}
