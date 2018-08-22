//
//  PlayerVC.swift
//  MusicPlayer
//
//  Created by Vladyslav Yakovlev on 20.04.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class PlayerVC: UIViewController {
    
    private let player = Player.main
    
    private let library = Library.main
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 50, height: 40)
        button.setImage(UIImage(named: "ClosePlayerIcon"), for: .normal)
        button.tintColor = UIColor(hex: "aaa9aa")
        button.contentMode = .center
        return button
    }()
    
    let playPauseButton: PlayPauseButton = {
        let button = PlayPauseButton(type: .custom)
        button.frame.size = CGSize(width: 50, height: 50)
        button.playImage = UIImage(named: "PlayIcon")
        button.pauseImage = UIImage(named: "PauseIcon")
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 50, height: 50)
        button.setImage(UIImage(named: "NextIcon"), for: .normal)
        button.contentMode = .center
        return button
    }()
    
    let previousButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 50, height: 50)
        button.setImage(UIImage(named: "PlayerPreviousIcon"), for: .normal)
        button.contentMode = .center
        return button
    }()
    
    private let shuffleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 40, height: 40)
        button.setImage(UIImage(named: "ShuffleIcon"), for: .normal)
        button.contentMode = .center
        button.tintColor = .black
        return button
    }()
    
    private let repeatButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 40, height: 40)
        button.setImage(UIImage(named: "RepeatIcon"), for: .normal)
        button.contentMode = .center
        button.tintColor = .black
        return button
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 40, height: 40)
        button.setImage(UIImage(named: "MoreHorisontalIcon"), for: .normal)
        button.contentMode = .center
        return button
    }()
    
    private let artworkView: ArtworkView = {
        let view = ArtworkView()
        let width = UIProperties.Player.artworkWidth
        view.frame.size = CGSize(width: width, height: width)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.playerTitleFont
        label.textAlignment = .center
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.red
        label.font = Fonts.playerArtistFont
        label.textAlignment = .center
        return label
    }()
    
    private let progressView = PlayerProgressView()
    
    private let volumeView = PlayerVolumeView()
    
    let transitionManager = VerticalTransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(closeButton)
        view.addSubview(artworkView)
        
        view.addSubview(progressView)
        
        view.addSubview(titleLabel)
        view.addSubview(artistLabel)
        
        view.addSubview(playPauseButton)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        
        view.addSubview(shuffleButton)
        view.addSubview(repeatButton)
        view.addSubview(moreButton)
        
        view.addSubview(volumeView)
        
        progressView.delegate = self
        
        repeatButton.tintColor = player.repeatState ? Colors.red : .black
        shuffleButton.tintColor = player.shuffleState ? Colors.red : .black
        
        playPauseButton.addTarget(self, action: #selector(touchUpPlayPauseButton), for: .touchUpInside)
        
        previousButton.addTarget(self, action: #selector(tapPreviousButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        
        shuffleButton.addTarget(self, action: #selector(tapShuffleButton), for: .touchUpInside)
        repeatButton.addTarget(self, action: #selector(tapRepeatButton), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(tapMoreButton), for: .touchUpInside)
        
        closeButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        
        if currentDevice != .iPhoneX {
            view.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        }
    }
    
    private func layoutViews() {
        let centerX = view.frame.width/2
        
        closeButton.center.x = centerX
        closeButton.frame.origin.y = UIProperties.Player.closeButtonTopInset
        
        artworkView.center.x = centerX
        artworkView.frame.origin.y = closeButton.frame.maxY + UIProperties.Player.closeButtonBottomInset
        
        progressView.frame.size = CGSize(width: artworkView.frame.width - 4, height: 40)
        progressView.center.x = centerX
        progressView.frame.origin.y = artworkView.frame.maxY + UIProperties.Player.progressViewTopInset
        
        titleLabel.frame.size = CGSize(width: view.frame.width - 40, height: 24)
        titleLabel.center.x = centerX
        titleLabel.frame.origin.y = progressView.frame.maxY + UIProperties.Player.progressViewBottomInset
        
        artistLabel.frame.size = titleLabel.frame.size
        artistLabel.center.x = centerX
        artistLabel.frame.origin.y = titleLabel.frame.maxY + UIProperties.Player.titleBottomInset
        
        playPauseButton.center.x = view.center.x
        playPauseButton.frame.origin.y = artistLabel.frame.maxY + UIProperties.Player.artistBottomInset
        
        previousButton.center.y = playPauseButton.center.y
        nextButton.center.y = playPauseButton.center.y
        
        previousButton.frame.origin.x = playPauseButton.frame.minX - 30 - previousButton.frame.width
        nextButton.frame.origin.x = playPauseButton.frame.maxX + 30
        
        volumeView.frame.size = CGSize(width: view.frame.width - 60, height: 28)
        volumeView.center.x = centerX
        volumeView.frame.origin.y = playPauseButton.frame.maxY + UIProperties.Player.playButtonBottomInset
        
        shuffleButton.frame.origin.x = 36
        shuffleButton.frame.origin.y = volumeView.frame.maxY + UIProperties.Player.volumeBottomInset
        
        repeatButton.center.x = centerX
        repeatButton.center.y = shuffleButton.center.y
        
        moreButton.center.y = shuffleButton.center.y
        moreButton.frame.origin.x = view.frame.width - moreButton.frame.width - 36
    }
    
    func updateViews() {
        setupArtwork()
        
        updateProgressView()
        
        setupTitleLabel()
        setupArtistLabel()
        
        if player.isPlaying {
            showPauseButton()
            increaseArtwork()
            artworkView.showShadowAnimated()
        } else {
            showPlayButton()
            decreaseArtwork()
            artworkView.hideShadowAnimated()
        }
    }
    
    private func setupArtwork() {
        artworkView.setArtwork(player.currentSong?.artwork)
    }
    
    func updateProgressView() {
        progressView.duration = player.currentDuration
        if progressView.sliderMovedByUser { return }
        progressView.currentTime = player.currentTime
        setupTimeLabels()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = player.currentSong?.title ?? "---"
    }
    
    private func setupArtistLabel() {
        if let album = player.currentSong?.album {
            artistLabel.text = "\(album.artist) - \(album.title)"
        } else {
            artistLabel.text = "Unknown Album"
        }
    }
    
    private func setupTimeLabels() {
        progressView.setupElapsedTime(calculateElapsedTime())
        progressView.setupRemainingTime(calculateRemainingTime())
    }
    
    private func decreaseArtwork() {
        UIView.animate(0.7, damping: 1, velocity: 1) {
            self.artworkView.transform = CGAffineTransform(scaleX: 0.86, y: 0.86).concatenating(CGAffineTransform(translationX: 0, y: -10))
        }
    }
    
    private func increaseArtwork() {
        UIView.animate(0.8, damping: 0.5, velocity: 0.2) {
            self.artworkView.transform = .identity
        }
    }
    
    @objc private func touchUpPlayPauseButton() {
        animatePlayPauseButton()
        player.isPlaying ? player.pause() : player.play()
    }
    
    @objc private func tapPreviousButton() {
        animatePreviousButton()
        player.playPreviousSong()
    }
    
    @objc private func tapNextButton() {
        animateNextButton()
        player.playNextSong()
    }
    
    @objc private func tapCloseButton() {
        dismiss(animated: true)
    }
    
    @objc private func tapMoreButton() {
        showActions(for: player.currentSong!, at: IndexPath())
    }
    
    @objc private func tapShuffleButton() {
        player.shuffleState = !player.shuffleState
        UIView.animate(0.22) {
            self.shuffleButton.tintColor = self.player.shuffleState ? Colors.red : .black
        }
    }
    
    @objc private func tapRepeatButton() {
        player.repeatState = !player.repeatState
        UIView.animate(0.22) {
            self.repeatButton.tintColor = self.player.repeatState ? Colors.red : .black
        }
    }
    
    private func progressSliderDraged() {
        let elapsedTime = stringFromTimeInterval(progressView.currentTime)
        progressView.setupElapsedTime(elapsedTime)
        
        let remainingTime = stringFromTimeInterval(player.currentDuration - progressView.currentTime)
        progressView.setupRemainingTime("-\(remainingTime)")
    }
}

extension PlayerVC {
    
    private func calculateElapsedTime() -> String {
        return stringFromTimeInterval(player.currentTime)
    }
    
    private func calculateRemainingTime() -> String {
        let remainingTime = player.currentDuration - player.currentTime
        let remainingTimeString = stringFromTimeInterval(remainingTime)
        return "-\(remainingTimeString)"
    }
    
    private func stringFromTimeInterval(_ duration: Float) -> String {
        let hours = abs(Int(duration)/3600)
        let minutes = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let seconds = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        
        var timeString = ""
        
        if hours > 0 {
            timeString.append("\(hours):")
        }
        timeString.append("\(minutes):")
        timeString.append(seconds > 9 ? "\(seconds)" : "0\(seconds)")
        
        return timeString
    }
}

extension PlayerVC: PlayerProgressViewDelegate {
    
    func sliderBeganDrag() {
        decreaseArtwork()
    }
    
    func sliderEndedDrag() {
        progressSliderDraged()
        player.currentTime = progressView.currentTime
        if player.isPlaying {
            increaseArtwork()
        }
    }
    
    func sliderIsDragging() {
        progressSliderDraged()
    }
}

extension PlayerVC: SongActions {
    
    func renameSong(_ song: Song, with name: String, at indexPath: IndexPath) {
        library.renameSong(song, with: name) {
            self.updateViews()
        }
    }
    
    func removeSong(_ song: Song, at indexPath: IndexPath) {
        if let album = song.album, album.songs.count == 1 {
            library.removeAlbum(album) {
                LibraryVC.shared.updateAlbumsView()
            }
        }
        let checkPlaylists = !song.playlists.isEmpty
        
        player.stop()
        
        library.removeSong(song) {
            LibraryVC.shared.updateSongsView()
            if checkPlaylists {
                self.library.removeEmptyPlaylists { removed in
                    if removed {
                        LibraryVC.shared.updatePlaylistsView()
                    }
                }
            }
        }
    }
}

extension PlayerVC: PlayerControlable {}

