//
//  ResponseError.swift
//  WeatherTask
//
//  Created by Amr Mohamed on 16/03/2023.
//

import Foundation

enum ResponseError: Error {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidURL
}
