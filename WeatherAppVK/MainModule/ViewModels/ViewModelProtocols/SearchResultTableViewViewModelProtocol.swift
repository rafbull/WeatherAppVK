//
//  SearchResultTableViewViewModelProtocol.swift
//  WeatherAppVK
//
//  Created by Rafis on 24.03.2024.
//

import Foundation
import Combine
import MapKit

protocol SearchResultTableViewViewModelProtocol {
    var cityNames: CurrentValueSubject<[String], Never> { get }
    var cityLocation: CurrentValueSubject<[CLLocationCoordinate2D], Never> { get }
    
    init(searchResultItems: [MKMapItem])
}
