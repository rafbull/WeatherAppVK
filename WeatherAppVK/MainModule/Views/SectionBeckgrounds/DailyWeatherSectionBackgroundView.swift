//
//  DailyWeatherSectionBackgroundView.swift
//  WeatherAppVK
//
//  Created by Rafis on 23.03.2024.
//

import UIKit

final class DailyWeatherSectionBackgroundView: UICollectionReusableView {
    
    static let identifier = "DailyWeatherSectionBackgroundView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = AppColors.dark
        layer.cornerRadius = 30
    }
}
