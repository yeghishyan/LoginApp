//
//  CustomVideoPlayer.swift
//

import UIKit
import AVKit

class VideoPlayer: UIView {
    
    private var videoPlayerView: VideoPlayerView!
    
    private var videoPlayerControls: VideoPlayerControls! {
        didSet {
            videoPlayerControls.playerView = videoPlayerView
            updateControls()
        }
    }
    
    var videoRate: Float {
        set { videoPlayerView.playerRate = newValue }
        get { return videoPlayerView.playerRate }
    }
    
    var currentTime: Float { return videoPlayerView.currentTime }
    
    var videoURLs: [URL] = [] {
        didSet {
            videoPlayerView.videoURL = videoURLs.first
        }
    }
    
    var videoAssets: [AVAsset] = [] {
        didSet {
            videoPlayerView.videoAsset = videoAssets.first
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // setupLayout()
    }
    
    private func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleControls))
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)
        
        videoPlayerView = VideoPlayerView()
        videoPlayerControls = VideoPlayerControls()
        
        videoPlayerControls.playerView = videoPlayerView
        
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerControls.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerControls.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        
        updateControls()
        
        addSubview(videoPlayerView)
        addSubview(videoPlayerControls)
        
        setupLayout()
    }
    
    private func setupLayout() {
        let constraints = [
            videoPlayerView.topAnchor.constraint(equalTo: self.topAnchor),
            videoPlayerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            videoPlayerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            videoPlayerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            videoPlayerControls.topAnchor.constraint(equalTo: videoPlayerView.topAnchor, constant: 0),
            videoPlayerControls.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor, constant: 0),
            videoPlayerControls.widthAnchor.constraint(equalTo: videoPlayerView.widthAnchor, multiplier: 1.0),
            videoPlayerControls.heightAnchor.constraint(equalTo: videoPlayerView.heightAnchor, multiplier: 1.0),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func showControls() {
        UIView.animate(withDuration: 0.5, animations: {
            self.videoPlayerControls.alpha = 1.0
        })
    }
    
    func hideControls() {
        UIView.animate(withDuration: 0.5, animations: {
            self.videoPlayerControls.alpha = 0.0
        })
    }
    
    private func updateControls() {
        videoPlayerControls.newVideo = { [weak self] in
            guard let strongSelf = self else { return }
            let player = strongSelf.videoPlayerView!
            let controls = strongSelf.videoPlayerControls!
            
            if let videoURL = player.videoURL {
                controls.nextButtonHidden = (videoURL == strongSelf.videoURLs.last)
                controls.prevButtonHidden = (videoURL == strongSelf.videoURLs.first)
            } else if let videoAsset = player.videoAsset {
                controls.nextButtonHidden = (videoAsset == strongSelf.videoAssets.last)
                controls.prevButtonHidden = (videoAsset == strongSelf.videoAssets.first)
            }
        }
        
        videoPlayerControls.finishedVideo = { [weak self] in
            guard let strongSelf = self else { return }
            let player = strongSelf.videoPlayerView!
            
            if player.shouldLoop == false { return }
            
            if let videoURL = player.videoURL {
                if videoURL == strongSelf.videoURLs.last {
                    if player.shouldLoop {
                        player.videoURL = strongSelf.videoURLs.first
                    }
                } else {
                    let index = strongSelf.videoURLs.firstIndex(of: videoURL)
                    player.videoURL = strongSelf.videoURLs[index! + 1]
                }
            }
            else if let videoAsset = player.videoAsset {
                if videoAsset == strongSelf.videoAssets.last {
                    if player.shouldLoop {
                        player.videoAsset = strongSelf.videoAssets.first
                    }
                } else {
                    let index = strongSelf.videoAssets.firstIndex(of: videoAsset)
                    player.videoAsset = strongSelf.videoAssets[index! + 1]
                }
            }
        }
        
        videoPlayerControls.didPressNextButton = { [weak self] in
            guard let strongSelf = self else { return }
            let player = strongSelf.videoPlayerView!
            
            if let videoURL = player.videoURL {
                if let index = strongSelf.videoURLs.firstIndex(of: videoURL) {
                    let newIndex = (index + 1) % strongSelf.videoURLs.count
                    player.videoURL = strongSelf.videoURLs[newIndex]
                }
            }
            else if let videoAsset = player.videoAsset {
                if let index = strongSelf.videoAssets.firstIndex(of: videoAsset) {
                    let newIndex = (index + 1) % strongSelf.videoAssets.count
                    player.videoAsset = strongSelf.videoAssets[newIndex]
                }
            }
        }
        
        videoPlayerControls.didPressPrevButton = { [weak self] in
            guard let strongSelf = self else { return }
            let player = strongSelf.videoPlayerView!
            
            if let videoURL = player.videoURL {
                if let index = strongSelf.videoURLs.firstIndex(of: videoURL) {
                    let newIndex = (index > 0 ? index : strongSelf.videoURLs.count) - 1
                    player.videoURL = strongSelf.videoURLs[newIndex]
                }
            }
            else if let videoAsset = player.videoAsset {
                if let index = strongSelf.videoAssets.firstIndex(of: videoAsset) {
                    let newIndex = (index > 0 ? index : strongSelf.videoAssets.count) - 1
                    player.videoAsset = strongSelf.videoAssets[newIndex]
                }
            }
        }
        
        videoPlayerControls.interacting = { [weak self] (isInteracting) in
            guard let strongSelf = self else { return }
            
            if isInteracting {
                strongSelf.showControls()
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
                    self?.hideControls()
                }
            }
        }
        
        videoPlayerControls.didPressResizeButton = { [weak self] (isFullScreen) in
            guard let strongSelf = self else { return }
            
            if isFullScreen {
                strongSelf.videoPlayerView.toFullScreen(strongSelf.bounds)
            }
            else {
                strongSelf.videoPlayerView.minimizeToFrame(strongSelf.bounds)
            }
        }
    }
    
    
    @objc func toggleControls() {
        if videoPlayerControls.alpha == 1.0 && videoPlayerView.status == .playing {
            hideControls()
        }
        else {
            showControls()
            if videoPlayerView.status == .playing {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
                    self?.hideControls()
                }
            }
        }
    }
}

extension VideoPlayer: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: self) == true, view != videoPlayerView, view != videoPlayerControls
            || touch.location(in: videoPlayerControls).y > videoPlayerControls.bounds.size.height - 50 {
            return false
        }
        return true
    }
}
