//
//  CurrentWeatherSys.swift
//  WeatherTask
//
//  Created by Amr Mohamed on 16/03/2023.
//

import Foundation

struct CurrentWeatherSys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
    
    static func emptyInit() -> CurrentWeatherSys {
        return CurrentWeatherSys(
            type: 0,
            id: 0,
            country: "",
            sunrise: 0,
            sunset: 0
        )
    }
}
