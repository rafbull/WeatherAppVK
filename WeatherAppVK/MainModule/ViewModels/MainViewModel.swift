//
//  MainViewModel.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation
import Combine
import CoreLocation
import MapKit

final class MainViewModel: MainViewModelProtocol {

    private let networkManager: NetworkWeatherManagerProtocol
    
    var currentWeather = PassthroughSubject<CurrentWeather, Never>()
    var hourlyWeather = CurrentValueSubject<[MainCollectionViewItem], Never>([])
    var dailyWeather = CurrentValueSubject<[MainCollectionViewItem], Never>([])
    var mapItems = PassthroughSubject<[MKMapItem], Never>()
    
    var isNoInternet = PassthroughSubject<Bool, Never>()
    var isCacheAvailable = PassthroughSubject<Bool, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
        
    init(networkManager: NetworkWeatherManagerProtocol = NetworkWeatherManager()) {
        self.networkManager = networkManager
    }
    
    private func fetchCurrentWeather(with endpoint: Endpoint) {
        networkManager.getCurrentWeatherData(with: endpoint)
            .sink { [weak self] status in
                switch status {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isNoInternet.send(true)
                    self?.getCurrentWeatherFromCache(with: endpoint)
                case .finished:
                    self?.isNoInternet.send(false)
                }
            } receiveValue: { [weak self] currentWeatherData in
                guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return }
                self?.currentWeather.send(currentWeather)
            }
            .store(in: &subscriptions)
    }
    
    private func fetchDailyForecast(with endpoint: Endpoint) {
        networkManager.getDailyForecastData(with: endpoint)
            .sink { [weak self] status in
                switch status {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isNoInternet.send(true)
                    self?.getDailyForecastFromCache(with: endpoint)
                case .finished:
                    self?.isNoInternet.send(false)
                }
            } receiveValue: { [weak self] dailyForcastData in
                guard let hourlyWeather = HourlyWeather(hourlyWeatherData: dailyForcastData) else { return }
                self?.hourlyWeather.value = hourlyWeather.hourlyWeatherList.map { MainCollectionViewItem.hourlyWeather($0) }
                
                guard let dailyWeather = DailyWeather(dailyWeatherData: dailyForcastData) else { return }
                self?.dailyWeather.value = dailyWeather.dailyWeatherList.map { MainCollectionViewItem.dailyWeather($0) }
            }
            .store(in: &subscriptions)
    }
    
    private func getCurrentWeatherFromCache(with endpoint: Endpoint) {
        networkManager.getCurrentWeatherDataFromCache(with: endpoint)
            .sink { [weak self] status in
                switch status {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isCacheAvailable.send(false)
                case .finished:
                    self?.isCacheAvailable.send(true)
                }
            } receiveValue: { [weak self] currentWeatherData in
                guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return }
                self?.currentWeather.send(currentWeather)
            }
            .store(in: &subscriptions)
    }
    
    private func getDailyForecastFromCache(with endpoint: Endpoint) {
        networkManager.getDailyForecastFromCache(with: endpoint)
            .sink { [weak self] status in
                switch status {
                case .failure(let error):
                    self?.isCacheAvailable.send(false)
                    print(error.localizedDescription)
                case .finished:
                    self?.isCacheAvailable.send(true)
                }
            } receiveValue: { [weak self] dailyForcastData in
                guard let hourlyWeather = HourlyWeather(hourlyWeatherData: dailyForcastData) else { return }
                self?.hourlyWeather.value = hourlyWeather.hourlyWeatherList.map { MainCollectionViewItem.hourlyWeather($0) }
                
                guard let dailyWeather = DailyWeather(dailyWeatherData: dailyForcastData) else { return }
                self?.dailyWeather.value = dailyWeather.dailyWeatherList.map { MainCollectionViewItem.dailyWeather($0) }
            }
            .store(in: &subscriptions)
    }
    
    func sendUsersLocation(latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) {
        guard let latitude = latitude, let longitude = longitude else { return }
        
        fetchCurrentWeather(with: .currentWeatherCoordinate(latitude: latitude, longitude: longitude))
        fetchDailyForecast(with: .dailyForecastCoordinate(latitude: latitude, longitude: longitude))
    }
    
    func getWeatherForTheDefaultCity() {
        self.fetchCurrentWeather(with: .currentWeatherCityName(city: APIConstants.defaultCity))
        self.fetchDailyForecast(with: .dailyForecastCityName(city: APIConstants.defaultCity))
    }
    
    func findCityLocation(with cityName: String) {
        let request = MKLocalSearch.Request()
        request.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        request.naturalLanguageQuery = cityName
        request.region = MKCoordinateRegion(.world)

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response, error == nil else { return }
            
            let mapItems = response.mapItems
            self?.mapItems.send(mapItems)
        }
    }
}
