//
//  DataModels.swift
//  TestTask_CleanSwift_UIKit
//
//  Created by Владимир Костин on 13.04.2021.
//

import Foundation

// MARK: - Cell Data Model
struct CellModel {
    let cellID: Int
    let objectID: String
    let name: String
    let absoluteMagnitudeH: Double
    let isPotentiallyHazardous: Bool
    let isSentryObject: Bool
    let diameterMin: Double
    let diameterMax: Double
    let approachDate: String
    let kmPerSec: Double
    let kmPerHour: Double
    let distanceAE: Double
    let distanceKM: Double
}


// MARK: - Asteroids

struct AsteroidsData: Codable {
    let nEObjects: [String: [NearEarthObject]]
    
    enum CodingKeys: String, CodingKey {
        case nEObjects = "near_earth_objects"
    }
}

struct NearEarthObject: Codable {
    let id, name: String
    let absoluteMagnitudeH: Double
    let hazardous: Bool
    let isSentryObject: Bool
    let diam: EstimatedDiameter
    let approach: [CloseApproachDatum]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case absoluteMagnitudeH = "absolute_magnitude_h"
        case hazardous = "is_potentially_hazardous_asteroid"
        case isSentryObject = "is_sentry_object"
        case diam = "estimated_diameter"
        case approach = "close_approach_data"
    }
}
struct EstimatedDiameter: Codable {
    let meters: Feet
}

struct Feet: Codable {
    let estDiamMin, estDiamMax: Double

    enum CodingKeys: String, CodingKey {
        case estDiamMin = "estimated_diameter_min"
        case estDiamMax = "estimated_diameter_max"
    }
}

struct CloseApproachDatum: Codable {
    let closeApproachDateFull: String
    let rV: RelativeVelocity
    let missDistance: MissDistance
    
    enum CodingKeys: String, CodingKey {
        case closeApproachDateFull = "close_approach_date_full"
        case rV = "relative_velocity"
        case missDistance = "miss_distance"
    }
}

struct RelativeVelocity: Codable {
    let kmPS, kmPH: String

    enum CodingKeys: String, CodingKey {
        case kmPS = "kilometers_per_second"
        case kmPH = "kilometers_per_hour"
    }
}

struct MissDistance: Codable {
    let astronomical, kilometers: String
}
