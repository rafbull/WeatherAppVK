//
//  SearchTableViewController.swift
//  WeatherAppVK
//
//  Created by Rafis on 24.03.2024.
//

import UIKit
import Combine
import CoreLocation

final class SearchResultTableViewController: UITableViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regiserCell()
    }
    
    var viewModel: SearchResultTableViewViewModelProtocol? {
        didSet {
            sinkToViewModel()
        }
    }
    
    var selectedCityCoordinates: ((_ cityCoordinates: CLLocationCoordinate2D) -> Void)?
    
    // MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Private Methods
    private func sinkToViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.cityNames
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }
    
    private func regiserCell() {
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
    }
}

// MARK: - Extension Table view data source
extension SearchResultTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.cityNames.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell,
              let viewModel = viewModel
        else { return UITableViewCell() }

        var configuration = cell.defaultContentConfiguration()
        configuration.text = viewModel.cityNames.value[indexPath.row]
        cell.contentConfiguration = configuration

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true)
        
        guard let viewModel = viewModel else { return }
        
        let cityCoordinates = viewModel.cityLocation.value[indexPath.row]

        selectedCityCoordinates?(cityCoordinates)
    }
}
