//
//  HourlyWeatherCellViewModel.swift
//  WeatherAppVK
//
//  Created by Rafis on 22.03.2024.
//

import Foundation
import Combine

final class HourlyWeatherCellViewModel: HourlyWeatherCellViewModelProtocol {
    let timeText = CurrentValueSubject<String, Never>("")
    let weatherIconImageName = CurrentValueSubject<String, Never>("")
    let temperatureText = CurrentValueSubject<String, Never>("")
    
    private let hourlyWeather: HourlyWeatherList
    
    init(hourlyWeather: HourlyWeatherList) {
        self.hourlyWeather = hourlyWeather
        setupPublisher()
    }
    
    private func setupPublisher() {
        timeText.send(hourlyWeather.hoursString)
        weatherIconImageName.send(hourlyWeather.systemIconNameString)
        temperatureText.send(hourlyWeather.temperatureString)
    }
}
