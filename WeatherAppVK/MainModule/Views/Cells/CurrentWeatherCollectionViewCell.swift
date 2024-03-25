//
//  CurrentWeatherCollectionViewCell.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import UIKit
import Combine

final class CurrentWeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "CurrentWeatherCollectionViewCell"
    
    var viewModel: CurrentWeatherCellViewModelProtocol? {
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
        static let contentViewCornerRadius: CGFloat = 30
        static let temperatureMaxMinHStackViewSpacing: CGFloat = 16
        static let weatherDescriptionHStackViewSpacing: CGFloat = 8
    }
    
    // MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    
    private let currentLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Location"
        label.font = AppFonts.title2
        label.textColor = AppColors.dark
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = AppFonts.title1
        label.textColor = AppColors.dark
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let degreeSymbolLabel: UILabel = {
        let label = UILabel()
        label.text = "º"
        label.font = AppFonts.title1
        label.textColor = AppColors.dark
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var temperatureHStackView: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [temperatureLabel, degreeSymbolLabel])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.spacing = UIConstants.weatherDescriptionHStackViewSpacing
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()
    
    private let feelsLikeTempLabel: UILabel = {
        let label = UILabel()
        label.text = "Feels like: "
        label.font = AppFonts.title2
        label.textColor = AppColors.dark
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: UIConstants.weatherIconImageViewSize, weight: .bold)
        imageView.image = UIImage(systemName: "nosign", withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal)
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowColor = AppColors.black.cgColor
        imageView.layer.shadowOffset = .init(width: 0, height: 0)
        imageView.layer.shadowRadius = 1
        imageView.tintColor = AppColors.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Weather Description"
        label.font = AppFonts.title3
        label.textColor = AppColors.dark
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weatherDescriptionHStackView: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [weatherIconImageView, weatherDescriptionLabel])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.spacing = UIConstants.weatherDescriptionHStackViewSpacing
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "H: "
        label.font = AppFonts.title3
        label.textColor = AppColors.dark
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "L: "
        label.font = AppFonts.title3
        label.textColor = AppColors.dark
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var temperatureMaxMinHStackView: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [maxTemperatureLabel, minTemperatureLabel])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fillProportionally
        hStack.spacing = UIConstants.temperatureMaxMinHStackViewSpacing
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "Wind: "
        label.font = AppFonts.title3
        label.textColor = AppColors.dark
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currentWeatherVStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [
            currentLocationLabel,
            temperatureLabel,
            feelsLikeTempLabel,
            weatherDescriptionHStackView,
            temperatureMaxMinHStackView,
            windSpeedLabel
        ])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .fillProportionally
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    // MARK: - Private Methods
    private func sinkToViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.currentLocationText
            .combineLatest(
                viewModel.temperatureText,
                viewModel.feelsLikeTempText,
                viewModel.weatherIconImageName
            )
            .sink { [weak self] (locationText, temperatureText, feelsLikeTempText, weatherIconImage) in
                let imageConfig = UIImage.SymbolConfiguration(pointSize: UIConstants.weatherIconImageViewSize, weight: .bold)
                let weatherImage = UIImage(systemName: weatherIconImage, withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal)
                self?.currentLocationLabel.text = locationText
                self?.temperatureLabel.text = temperatureText
                self?.feelsLikeTempLabel.text = "Feels like: \(feelsLikeTempText)º"
                self?.weatherIconImageView.image = weatherImage
            }
            .store(in: &subscriptions)
        
        viewModel.weatherDescriptionText
            .combineLatest(
                viewModel.maxTemperatureText,
                viewModel.minTemperatureText,
                viewModel.windSpeedText
            )
            .sink { [weak self] (descriptionText, maxTempText, minTempText, windSpeedText) in
                self?.weatherDescriptionLabel.text = descriptionText.capitalized
                self?.maxTemperatureLabel.text = "H: \(maxTempText)º"
                self?.minTemperatureLabel.text = "L: \(minTempText)º"
                self?.windSpeedLabel.text = "Wind: \(windSpeedText) m/s"
            }
            .store(in: &subscriptions)
    }
    
    private func setupUI() {
        contentView.backgroundColor = AppColors.slime
        contentView.layer.cornerRadius = UIConstants.contentViewCornerRadius
        
        contentView.addSubview(degreeSymbolLabel)
        contentView.addSubview(currentWeatherVStackView)
    }
    
    private func setConstraints() {
        let contentViewMargins = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            currentWeatherVStackView.topAnchor.constraint(equalTo: contentViewMargins.topAnchor),
            currentWeatherVStackView.leadingAnchor.constraint(equalTo: contentViewMargins.leadingAnchor),
            currentWeatherVStackView.trailingAnchor.constraint(equalTo: contentViewMargins.trailingAnchor),
            currentWeatherVStackView.bottomAnchor.constraint(equalTo: contentViewMargins.bottomAnchor),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            degreeSymbolLabel.topAnchor.constraint(equalTo: temperatureLabel.topAnchor),
            degreeSymbolLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor),
        ])
    }
}
