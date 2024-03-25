//
//  DailyForecastData.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation

struct DailyForecastData: Decodable {
    let cnt: Int
    let list: [List]
    let city: City
}

struct City: Decodable {
    let id: Int
    let name: String
}

struct List: Decodable {
    let dt: Int
    let main: MainClass
    let weather: [HourlyWeatherID]
    let dtTxt: String
}

struct MainClass: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
}

struct HourlyWeatherID: Decodable {
    let id: Int
}
