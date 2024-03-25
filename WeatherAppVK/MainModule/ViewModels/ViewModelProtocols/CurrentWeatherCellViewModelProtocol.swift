//
//  CurrentWeatherCellViewModelProtocol.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation
import Combine

protocol CurrentWeatherCellViewModelProtocol {
    var currentLocationText: CurrentValueSubject<String, Never> { get }
    var temperatureText: CurrentValueSubject<String, Never> { get }
    var feelsLikeTempText: CurrentValueSubject<String, Never> { get }
    var weatherIconImageName: CurrentValueSubject<String, Never> { get }
    var weatherDescriptionText: CurrentValueSubject<String, Never> { get }
    var maxTemperatureText: CurrentValueSubject<String, Never> { get }
    var minTemperatureText: CurrentValueSubject<String, Never> { get }
    var windSpeedText: CurrentValueSubject<String, Never> { get }
    
    init(currentWeather: CurrentWeather)
}
