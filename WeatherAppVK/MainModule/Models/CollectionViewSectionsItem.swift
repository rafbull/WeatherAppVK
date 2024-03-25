//
//  CollectionViewSectionsRows.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation

// MARK: - Collection Section and Collection Item
enum MainCollectionViewSection: Int {
    case currentWeather
    case hourlyWeather
    case dailyWeather
}

enum MainCollectionViewItem: Hashable {
    case currentWeather(CurrentWeather)
    case hourlyWeather(HourlyWeatherList)
    case dailyWeather(DailyWeatherList)
}
