//
//  DailyWeatherCollectionViewCell.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import UIKit
import Combine

final class DailyWeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "DailyWeatherCollectionViewCell"
    
    var viewModel: DailyWeatherCellViewModelProtocol? {
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
        static let dailyWeatherHStackViewSpacing: CGFloat = 20
        static let temperatureProgressViewWidthMultiplier: CGFloat = 0.23
    }
    
    // MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Day"
        label.font = AppFonts.title2
        label.textColor = AppColors.white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = AppFonts.title2
        label.textColor = AppColors.gray3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = AppFonts.title2
        label.textColor = AppColors.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.5
        progressView.trackTintColor = AppColors.orange
        progressView.progressTintColor = AppColors.gray2
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: UIConstants.weatherIconImageViewSize, weight: .bold)
        imageView.image = UIImage(systemName: "nosign", withConfiguration: imageConfig)
        imageView.tintColor = AppColors.white
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var dailyWeatherHStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [
            dayLabel,
            minTemperatureLabel,
            temperatureProgressView,
            maxTemperatureLabel,
            weatherIconImageView
        ])
        vStack.axis = .horizontal
        vStack.alignment = .center
        vStack.distribution = .equalSpacing
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    // MARK: - Private Methods
    private func sinkToViewModel() {
        guard let viewModel = viewModel else { return }

        viewModel.dayText
            .combineLatest(
                viewModel.maxTemperatureText,
                viewModel.minTemperatureText,
                viewModel.weatherIconImageName
            )
            .sink { [weak self] (dayText, maxTemperatureText, minTemperatureText, weatherIconImageName) in
                let imageConfig = UIImage.SymbolConfiguration(pointSize: UIConstants.weatherIconImageViewSize, weight: .bold)
                let weatherImage = UIImage(systemName: weatherIconImageName, withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal)
                self?.dayLabel.text = dayText
                self?.maxTemperatureLabel.text = "\(maxTemperatureText)º"
                self?.minTemperatureLabel.text = "\(minTemperatureText)º"
                self?.weatherIconImageView.image = weatherImage
            }
            .store(in: &subscriptions)
        
        viewModel.weatherDifference
            .sink { [weak self] (weatherDifference) in
                self?.temperatureProgressView.setProgress(weatherDifference, animated: false)
            }
            .store(in: &subscriptions)
    }
    
    private func setupUI() {
        contentView.addSubview(dailyWeatherHStackView)
    }
    
    private func setConstraints() {
        let contentViewMargins = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            dailyWeatherHStackView.topAnchor.constraint(equalTo: contentViewMargins.topAnchor),
            dailyWeatherHStackView.leadingAnchor.constraint(equalTo: contentViewMargins.leadingAnchor),
            dailyWeatherHStackView.trailingAnchor.constraint(equalTo: contentViewMargins.trailingAnchor),
            dailyWeatherHStackView.bottomAnchor.constraint(equalTo: contentViewMargins.bottomAnchor),
            
            temperatureProgressView.centerXAnchor.constraint(equalTo: dailyWeatherHStackView.centerXAnchor),
            temperatureProgressView.widthAnchor.constraint(
                equalTo: dailyWeatherHStackView.widthAnchor,
                multiplier: UIConstants.temperatureProgressViewWidthMultiplier
            ),
        ])
    }
}
