//
//  HourlyWeatherCellViewModelProtocol.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation
import Combine

protocol HourlyWeatherCellViewModelProtocol {
    var timeText: CurrentValueSubject<String, Never> { get }
    var weatherIconImageName: CurrentValueSubject<String, Never> { get }
    var temperatureText: CurrentValueSubject<String, Never> { get }
    
    init(hourlyWeather: HourlyWeatherList)
}
