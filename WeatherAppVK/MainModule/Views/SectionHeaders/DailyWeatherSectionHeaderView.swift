//
//  DailyWeatherSectionHeaderView.swift
//  WeatherAppVK
//
//  Created by Rafis on 24.03.2024.
//

import UIKit

final class DailyWeatherSectionHeaderView: UICollectionReusableView {
    static let identifier = "DailyWeatherSectionHeaderView"
    static let headerKind = "dailyHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "📆 Daily Forecast"
        label.textColor = AppColors.gray1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupUI() {
        backgroundColor = AppColors.dark
        layer.cornerRadius = 10
        
        addSubview(headerLabel)
    }
    
    private func setConstraints() {
        let viewMargins = layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: viewMargins.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: viewMargins.bottomAnchor),
        ])
    }
}
