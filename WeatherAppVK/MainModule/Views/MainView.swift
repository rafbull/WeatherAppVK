//
//  MainView.swift
//  WeatherAppVK
//
//  Created by Rafis on 21.03.2024.
//

import UIKit

final class MainView: UIView {
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let dailyItemGroupHeight: CGFloat = 60
        static let collectionItemInsets: NSDirectionalEdgeInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        static let collectionSectionInsets: NSDirectionalEdgeInsets = .init(top: 14, leading: 14, bottom: 14, trailing: 14)
        static let currentWeatherSectionInsets: NSDirectionalEdgeInsets = .init(top: 0, leading: 14, bottom: 14, trailing: 14)
        
        static let sectionHeaderHeight: CGFloat = 44
        
        static let dailySectionBackgroundInsets: NSDirectionalEdgeInsets = .init(top: 56, leading: 16, bottom: 8, trailing: 16)
        
        static let dailyItemInsets: NSDirectionalEdgeInsets = .init(top: 8, leading: 8, bottom: 0, trailing: 8)
    }
    
    // MARK: - Private Properties
    lazy var collectionView: UICollectionView = createCollectionView()
    
    private(set) var noInternetLabel: UILabel = {
        let label = UILabel()
        label.text = "Weather Unavailable\n\nThe WeatherAppVK app isn't connected to the internet.\nTo view weather, check your connection, then try again."
        label.numberOfLines = 0
        label.font = AppFonts.title2
        label.textColor = AppColors.gray3
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Private Methods
    // Setting up CollectionView
    private func createCollectionView() -> UICollectionView {
        let layout = createLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CurrentWeatherCollectionViewCell.self, forCellWithReuseIdentifier: CurrentWeatherCollectionViewCell.identifier)
        collectionView.register(HourlyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.identifier)
        collectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.identifier)
        collectionView.register(HourlyWeatherSectionHeaderView.self, forSupplementaryViewOfKind: HourlyWeatherSectionHeaderView.headerKind, withReuseIdentifier: HourlyWeatherSectionHeaderView.identifier)
        collectionView.register(DailyWeatherSectionHeaderView.self, forSupplementaryViewOfKind: DailyWeatherSectionHeaderView.headerKind, withReuseIdentifier: DailyWeatherSectionHeaderView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    // Creating CollectionView Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = MainCollectionViewSection(rawValue: sectionIndex) else { return nil }
            
            switch sectionKind {
            case .currentWeather:
                return self?.createCurrentWeatherLayout()
            case .hourlyWeather:
                return self?.createHourlyWeatherLayout()
            case .dailyWeather:
                return self?.createDailyWeatherLayout()
            }
        }
        
        layout.register(DailyWeatherSectionBackgroundView.self, forDecorationViewOfKind: DailyWeatherSectionBackgroundView.identifier)
        
        return layout
    }
    
    private func createCurrentWeatherLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = UIConstants.collectionItemInsets
        
        let groupWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupWidth)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = UIConstants.currentWeatherSectionInsets
        
        return section
    }
    
    private func createHourlyWeatherLayout() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(UIConstants.sectionHeaderHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HourlyWeatherSectionHeaderView.headerKind,
            alignment: .top
        )
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = UIConstants.collectionItemInsets
        
        let groupWidth = NSCollectionLayoutDimension.fractionalWidth(0.25)
        let groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.33)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = UIConstants.collectionSectionInsets
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createDailyWeatherLayout() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(UIConstants.sectionHeaderHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: DailyWeatherSectionHeaderView.headerKind,
            alignment: .top
        )
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = UIConstants.dailyItemInsets
        
        let groupWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let groupHeight = NSCollectionLayoutDimension.absolute(UIConstants.dailyItemGroupHeight)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = UIConstants.collectionSectionInsets
        
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: DailyWeatherSectionBackgroundView.identifier)
        sectionBackgroundDecoration.contentInsets = UIConstants.dailySectionBackgroundInsets
        section.decorationItems = [sectionBackgroundDecoration]
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func setupUI() {
        addSubview(collectionView)
        addSubview(noInternetLabel)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            noInternetLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            noInternetLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            noInternetLabel.topAnchor.constraint(equalTo: topAnchor),
            noInternetLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
