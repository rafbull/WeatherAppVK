//
//  DailyWeatherCellViewModelProtocol.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation
import Combine

protocol DailyWeatherCellViewModelProtocol {
    var dayText: CurrentValueSubject<String, Never> { get }
    var maxTemperatureText: CurrentValueSubject<String, Never> { get }
    var minTemperatureText: CurrentValueSubject<String, Never> { get }
    var weatherIconImageName: CurrentValueSubject<String, Never> { get }
    var weatherDifference: CurrentValueSubject<Float, Never> { get }
    
    init(dailyWeather: DailyWeatherList)
}
