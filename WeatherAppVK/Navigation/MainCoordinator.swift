//
//  MainCoordinator.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var rootNavigationController: UINavigationController
    
    private let mainViewModel: MainViewModelProtocol
    
    init(
        navigationController: UINavigationController = MainNavigationController(),
        mainViewModel: MainViewModelProtocol = MainViewModel()
    ) {
        self.rootNavigationController = navigationController
        self.mainViewModel = mainViewModel
    }
    
    func start() {
        let mainViewController = MainViewController(viewModel: mainViewModel)
        rootNavigationController.setViewControllers([mainViewController], animated: false)
    }
}
