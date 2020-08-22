//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Evan Chang on 8/22/20.
//  Copyright © 2020 Evan Chang. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coord
}

struct Main: Codable {
    let temp: Double
    let temp_max: Double
    let temp_min: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
