//
//  AppCoordinator.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    
    private var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        childCoordinators = [mainCoordinator]
        window.rootViewController = mainCoordinator.rootNavigationController
    }
}
