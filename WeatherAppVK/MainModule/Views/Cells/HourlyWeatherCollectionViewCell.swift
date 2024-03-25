//
//  HourlyWeatherCollectionViewCell.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import UIKit
import Combine

final class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "HourlyWeatherCollectionViewCell"
    
    var viewModel: HourlyWeatherCellViewModelProtocol? {
        didSet {
            sinkToViewModel()
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let weatherIconImageViewSize: CGFloat = 30
        static let hourlyWeatherVStackViewSpacing: CGFloat = 8
        static let contentViewCornerRadius: CGFloat = 20
    }
    
    // MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "--:--"
        label.font = AppFonts.title5
        label.textColor = AppColors.gray1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: UIConstants.weatherIconImageViewSize, weight: .bold)
        imageView.image = UIImage(systemName: "nosign", withConfiguration: imageConfig)
        imageView.tintColor = AppColors.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = AppFonts.title2
        label.textColor = AppColors.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hourlyWeatherVStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [timeLabel, weatherIconImageView, temperatureLabel])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .fill
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    // MARK: - Private Methods
    private func sinkToViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.timeText
            .combineLatest(
                viewModel.temperatureText,
                viewModel.weatherIconImageName
            )
            .sink { [weak self] (timeText, temperatureText, weatherIconImageName) in
                let imageConfig = UIImage.SymbolConfiguration(pointSize: UIConstants.weatherIconImageViewSize, weight: .bold)
                let weatherImage = UIImage(systemName: weatherIconImageName, withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal)
                self?.timeLabel.text = timeText
                self?.temperatureLabel.text = "\(temperatureText)º"
                self?.weatherIconImageView.image = weatherImage
            }
            .store(in: &subscriptions)
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = UIConstants.contentViewCornerRadius
        contentView.backgroundColor = AppColors.dark
        contentView.addSubview(hourlyWeatherVStackView)
    }
    
    private func setConstraints() {
        let contentViewMargins = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            hourlyWeatherVStackView.topAnchor.constraint(equalTo: contentViewMargins.topAnchor),
            hourlyWeatherVStackView.leadingAnchor.constraint(equalTo: contentViewMargins.leadingAnchor),
            hourlyWeatherVStackView.trailingAnchor.constraint(equalTo: contentViewMargins.trailingAnchor),
            hourlyWeatherVStackView.bottomAnchor.constraint(equalTo: contentViewMargins.bottomAnchor),
            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
