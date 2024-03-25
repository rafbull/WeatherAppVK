//
//  NetworkManager.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import Foundation
import CoreLocation
import Combine

protocol NetworkWeatherManagerProtocol {
    func getCurrentWeatherData(with endpoint: Endpoint) -> AnyPublisher<CurrentWeatherData, Error>
    func getDailyForecastData(with endpoint: Endpoint) -> AnyPublisher<DailyForecastData, Error>
    func getCurrentWeatherDataFromCache(with endpoint: Endpoint) -> AnyPublisher<CurrentWeatherData, Error>
    func getDailyForecastFromCache(with endpoint: Endpoint) -> AnyPublisher<DailyForecastData, Error>
}

final class NetworkWeatherManager: NetworkWeatherManagerProtocol {
    
    // MARK: - Private Properties
    private let session = URLSession.shared
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    private var subscriptions = Set<AnyCancellable>()
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Public Methods
    public func getCurrentWeatherData(with endpoint: Endpoint) -> AnyPublisher<CurrentWeatherData, Error> {
        fetch(with: endpoint).eraseToAnyPublisher()
    }
    
    public func getDailyForecastData(with endpoint: Endpoint) -> AnyPublisher<DailyForecastData, Error> {
        fetch(with: endpoint).eraseToAnyPublisher()
    }
    
    public func getCurrentWeatherDataFromCache(with endpoint: Endpoint) -> AnyPublisher<CurrentWeatherData, Error> {
        getFromCache(with: endpoint).eraseToAnyPublisher()
    }
    
    public func getDailyForecastFromCache(with endpoint: Endpoint) -> AnyPublisher<DailyForecastData, Error> {
        getFromCache(with: endpoint).eraseToAnyPublisher()
    }
    
    // MARK: Private Methods
    private func fetch<T: Decodable>(with endpoint: Endpoint) -> AnyPublisher<T, Error> {
        let urlString = endpoint.absoluteURL()

        guard let url = URL(string: urlString) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { [weak self] (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode),
                      let self = self
                else {
                    throw URLError(.badServerResponse)
                }
                
                self.userDefaults.set(data, forKey: "\(T.self)")
                return data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func getFromCache<T: Decodable>(with endpoint: Endpoint) -> AnyPublisher<T, Error> {
        do {
            guard let data = userDefaults.object(forKey: "\(T.self)") as? Data else {
                return Fail(error: URLError(.cannotDecodeRawData)).eraseToAnyPublisher()
            }
            let decoded = try decoder.decode(T.self, from: data)
            return Just(decoded)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
