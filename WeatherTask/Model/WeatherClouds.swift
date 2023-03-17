//
//  WeatherClouds.swift
//  WeatherTask
//
//  Created by Amr Mohamed on 16/03/2023.
//

import Foundation

struct WeatherClouds: Codable {
    let all: Int

    static func emptyInit() -> WeatherClouds {
        return WeatherClouds(all: 0)
    }
}
