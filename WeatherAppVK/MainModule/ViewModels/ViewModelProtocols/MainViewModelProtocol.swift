//
//  MainViewModelProtocol.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation
import Combine
import CoreLocation
import MapKit

protocol MainViewModelProtocol {
    var currentWeather: PassthroughSubject<CurrentWeather, Never> { get }
    var hourlyWeather: CurrentValueSubject<[MainCollectionViewItem], Never> { get }
    var dailyWeather: CurrentValueSubject<[MainCollectionViewItem], Never> { get }
    var mapItems: PassthroughSubject<[MKMapItem], Never> { get }
    
    var isNoInternet: PassthroughSubject<Bool, Never> { get }
    var isCacheAvailable: PassthroughSubject<Bool, Never> { get }
    
    func sendUsersLocation(latitude: CLLocationDegrees?, longitude: CLLocationDegrees?)
    func getWeatherForTheDefaultCity()
    func findCityLocation(with cityName: String)
    
    init(networkManager: NetworkWeatherManagerProtocol)
}
