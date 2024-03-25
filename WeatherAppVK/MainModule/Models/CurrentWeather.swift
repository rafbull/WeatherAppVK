//
//  CurrentWeather.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation

struct CurrentWeather: Hashable {
    let id = UUID()
    
    let location: String
    let latitude: Double
    let longitude: Double
    
    private let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    private let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.0f", feelsLikeTemperature)
    }
    
    let weatherDescription: String
    
    private let minTemperature: Double
    var minTemperatureString: String {
        return String(format: "%.0f", minTemperature)
    }
    
    private let maxTemperature: Double
    var maxTemperatureString: String {
        return String(format: "%.0f", maxTemperature)
    }
    
    private let windSpeed: Double
    var windSpeedString: String {
        return String(format: "%.0f", windSpeed)
    }
    
    private let conditionCode: Int
    var systemIconNameString: String {
        switch conditionCode {
        case 200...232: return AppConstants.AppWeatherIcons.cloudBoldRainFill
        case 300...321: return AppConstants.AppWeatherIcons.cloudDrizzleFill
        case 500...531: return AppConstants.AppWeatherIcons.cloudRainFill
        case 600...622: return AppConstants.AppWeatherIcons.cloudSnowFill
        case 701...781: return AppConstants.AppWeatherIcons.smokeFill
        case 800: return AppConstants.AppWeatherIcons.sunMaxFill
        case 801...904: return AppConstants.AppWeatherIcons.cloudFill
        default: return AppConstants.AppWeatherIcons.nosign
        }
    }
    
    init?(currentWeatherData: CurrentWeatherData) {
        location = currentWeatherData.name
        latitude = currentWeatherData.coord.lat
        longitude = currentWeatherData.coord.lon
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        weatherDescription = currentWeatherData.weather.first?.description ?? ""
        minTemperature = currentWeatherData.main.tempMin
        maxTemperature = currentWeatherData.main.tempMax
        windSpeed = currentWeatherData.wind.speed
        conditionCode = currentWeatherData.weather.first?.id ?? 905
    }
}
