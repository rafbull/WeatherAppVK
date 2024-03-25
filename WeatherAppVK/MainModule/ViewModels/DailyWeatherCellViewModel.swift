//
//  DailyWeatherCellViewModel.swift
//  WeatherAppVK
//
//  Created by Rafis on 22.03.2024.
//

import Foundation
import Combine

final class DailyWeatherCellViewModel: DailyWeatherCellViewModelProtocol {
    let dayText = CurrentValueSubject<String, Never>("")
    let maxTemperatureText = CurrentValueSubject<String, Never>("")
    let minTemperatureText = CurrentValueSubject<String, Never>("")
    let weatherIconImageName = CurrentValueSubject<String, Never>("")
    let weatherDifference = CurrentValueSubject<Float, Never>(0.5)
    
    private let dailyWeather: DailyWeatherList
    
    init(dailyWeather: DailyWeatherList) {
        self.dailyWeather = dailyWeather
        setupPublisher()
    }
    
    private func setupPublisher() {
        dayText.send(dailyWeather.dayString)
        maxTemperatureText.send(dailyWeather.maxTemperatureString)
        minTemperatureText.send(dailyWeather.minTemperatureString)
        weatherIconImageName.send(dailyWeather.systemIconNameString)
        weatherDifference.send(dailyWeather.weatherDifference)
    }
}
