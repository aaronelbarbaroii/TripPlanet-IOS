//
//  Bmi.swift
//  TripPlanet-IOS
//
//  Created by Mananas on 1/12/25.
//

import Foundation

struct Bmi: Codable {
    let id: String
    let currentDate: Int64
    let userId: String
    let weight: Int
    let height: Int
    let bmi: Double
}
