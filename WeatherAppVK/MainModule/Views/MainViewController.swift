//
//  ViewController.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import UIKit
import Combine
import CoreLocation
import MapKit

class MainViewController: UIViewController {
    
    // MARK: Initialization
    init(viewModel: MainViewModelProtocol = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        requestUserLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkInternetConnection()
        applySnapshot()
    }
    
    // MARK: - Private Properties
    private let viewModel: MainViewModelProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    private var contentView: MainView = {
        let contentView = MainView()
        return contentView
    }()
    
    private lazy var searchResultController = SearchResultTableViewController()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a city"
        return searchController
    }()
    
    private lazy var dataSource: MainCollectionViewDiffableDataSource = createDataSource()
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MainCollectionViewSection, MainCollectionViewItem>
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    // MARK: - Private Methods
    private func setupUI() {
        navigationItem.searchController = searchController
    }
    
    // Creating Data Source
    private func createDataSource() -> MainCollectionViewDiffableDataSource {
        dataSource = MainCollectionViewDiffableDataSource(collectionView: contentView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .currentWeather(let currentWeather):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCollectionViewCell.identifier, for: indexPath) as? CurrentWeatherCollectionViewCell
                cell?.viewModel = CurrentWeatherCellViewModel(currentWeather: currentWeather)
                return cell
            case .hourlyWeather(let hourlyWeather):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.identifier, for: indexPath) as? HourlyWeatherCollectionViewCell
                cell?.viewModel = HourlyWeatherCellViewModel(hourlyWeather: hourlyWeather)
                return cell
            case .dailyWeather(let dailyWeather):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCollectionViewCell.identifier, for: indexPath) as? DailyWeatherCollectionViewCell
                cell?.viewModel = DailyWeatherCellViewModel(dailyWeather: dailyWeather)
                return cell
            }
        })
        
        // Headers for sections
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            switch kind {
            case HourlyWeatherSectionHeaderView.headerKind:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HourlyWeatherSectionHeaderView.identifier,
                    for: indexPath
                )
                
                guard let typedHeaderView = headerView as? HourlyWeatherSectionHeaderView
                else { return headerView}
                
                return typedHeaderView
            case DailyWeatherSectionHeaderView.headerKind:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: DailyWeatherSectionHeaderView.identifier,
                    for: indexPath
                )
                
                guard let typedHeaderView = headerView as? DailyWeatherSectionHeaderView
                else { return headerView}
                
                return typedHeaderView
            default:
                fatalError("Can't dequeue header view")
            }
        }
        
        return dataSource
    }
    
    private func applySnapshot() {
        viewModel.currentWeather
            .combineLatest(viewModel.hourlyWeather, viewModel.dailyWeather)
            .sink(receiveValue: { [weak self] (currentWeather, hourlyWeather, dailyWeather) in
                
                var snapshot = Snapshot()
                snapshot.appendSections([.currentWeather, .hourlyWeather, .dailyWeather])
                snapshot.appendItems([MainCollectionViewItem.currentWeather(currentWeather)], toSection: .currentWeather)
                snapshot.appendItems(hourlyWeather, toSection: .hourlyWeather)
                snapshot.appendItems(dailyWeather, toSection: .dailyWeather)
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            })
            .store(in: &subscriptions)
    }
    
    private func requestUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func updateUserLocation(_ locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        locationManager.stopUpdatingLocation()

        viewModel.sendUsersLocation(latitude: latitude, longitude: longitude)
    }
    
    private func findCityLocation(with cityName: String) {
        viewModel.findCityLocation(with: cityName)
        
        viewModel.mapItems
            .sink { [weak self] mapItems in
                self?.searchResultController.viewModel = SearchResultTableViewViewModel(searchResultItems: mapItems)
            }
            .store(in: &subscriptions)
        
        // Getting city coordinates from the search controller and sending them to the view model
        searchResultController.selectedCityCoordinates = { [weak self] coordinate in
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            self?.viewModel.sendUsersLocation(latitude: latitude, longitude: longitude)
        }
    }

    private func checkInternetConnection() {
        viewModel.isNoInternet
            .combineLatest(viewModel.isCacheAvailable)
            .sink { [weak self] (isNoInternet, isCacheAvailable) in
                if isNoInternet {
                    let alertController = UIAlertController(
                        title: AppConstants.noInternetAlertTitle,
                        message: AppConstants.noInternetAlertMessage,
                        preferredStyle: .alert
                    )
                    let alertAction = UIAlertAction(title: AppConstants.noInternetActionTitle, style: .default)
                    alertController.addAction(alertAction)
                    self?.present(alertController, animated: true)
                }
                self?.contentView.noInternetLabel.isHidden = isCacheAvailable
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Extension CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateUserLocation(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error:", error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("The user authorized the app to start location services at any time or while it is in use.")
        case .denied, .notDetermined:
            viewModel.getWeatherForTheDefaultCity()
        case .restricted:
            print("The app is not authorized to use location services.")
        @unknown default:
            print("Unknown error. Unable to get location")
        }
    }
}

// MARK: - Extension UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let cityName = searchController.searchBar.text else { return }
        findCityLocation(with: cityName)
    }
}
