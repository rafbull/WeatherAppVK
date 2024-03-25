//
//  SearchResultTableViewViewModel.swift
//  WeatherAppVK
//
//  Created by Rafis on 24.03.2024.
//

import Foundation
import Combine
import MapKit
import CoreLocation

final class SearchResultTableViewViewModel: SearchResultTableViewViewModelProtocol {
    let cityNames = CurrentValueSubject<[String], Never>([])
    let cityLocation = CurrentValueSubject<[CLLocationCoordinate2D], Never>([])
    
    private let searchResultItems: [MKMapItem]
    
    init(searchResultItems: [MKMapItem]) {
        self.searchResultItems = searchResultItems
        setupPublisher()
    }
    
    private func setupPublisher() {
        searchResultItems.forEach { searchResultItem in
            if let city = searchResultItem.placemark.locality,
               let country = searchResultItem.placemark.country,
               !cityNames.value.contains((city) + " " + (country)) {
                
                self.cityNames.value.append((city) + " " + (country))
                self.cityLocation.value.append(searchResultItem.placemark.coordinate)
                
            }
        }
    }
}
