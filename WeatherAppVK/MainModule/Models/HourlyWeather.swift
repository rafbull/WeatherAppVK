//
//  HourlyWeather.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation

struct HourlyWeather: Hashable {
    let id = UUID()
    var hourlyWeatherList: [HourlyWeatherList]
    
    init?(hourlyWeatherData: DailyForecastData) {
        var lists = [HourlyWeatherList]()
        
        for (index, list) in hourlyWeatherData.list.enumerated() {
            // Selects only the first 8 ('AppConstants.hourlyWeatherCount') hourly data from DailyForcastData
            guard let hourlyWeatherList = HourlyWeatherList(list: list),
                  index < AppConstants.hourlyWeatherCount
            else { break }
            lists.append(hourlyWeatherList)
        }
        self.hourlyWeatherList = lists
    }
}

struct HourlyWeatherList: Hashable {
    let id = UUID()
    
    private let timeText: String
    var hoursString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let hourseDate = dateFormatter.date(from: timeText)
        else {
            print("Can't get hours from JSON time string")
            return ""
        }

        dateFormatter.dateFormat = "HH:mm"
        let hourseString = dateFormatter.string(from: hourseDate)
        
        return hourseString
    }
    
    private let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
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
        timeText = list.dtTxt
        temperature = list.main.temp
        conditionCode = list.weather.first?.id ?? 905
    }
}
