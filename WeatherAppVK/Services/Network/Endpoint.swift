//
//  Endpoint.swift
//  WeatherAppVK
//
//  Created by Rafis on 23.03.2024.
//

import Foundation
import CoreLocation

enum Endpoint {
    case currentWeatherCityName(city: String)
    case currentWeatherCoordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    case dailyForecastCityName(city: String)
    case dailyForecastCoordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    
    func absoluteURL() -> String {
        baseURL + path()
    }
    
    private var baseURL: String {
        "https://api.openweathermap.org/data/2.5/"
    }
    
    private func path() -> String {
        switch self {
        case .currentWeatherCityName(let city):
            return "weather?q=\(city)&apikey=\(APIConstants.apiKey)&units=metric"
        case .currentWeatherCoordinate(let latitude, let longitude):
            return "weather?lat=\(latitude)&lon=\(longitude)&apikey=\(APIConstants.apiKey)&units=metric"
        case .dailyForecastCityName(city: let city):
            return "forecast?q=\(city)&apikey=\(APIConstants.apiKey)&units=metric"
        case .dailyForecastCoordinate(latitude: let latitude, longitude: let longitude):
            return "forecast?lat=\(latitude)&lon=\(longitude)&apikey=\(APIConstants.apiKey)&units=metric"
        }
    }
}
