//
//  CurrentWeatherData.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation

struct CurrentWeatherData: Decodable {
    let coord: Coord
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

struct Wind: Decodable {
    let speed: Double
}
