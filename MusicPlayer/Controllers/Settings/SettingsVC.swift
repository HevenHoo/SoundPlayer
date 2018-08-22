//
//  SettingsVC.swift
//  MusicPlayer
//
//  Created by Vladyslav Yakovlev on 08.03.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class SettingsVC: UIViewController {
    
    private enum Settings: String {
        
        case search = "Search"
        
        case browser = "Browser"
        
        case rateApp = "Rate app"
        
        case tellFriend = "Tell a friend"
        
        case sendFeedback = "Send feedback"
    }
    
    private let topBar = SettingsTopBar()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset.bottom = 30
        layout.minimumLineSpacing = 14
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let settingsGroups: [SettingsGroup<Settings>] = [
        SettingsGroup(settings: [.search, .browser]),
        SettingsGroup(settings: [.rateApp, .tellFriend, .sendFeedback])]
    
    private let mailPresenter = MailControllerPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Player.main.currentSong != nil ? playerBarAppeared() : playerBarDisappeared()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(topBar)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NavigationSettingCell.self, forCellWithReuseIdentifier: NavigationSettingCell.reuseId)
    
        setupPlayerBarObserver()
    }
    
    private func layoutViews() {
        topBar.frame.origin = .zero
        let topBarHeight: CGFloat = currentDevice == .iPhoneX ? 86 : 90
        topBar.frame.size = CGSize(width: view.frame.width, height: topBarHeight)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.frame = view.bounds
        collectionView.contentInset.top = topBar.frame.height + 18
        collectionView.scrollIndicatorInsets.top = collectionView.contentInset.top
    }
    
    deinit {
        removePlayerBarObserver()
    }
}

extension SettingsVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return settingsGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsGroups[section].settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationSettingCell.reuseId, for: indexPath) as! NavigationSettingCell
        cell.setupTitle(settingsGroups[indexPath.section].settings[indexPath.item].rawValue)
        return cell
    }
}

extension SettingsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = settingsGroups[indexPath.section].settings[indexPath.item]
        didSelect(setting: setting)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 32, height: UIProperties.songCellHeight)
    }
}

extension SettingsVC {
    
    private func didSelect(setting: Settings) {
        switch setting {
        case .search :
            navigationController?.pushViewController(SearchSettingsVC(), animated: true)
        case .browser :
            navigationController?.pushViewController(BrowserSettingsVC(), animated: true)
        case .rateApp :
            RateAppService.openAppStore()
        case .tellFriend :
            showActivityController()
        case .sendFeedback :
            mailPresenter.present(from: self)
        }
    }
    
    private func showActivityController() {
        let appUrl = URL(string: "https://itunes.apple.com/app/\(AppInfo.appId)")!
        let text = "If you ever need to save and play music from your phone, download music app \(appUrl)"
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        present(vc, animated: true)
    }
}

extension SettingsVC: PlayerBarObservable {
    
    func playerBarAppeared() {
        collectionView.contentInset.bottom = UIProperties.playerBarHeight
        collectionView.scrollIndicatorInsets.bottom = UIProperties.playerBarHeight
    }
    
    func playerBarDisappeared() {
        collectionView.contentInset.bottom = 0
        collectionView.scrollIndicatorInsets.bottom = 0
    }
}
