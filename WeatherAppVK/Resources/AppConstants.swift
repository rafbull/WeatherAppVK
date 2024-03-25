//
//  AppConstants.swift
//  WeatherAppVK
//
//  Created by Rafis on 23.03.2024.
//

import Foundation

struct AppConstants {
    static let hourlyWeatherCount = 8
    
    static let noInternetAlertTitle = "Current Weather Unavailiable"
    static let noInternetAlertMessage = "The WeatherAppVK app isn't connected to the internet.\nRecently saved weather, if available, will be shown."
    static let noInternetActionTitle = "Ok"
    
    enum AppWeatherIcons {
        static let cloudBoldRainFill = "cloud.bolt.rain.fill"
        static let cloudDrizzleFill = "cloud.drizzle.fill"
        static let cloudRainFill = "cloud.rain.fill"
        static let cloudSnowFill = "cloud.snow.fill"
        static let smokeFill = "smoke.fill"
        static let sunMaxFill = "sun.max.fill"
        static let cloudFill = "cloud.fill"
        static let nosign = "nosign"
    }
}
