//
//  HourlyWeatherSectionHeaderView.swift
//  WeatherAppVK
//
//  Created by Rafis on 23.03.2024.
//

import UIKit

final class HourlyWeatherSectionHeaderView: UICollectionReusableView {
    static let identifier = "HourlyWeatherSectionHeaderView"
    static let headerKind = "hourlyHeader"
    
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
        label.text = "🕒 3 Hours Forecast"
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
