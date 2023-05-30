//
//  CustomVideoPlayerView.swift
//

import AVKit

class VideoPlayerView: UIView {
    enum PlayerStatus {
        case new
        case readyToPlay
        case playing
        case paused
        case error
    }
    
    enum PlayerRotation {
        case portrait
        case landscapeLeft
        case landscapeRight
        
        func radians() -> CGFloat {
            switch self {
            case .portrait:
                return 0.0
            case .landscapeLeft:
                return CGFloat.pi/2.0
            case .landscapeRight:
                return -CGFloat.pi/2.0
            }
        }
    }
    
    var newVideo: (() -> Void)? = nil
    var readyToPlay: (() -> Void)? = nil
    var startedVideo: (() -> Void)? = nil
    var playingVideo: ((_ progress: Float) -> Void)? = nil
    var pausedVideo: (() -> Void)? = nil
    var finishedVideo: (() -> Void)? = nil
    
    private lazy var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    private lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer()
        return layer
    }()
    
    fileprivate(set) var status: PlayerStatus = .new
    fileprivate(set) var progress: Float = 0.0
    
    private var timeObserver: AnyObject?
    
    var cornerRadius: CGFloat {
        set {
            self.playerLayer.masksToBounds = true
            self.playerLayer.cornerRadius = newValue
        }
        
        get { return self.playerLayer.cornerRadius }
    }
    
    var videoURL: URL? = nil {
        didSet {
            guard let link = videoURL else {
                status = .error
                return
            }
            let asset = AVAsset(url: link)
            setVideoAsset(asset: asset)
        }
    }
    
    var videoAsset: AVAsset? = nil {
        didSet {
            guard let asset = videoAsset else {
                status = .error
                return
            }
            setVideoAsset(asset: asset)
        }
    }
    
    var currentTime: Float {
        if let time = player.currentItem?.currentTime() { return Float(time.seconds) }
        return 0
    }
    
    var videoLenght: Float {
        if let duration = player.currentItem?.asset.duration { return Float(duration.seconds) }
        return 0
    }
    
    var playerRate: Float = 1.0
    
    var shouldLoop: Bool = false
    
    var rotation: PlayerRotation = PlayerRotation.portrait {
        didSet {
            playerLayer.setAffineTransform(CGAffineTransform(rotationAngle: rotation.radians()))
        }
    }
    
    var volume: Float {
        set { player.volume = min(1.0, max(0.0, newValue)) }
        get { return player.volume }
    }
    
    override var frame: CGRect {
        didSet { playerLayer.frame = bounds }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
            timeObserver = nil
        }
        //TODO remove observers
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if layer.sublayers == nil || layer.sublayers!.contains(playerLayer) {
            layer.addSublayer(playerLayer)
        }
        
        playerLayer.frame = bounds
    }
    
    private func setupView() {
        playerLayer.player = player
        playerLayer.contentsScale = UIScreen.main.scale
        
        
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
        }
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.05, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil, using: { [weak self] (time) in
            guard let strongSelf = self, strongSelf.status == .playing else { return }
            let currentTime = Float(time.seconds)
            let length = strongSelf.videoLenght != 0.0 ? strongSelf.videoLenght : 1.0
            strongSelf.progress = currentTime / length
            strongSelf.playingVideo?(strongSelf.progress)
        }) as AnyObject?
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    func seek(_ percentage: Float) {
        guard let currentItem = player.currentItem else { return }
        
        progress = min(1.0, max(0.0, percentage))
        if progress == 0.0 {
            seekToStart()
        }
        else {
            let time = CMTime(seconds: Double(progress) * currentItem.duration.seconds, preferredTimescale: currentItem.duration.timescale)
            player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
        }
        playingVideo?(progress)
    }
    
    private func setVideoAsset(asset: AVAsset) {
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            var error: NSError? = nil
            switch asset.statusOfValue(forKey: "playable", error: &error) {
            case .loaded:
                print("video has been loaded")
            case .failed:
                print("failed to laod video")
            default:
                print("default")
            }
        }
        
        let playerItme = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: ["duration", "tracks"])
        player.replaceCurrentItem(with: playerItme)
        playerLayer.videoGravity = .resizeAspect
        status = .new
        newVideo?()
    }
    
    private func seekToStart() {
        progress = 0.0
        let time = CMTime(seconds: 0.0, preferredTimescale: 1)
        player.seek(to: time) //, toleranceBefore: .zero, toleranceAfter: .zero) // accurate but slow
    }
}

extension VideoPlayerView {
    @objc
    func playVideo() {
        guard let _ = player.currentItem else { return }
        if progress >= 1.0 {
            seekToStart()
        }
        
        player.rate = playerRate
        status = .playing
        startedVideo?()
    }
    
    @objc
    func pauseVideo() {
        player.rate = 0.0
        status = .paused
        pausedVideo?()
    }
    
    @objc
    func playerDidFinishPlaying() {
        let _ = player.currentItem
        
        finishedVideo?()
        
        if shouldLoop == true {
            seekToStart()
            player.rate = playerRate
            status = .playing
        }
        else {
            pauseVideo()
            
        }
    }
    
    func toFullScreen(_ frame: CGRect) {
        guard let rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else { return }
        let fullScreenViewController = AVPlayerViewController()
        fullScreenViewController.player = self.player
        rootVC.present(fullScreenViewController, animated: true, completion: nil)
    }
    
    func minimizeToFrame(_ frame: CGRect) {
        
    }
}
