//
//  VideoPlayerController.swift
//

import UIKit

class BasicVideoPlayerControls: UIView {
    var didPressNextButton: (() -> Void)?
    var didPressPrevButton: (() -> Void)?
    var didPressResizeButton: ((Bool) -> Void)?
    
    var newVideo: (() -> Void)?
    var interacting: ((Bool) -> Void)?
    var finishedVideo: (() -> Void)?
}

class VideoPlayerControls: BasicVideoPlayerControls {
    
    var playerView: VideoPlayerView? {
        didSet {
            setupVideoPlayerView()
        }
    }
    
    @objc
    var isInteracting: Bool = false {
        didSet {
            interacting?(isInteracting)
        }
    }
    
    var nextButtonHidden: Bool {
        set { nextButton.isHidden = newValue }
        get { return nextButton.isHidden }
    }
    
    var prevButtonHidden: Bool {
        set { prevButton.isHidden = newValue }
        get { return prevButton.isHidden }
    }
    
    override var didPressResizeButton: ((Bool) -> Void)? {
        didSet {
            //TODO update layout
        }
    }
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button_play"), for: .normal)
        button.setImage(UIImage(named: "button_pause"), for: .selected)
        button.addTarget(self, action: #selector(playPausePressed), for: .touchUpInside)
        button.tintColor = AppConfig.playerItemColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var resizeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "resize_large"), for: .normal)
        button.addTarget(self, action: #selector(resizePressed), for: .touchUpInside)
        button.tintColor = AppConfig.playerItemColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button_next"), for: .normal)
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        button.isHidden = true
        button.tintColor = AppConfig.playerItemColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var prevButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button_prev"), for: .normal)
        button.addTarget(self, action: #selector(prevPressed), for: .touchUpInside)
        button.isHidden = true
        button.tintColor = AppConfig.playerItemColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var progressSlider: VideoPlayerSlider = {
        let slider = VideoPlayerSlider()
        let thumb = UIImage(named: "slider")?.imageWithImage(scaledTo: CGSize(width: 10, height: 10))

        slider.setThumbImage(thumb, for: .normal)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTapped), for: .touchDown)
        slider.tintColor = .white
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppConfig.playerItemColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppConfig.playerItemColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(playPauseButton)
        addSubview(nextButton)
        addSubview(prevButton)
        addSubview(timeLabel)
        addSubview(progressSlider)
        addSubview(durationLabel)
        addSubview(resizeButton)
        
        setupLayout()
    }
    
    private func setupLayout() {
        let buttonWidth: CGFloat = 35
        let buttonHeight: CGFloat = 35
        let labelWidth: CGFloat = 60
        let sliderHeight: CGFloat = 15
        let resizeButtonSize: CGFloat = 30
        
        let constraints = [
            playPauseButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            playPauseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            playPauseButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            playPauseButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            prevButton.rightAnchor.constraint(equalTo: playPauseButton.leftAnchor, constant: -10),
            prevButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor, constant: 0),
            prevButton.widthAnchor.constraint(equalTo: playPauseButton.widthAnchor, constant: 0),
            prevButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            nextButton.leftAnchor.constraint(equalTo: playPauseButton.rightAnchor, constant: 10),
            nextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor, constant: 0),
            nextButton.widthAnchor.constraint(equalTo: playPauseButton.widthAnchor, constant: 0),
            nextButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            progressSlider.heightAnchor.constraint(equalToConstant: sliderHeight),
            progressSlider.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17),
            progressSlider.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -17),
            progressSlider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            
            timeLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            timeLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 3),
            timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
            
            durationLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            durationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            durationLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 3),
            durationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
            
            resizeButton.widthAnchor.constraint(equalToConstant: resizeButtonSize),
            resizeButton.heightAnchor.constraint(equalToConstant: resizeButtonSize),
            resizeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            resizeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupVideoPlayerView() {
        guard let videoPlayerView = playerView else { return }
        
        videoPlayerView.newVideo = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.newVideo?()
            
            strongSelf.progressSlider.isUserInteractionEnabled = false
            strongSelf.progressSlider.value = 0.0
            
            strongSelf.timeLabel.text = strongSelf.timeFormatted(totalSeconds: 0)
            strongSelf.durationLabel.text = strongSelf.timeFormatted(totalSeconds: 0)
        }
        
        videoPlayerView.readyToPlay = { [weak self, weak videoPlayerView] in
            guard let strongSelf = self, let strongPlayerView = videoPlayerView else { return }
            strongSelf.progressSlider.isUserInteractionEnabled = true
            
            strongSelf.timeLabel.text = strongSelf.timeFormatted(totalSeconds: strongPlayerView.currentTime)
            strongSelf.durationLabel.text = strongSelf.timeFormatted(totalSeconds: strongPlayerView.videoLenght)
        }
        
        videoPlayerView.playingVideo = { [weak self, weak videoPlayerView] (progress) in
            guard let strongSelf = self, let strongPlayerView = videoPlayerView else { return }
            
            if strongSelf.isInteracting == false {
                strongSelf.progressSlider.value = Float(progress)
            }
            
            strongSelf.timeLabel.text = strongSelf.timeFormatted(totalSeconds: strongPlayerView.currentTime)
        }
        
        videoPlayerView.startedVideo = { [weak self] in
            guard let strongSelf = self else { return }
            //strongSelf.playPauseButton.isSelected = !strongSelf.playPauseButton.isSelected
            
            strongSelf.progressSlider.isUserInteractionEnabled = true
            strongSelf.timeLabel.text = strongSelf.timeFormatted(totalSeconds: strongSelf.playerView!.currentTime)
            strongSelf.durationLabel.text = strongSelf.timeFormatted(totalSeconds: strongSelf.playerView!.videoLenght)
        }
        
        videoPlayerView.pausedVideo = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.playPauseButton.isSelected = false
            
            //strongSelf.playPauseButton.isSelected = !strongSelf.playPauseButton.isSelected
        }
        
        videoPlayerView.finishedVideo = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.finishedVideo?()
        }
    }
    
    private func timeFormatted(totalSeconds: Float) -> String {
        let sec = UInt(totalSeconds)
        return String(format: "%02d:%02d", (sec/60)%60, sec%60)
    }
}

//objc
extension VideoPlayerControls {
    @objc
    func playPausePressed(_ sender: UIButton) {
        print("playPayuse state: \(sender.isSelected)")
        sender.isSelected = !sender.isSelected
        
        if playerView?.status == .playing {
            pause()
            isInteracting = true
        }
        else {
            play()
            isInteracting = false
        }
    }
    
    @objc
    func resizePressed(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        
        //isInteracting = true?
        isInteracting = false
        didPressResizeButton?(!sender.isSelected)
    }
    
    @objc
    func nextPressed(_ sender: UIButton) {
        isInteracting = false
        didPressNextButton?()
    }
    
    @objc
    func prevPressed(_ sender: UIButton) {
        isInteracting = false
        didPressPrevButton?()
    }
    
    @objc
    func sliderValueChanged(_ sender: UISlider) {
        print("slider value: \(sender.value)")
        playerView?.seek(sender.value)
    
        perform(#selector(setter: self.isInteracting), with: false, afterDelay: 1)
    }
    
    @objc
    func sliderTapped(_ sender: UISlider) {
        isInteracting = true
    }
}

//Main control
extension VideoPlayerControls {
    
    func play() {
        playerView?.playVideo()
    }
    
    func pause() {
        playerView?.pauseVideo()
    }
    
    func jumpForward(_ value: Float = 0.05) {
        if let progress = playerView?.progress {
            let newProgress = progress + value
            playerView?.seek(newProgress)
        }
    }
    
    func jumpBackward(_ value: Float = 0.05) {
        if let progress = playerView?.progress {
            let newProgress = min(1.0, max(0.0, progress - value))
            playerView?.seek(newProgress)
        }
    }
    
    func volume(_ value: Float) {
        playerView?.volume = value
    }
}
