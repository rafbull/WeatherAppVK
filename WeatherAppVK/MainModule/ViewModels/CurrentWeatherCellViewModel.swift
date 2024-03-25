//
//  CurrentWeatherCellViewModel.swift
//  WeatherAppVK
//
//  Created by Rafis on 22.03.2024.
//

import Foundation
import Combine
import CoreLocation

final class CurrentWeatherCellViewModel: CurrentWeatherCellViewModelProtocol {
    let currentLocationText = CurrentValueSubject<String, Never>("")
    let temperatureText = CurrentValueSubject<String, Never>("")
    let feelsLikeTempText = CurrentValueSubject<String, Never>("")
    let weatherIconImageName = CurrentValueSubject<String, Never>("")
    let weatherDescriptionText = CurrentValueSubject<String, Never>("")
    let maxTemperatureText = CurrentValueSubject<String, Never>("")
    let minTemperatureText = CurrentValueSubject<String, Never>("")
    let windSpeedText = CurrentValueSubject<String, Never>("")
    
    
    private let currentWeather: CurrentWeather
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
        setupPublisher()
    }
    
    private func setupPublisher() {
        temperatureText.send(currentWeather.temperatureString)
        feelsLikeTempText.send(currentWeather.feelsLikeTemperatureString)
        weatherIconImageName.send(currentWeather.systemIconNameString)
        weatherDescriptionText.send(currentWeather.weatherDescription)
        maxTemperatureText.send(currentWeather.minTemperatureString)
        minTemperatureText.send(currentWeather.maxTemperatureString)
        windSpeedText.send(currentWeather.windSpeedString)
        
        convertCoordinateToCityName { [weak self] cityName in
            guard let self = self else { return }
            let cachedLocation = self.currentWeather.location
            self.currentLocationText.value = cityName ?? cachedLocation
        }
    }
    
    private func convertCoordinateToCityName(completionHandler: @escaping (String?) -> Void) {
        let latitude = CLLocationDegrees(currentWeather.latitude)
        let longitude = CLLocationDegrees(currentWeather.longitude)
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation?.locality)
            }
            else {
                completionHandler(nil)
            }
        }
    }
}
