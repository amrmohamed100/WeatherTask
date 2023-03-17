//
//  Coordinate.swift
//  WeatherTask
//
//  Created by Amr Mohamed on 16/03/2023.
//

import Foundation

struct Coordinate: Codable {
    let lon, lat: Double
    
    static func emptyInit() -> Coordinate {
        return Coordinate(lon: 0, lat: 0)
    }
}
