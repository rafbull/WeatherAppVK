//
//  DailyWeather.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation

struct DailyWeather: Hashable {
    let id = UUID()
    var dailyWeatherList: [DailyWeatherList]
    
    init?(dailyWeatherData: DailyForecastData) {
        var lists = [DailyWeatherList]()
        var currentDay: String?
        for list in dailyWeatherData.list {
            guard let dailyWeatherList = DailyWeatherList(list: list) else { break }
            // Selecting only diffirent days from DailyForcastData Days array
            if currentDay != dailyWeatherList.dayString {
                lists.append(dailyWeatherList)
                currentDay = dailyWeatherList.dayString
            }
        }
        self.dailyWeatherList = lists
    }
}

struct DailyWeatherList: Hashable {
    let id = UUID()
    
    private let dayText: String
    var dayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let dayDate = dateFormatter.date(from: dayText)
        else {
            print("Can't get hours from JSON time string")
            return ""
        }

        dateFormatter.dateFormat = "E"
        let dayString = dateFormatter.string(from: dayDate)
        
        return dayString
    }
    
    private let minTemperature: Double
    var minTemperatureString: String {
        return String(format: "%.0f", minTemperature)
    }
    
    private let maxTemperature: Double
    var maxTemperatureString: String {
        return String(format: "%.0f", maxTemperature)
    }
    
    var weatherDifference: Float {
        let diffValue = maxTemperature == minTemperature ? 0.5 : 1 / (maxTemperature - minTemperature)
        return Float(diffValue)
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
    
    init?(list: List) {
        dayText = list.dtTxt
        maxTemperature = list.main.tempMax
        minTemperature = list.main.tempMin
        conditionCode = list.weather.first?.id ?? 905
    }
}
