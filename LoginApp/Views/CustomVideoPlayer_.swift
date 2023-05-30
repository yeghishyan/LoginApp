//
//  CustomVideoPlayer.swift
//

import UIKit
import AVKit
import Foundation


enum stateOfVC {
    case minimized
    case fullScreen
    case hidden
}

enum Direction {
    case up
    case left
    case none
}

class CustomVideoPlayer: UIView {
    var link : String? = "https://parthenon.stream.voidboost.cc/8/2/1/2/1/5/2b992ee79f102c1e7ffd1a7901069876:2023050516:RnhGRmp3SnhpUm8vWGo4Tm0yYWhoVDRmZm1xQWtwV1I5VGRuS3lTSS80VXNtejlKYUZJQzJmNnJ5WU5sMkg5VFQzMXpiZWdDZUFvT1M1WVVOZ21PMHc9PQ==/hls.m3u8"
    
    var minimizedOrigin: CGPoint?
    var viewPortFrame: CGRect?
    
    var state = stateOfVC.fullScreen
    var direction = Direction.none
    
    var isVideoLandScape : Bool = false
    var isVideoMinimize : Bool = false
    var isContainerVisible: Bool = true
    
    var counter = 0
    var cashedTime: CGFloat = 0.0
    var selectedActionSheetIndex = 0
    var sliderChangedValue: CGFloat = 0.0
    
    let vodLink = ["480p x264", "720p x265", "1080p x265","Adaptive"]
    
    //init constant
    private let customErrorViewHeight : CGFloat = 91
    private var playerLayerHeight : CGFloat =  250
    private let sliderHeight : CGFloat = 30
    private let playBtnHeight : CGFloat = 32
    private let changeVideoScaleBtnHeight: CGFloat = 30
    private let adaptiveHeight: CGFloat = 30
    private let adaptiveWidth: CGFloat = 150
    private let defaultMargin : CGFloat = 10
    private let expiredTimeLblHeight : CGFloat = 16
    private let expiredTimeLblWidth: CGFloat = 52
    private let duratiponLblWidth: CGFloat = 66
    private let sliderBackgroundLblWidth: CGFloat = 40
    
    lazy var playerLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.isHidden = true
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var gestureLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.isUserInteractionEnabled = true
        label.frame = CGRect(x: 0, y: defaultMargin, width: UIScreen.main.bounds.width, height: playerLayerHeight)
        label.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(sender:))))
        label.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(playerTappedToMaximize(sender:))))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sliderLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.frame = CGRect(x: 0, y: playerLayerHeight - sliderBackgroundLblWidth,
                             width: UIScreen.main.bounds.width, height: sliderBackgroundLblWidth)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var expiredTimeLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var adaptiveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Video Quality", for: .normal)
        button.contentMode = .scaleToFill
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 6.0
        button.layer.masksToBounds = true
        button.frame = CGRect(x: UIScreen.main.bounds.width - adaptiveWidth - defaultMargin ,
                              y: 3*defaultMargin,
                              width: adaptiveWidth, height: adaptiveHeight)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var minimizeButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.frame = CGRect(x: defaultMargin, y: 3*defaultMargin ,
                              width: changeVideoScaleBtnHeight, height: changeVideoScaleBtnHeight)
        button.setImage(UIImage(named: "dismiss"), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.frame = CGRect(x: (UIScreen.main.bounds.width-playBtnHeight)/2,
                              y: (playerContainer.frame.height-playBtnHeight)/2, 
                              width: playBtnHeight, height: playBtnHeight)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var videoScaleButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.setBackgroundImage(UIImage(named: "enlarge"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var custommErrorContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var playerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 1
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: playerLayerHeight)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)
        slider.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(sliderTapped(gestureRecognizer:))))
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    
    lazy var player: AVPlayer = {
        let asset = AVURLAsset(url: URL.init(string: link!)!)
        let item = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: item)
        return player
    }()
    
    lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer(player: player)
        layer.frame = CGRect(x: 0, y: 20 , width: UIScreen.main.bounds.width, height: playerLayerHeight + 20)
        //layer.translatesAutoresizingMaskIntoConstraints = false
        return layer
    }()

    var counterTimer : Timer? = {
        let timer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(prozessTimer), userInfo: nil, repeats: true)
        return timer
    }()
    
    
    func initializeView() {
        addPlayer()
    }
    
    func addPlayer()  {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        viewPortFrame = self.frame
        
        if playerLayer.player?.currentItem != nil {
            playerLayer.player?.pause()
            playerLayer.removeFromSuperlayer()
        }
        
        isVideoLandScape = false
        
        playerContainer.layer.addSublayer(playerLayer)
        playerLayer.player?.play()
        playerLayer.videoGravity = .resizeAspect
        playerLayer.addSublayer(playerLabel.layer)
        playerLayer.addSublayer(sliderLabel.layer)
        playerLayer.addSublayer(slider.layer)
        playerLayer.addSublayer(durationLabel.layer)
        playerLayer.addSublayer(videoScaleButton.layer)
        playerLayer.addSublayer(minimizeButton.layer)
        playerLayer.addSublayer(adaptiveButton.layer)
        playerLayer.addSublayer(expiredTimeLabel.layer)
        playerLayer.addSublayer(gestureLabel.layer)
        
        playerLabel.frame = gestureLabel.frame
        
        self.playerLayer.addSublayer(self.playButton.layer)
        
        slider.frame = CGRect(x: expiredTimeLblWidth + 2*defaultMargin , y: sliderLabel.frame.origin.y + 2*defaultMargin  , width: UIScreen.main.bounds.width-expiredTimeLblWidth - duratiponLblWidth - changeVideoScaleBtnHeight - 4*defaultMargin  , height: sliderHeight)
        
        expiredTimeLabel.frame = CGRect(x: defaultMargin/2, y:sliderLabel.frame.origin.y + defaultMargin , width: expiredTimeLblWidth + 10, height: expiredTimeLblHeight)
        
        durationLabel.frame = CGRect(x: UIScreen.main.bounds.width - duratiponLblWidth - changeVideoScaleBtnHeight - 2*defaultMargin , y: sliderLabel.frame.origin.y + defaultMargin, width: duratiponLblWidth, height: expiredTimeLblHeight)
        
        videoScaleButton.frame = CGRect(x: UIScreen.main.bounds.width - changeVideoScaleBtnHeight - defaultMargin, y:sliderLabel.frame.origin.y + defaultMargin/2, width: changeVideoScaleBtnHeight, height: changeVideoScaleBtnHeight)
        
        durationLabel.textColor = UIColor.white
        var eventTime: Int = 0
        
        playerLayer.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.playerLayer.player!.currentItem?.status == .readyToPlay {
                _ = self.dispatchOnce
                
                let time : Float64 = CMTimeGetSeconds((self.playerLayer.player!.currentTime()))
                self.slider.value = Float ( time )
                
                self.expiredTimeLabel.text = String(format: "\(time.format(using: [.hour, .minute, .second])!)")
                self.expiredTimeLabel.textColor = UIColor.white
                eventTime = Int(time)
                
                if self.sliderChangedValue == 0 {
                    self.cashedTime = CGFloat ( time )
                } else {
                    let tmp = (CGFloat(time) - self.sliderChangedValue) + self.cashedTime
                    self.cashedTime = tmp
                    return
                }
                
                if eventTime == 1 {
                    self.killTimer()
                }
            }
        }
        
    }
    
    private lazy var dispatchOnce: Void = {
        if self.player.rate == 0 {
            self.playButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            self.playButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        let tim : Float64 = CMTimeGetSeconds((self.playerLayer.player!.currentItem?.asset.duration)!)
        self.slider.isHidden = false
        self.slider.maximumValue = Float(tim)
        self.durationLabel.text = String(format: "\(tim.format(using: [.hour, .minute, .second])!)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.hidePlayerButtonsOnPlay()
        }
    }()
    
    func landScapeMode() {
        playerLabel.isHidden = false
        playerLabel.isUserInteractionEnabled = true
        playerLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleHideContainerBtn)))
        
        isVideoLandScape = true
        
        self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        self.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.width)
        self.playerContainer.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: playerContainer.frame.width)
        
        self.playerLayer.frame = playerContainer.frame
        self.gestureLabel.frame = CGRect(x: 0, y: 0,
                                       width: self.frame.height, height: playerContainer.frame.width)
        
        self.sliderLabel.frame = CGRect(x: 0, y: playerLayer.frame.height-sliderBackgroundLblWidth,
                                                width: UIScreen.main.bounds.height, height: sliderBackgroundLblWidth)
        
        playerLabel.frame = gestureLabel.frame
        
        self.slider.frame = CGRect(x: expiredTimeLblWidth + 4*defaultMargin ,
                                   y: sliderLabel.frame.origin.y + 2*defaultMargin,
                                   width: playerContainer.frame.width - expiredTimeLblWidth - changeVideoScaleBtnHeight - duratiponLblWidth - 7*defaultMargin,
                                   height: sliderHeight)
        
        self.expiredTimeLabel.frame = CGRect(x: defaultMargin*2,
                                           y: self.slider.frame.origin.y-defaultMargin/2 ,
                                           width: expiredTimeLblWidth + 2*defaultMargin , height: expiredTimeLblHeight)
        
        self.durationLabel.frame = CGRect(x: self.playerContainer.frame.width - duratiponLblWidth - changeVideoScaleBtnHeight - 2*defaultMargin,
                                        y: expiredTimeLabel.frame.origin.y,
                                        width: duratiponLblWidth, height: expiredTimeLblHeight)
        
        self.adaptiveButton.frame = CGRect(x: playerContainer.frame.width - adaptiveWidth - defaultMargin,
                                        y: 2*defaultMargin,
                                        width: adaptiveWidth, height: adaptiveHeight)
        
        self.videoScaleButton.frame = CGRect(x: playerContainer.frame.width - changeVideoScaleBtnHeight - defaultMargin,
                                                y: playerContainer.frame.height - changeVideoScaleBtnHeight/2 - defaultMargin - defaultMargin/2 ,
                                                width: changeVideoScaleBtnHeight, height: changeVideoScaleBtnHeight)
        
        videoScaleButton.setBackgroundImage(UIImage(named: "scale-down"), for: .normal)
        minimizeButton.setImage(UIImage(named: "back"), for: .normal)
        
        self.playButton.frame = CGRect(x: (playerLayer.frame.size.width)/2,
                                    y:(playerLayer.frame.size.height)/2 ,
                                    width: playBtnHeight, height: playBtnHeight)
        
        slider.isHidden = false
        sliderLabel.isHidden = false
        expiredTimeLabel.isHidden = false
        durationLabel.isHidden = false
    }
    
    func portraitMode() {
        isVideoLandScape = false
        
        gestureLabel.isUserInteractionEnabled = true
        playerLabel.isHidden = true
        playerLabel.isUserInteractionEnabled = false
        self.transform = CGAffineTransform(rotationAngle: 0)
        
        self.frame = viewPortFrame ?? CGRect(x: 0, y: 0,
                                             width: UIScreen.main.bounds.width,
                                             height: UIScreen.main.bounds.height)

        self.playerContainer.frame = CGRect(x: 0, y: 0,
                                            width: self.frame.width,
                                            height: playerLayerHeight)
        
        playerLayer.frame = CGRect(x: 0, y: 20,
                                    width: self.frame.width,
                                    height: playerLayerHeight)
        
        sliderLabel.frame = CGRect(x: 0,
                                           y: playerContainer.frame.height-sliderBackgroundLblWidth,
                                           width: UIScreen.main.bounds.width,
                                           height: sliderBackgroundLblWidth)
        
        self.gestureLabel.frame = CGRect(x: 0,
                                       y: defaultMargin,
                                       width: self.frame.width,
                                       height: playerLayerHeight)
        
        playerLabel.frame = gestureLabel.frame
        
        slider.frame = CGRect(x: expiredTimeLblWidth + 2*defaultMargin,
                              y: sliderLabel.frame.origin.y + 2*defaultMargin,
                              width: UIScreen.main.bounds.width-expiredTimeLblWidth - duratiponLblWidth - changeVideoScaleBtnHeight - 4*defaultMargin,
                              height: sliderHeight)
        
        videoScaleButton.frame = CGRect(x: UIScreen.main.bounds.width - changeVideoScaleBtnHeight - defaultMargin,
                                           y:sliderLabel.frame.origin.y + defaultMargin/2,
                                           width: changeVideoScaleBtnHeight, height: changeVideoScaleBtnHeight)
        
        expiredTimeLabel.frame = CGRect(x: defaultMargin/2, 
                                      y:sliderLabel.frame.origin.y + defaultMargin,
                                      width: expiredTimeLblWidth + 10, height: expiredTimeLblHeight)
        
        durationLabel.frame = CGRect(x: UIScreen.main.bounds.width - duratiponLblWidth - changeVideoScaleBtnHeight - 2*defaultMargin,
                                   y: sliderLabel.frame.origin.y + defaultMargin,
                                   width: duratiponLblWidth, height: expiredTimeLblHeight)
        
        self.adaptiveButton.frame = CGRect(x: playerContainer.frame.width - adaptiveWidth - defaultMargin,
                                        y: 4*defaultMargin,
                                        width: adaptiveWidth, height: adaptiveHeight)
        
        videoScaleButton.setBackgroundImage(UIImage(named: "enlarge"), for: .normal)
        minimizeButton.setImage(UIImage(named: "dismiss"), for: .normal)
        
        self.playButton.frame = CGRect(x: (playerLayer.frame.size.width)/2,
                                    y:(playerLayer.frame.size.height)/2 ,
                                    width: playBtnHeight, height: playBtnHeight)
        
        slider.isHidden = false
        sliderLabel.isHidden = false
        expiredTimeLabel.isHidden = false
        durationLabel.isHidden = false
    }
    
    @objc
    func changeVideoOrientation(_ sender: Any) {
        if isVideoLandScape == false {
            landScapeMode()
        } else {
            portraitMode()
        }
    }
    
    @objc
    func handleHideContainerBtn(){
        if isContainerVisible == true {
            hidePlayerButtonsOnPlay()
        } else {
            unhidePlayerButtonOnTap()
        }
    }
    
    @objc
    func playerTappedToMaximize(sender:UITapGestureRecognizer){
        guard isVideoMinimize == true else {
            if isContainerVisible == true {
                hidePlayerButtonsOnPlay()
            } else {
                unhidePlayerButtonOnTap()
            }
            return
        }
        maximizeView()
    }
    
    func maximizeView() {
        isVideoMinimize = false
        self.playerContainer.backgroundColor = UIColor.black
        self.state = .fullScreen
        let factor: CGFloat = 1 - 0.2649
        self.swipeToMinimize(translation: factor, toState: .fullScreen)
        self.didEndedSwipe(toState: self.state)
        self.animate()
        adaptiveButton.isUserInteractionEnabled = true
        if isContainerVisible == true {
            self.minimizeButton.isHidden = false
            self.slider.isHidden = false
            self.durationLabel.isHidden = false
            self.expiredTimeLabel.isHidden = false
            self.adaptiveButton.isHidden = false
            self.videoScaleButton.isHidden = false
        }
    }
    
    @objc
    func playButtonPressed(_ sender: Any) {
        if player.rate == 0 {
            let seconds : Float64 = CMTimeGetSeconds((player.currentItem?.asset.duration)!)
            if self.expiredTimeLabel.text == String(format: "\(seconds.format(using: [.hour, .minute, .second])!)") {
                playerLayer.player?.seek(to: .zero)
                playButton.setImage(UIImage(named: "pause"), for: .normal)
                playerLayer.player?.play()
                hidePlayerButtonsOnPlay()
                return
            }
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            playerLayer.player?.play()
            hidePlayerButtonsOnPlay()
        } else {
            playButton.setImage(UIImage(named: "play"), for: .normal)
            playerLayer.player?.pause()
            unhidePlayerButtonOnTap()
        }
    }
    
    @objc
    func minimizePlayer() {
        if UIDevice.current.userInterfaceIdiom == .pad{// || player == nil{
            playerLayer.player?.pause()
            killTimer()
            return
        }
        minimizeButton.setImage(UIImage(named: "dismiss"), for: .normal)
        gestureLabel.isUserInteractionEnabled = true
        playerLabel.isHidden = true
        playerLabel.isUserInteractionEnabled = false
        adaptiveButton.isUserInteractionEnabled = false
        
        isVideoMinimize = true
        self.direction = .up
        var finalState = stateOfVC.fullScreen
        let factor: CGFloat = 0.0009
        changeValues(scaleFactor: factor)
        
        finalState = .minimized
        self.state = finalState
        animate()
        didEndedSwipe(toState: self.state)
        
        
        self.minimizeButton.isHidden = true
        self.slider.isHidden = true
        self.durationLabel.isHidden = true
        self.expiredTimeLabel.isHidden = true
        self.adaptiveButton.isHidden = true
        self.videoScaleButton.isHidden = true
        self.backgroundColor = UIColor.clear
        self.playerContainer.backgroundColor = UIColor.black// UIColor.clear
    }
    
    @objc
    func minimizeBtnPlayerTapped(_ sender: Any) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            playerLayer.player?.pause()
            killTimer()
            return
        }
        if isVideoLandScape == true{
            portraitMode()
            return
        }
        minimizePlayer()
    }
    
    @objc
    func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player.seek(to: targetTime)
        sliderChangedValue = CGFloat(playbackSlider.value)
        print("=======================%@",cashedTime)
        if player.rate == 0
        {
            player.play()
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            hidePlayerButtonsOnPlay()
        }
    }
    
    @objc
    func handlePanGesture(sender:UIPanGestureRecognizer) {
        if  isVideoLandScape == true {
            return
        }
        if sender.state == .began {
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
                self.direction = .up
            } else {
                self.direction = .left
            }
        }
        var finalState = stateOfVC.fullScreen
        switch self.state {
        case .fullScreen:
            isVideoMinimize = true
            self.backgroundColor = UIColor.clear
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            changeValues(scaleFactor: factor)
            swipeToMinimize(translation: factor, toState: .minimized)
            finalState = .minimized
            adaptiveButton.isUserInteractionEnabled = false
            
        case .minimized:
            isVideoMinimize = true
            if self.direction == .left {
                finalState = .hidden
                let factor: CGFloat = sender.translation(in: nil).x
                self.swipeToMinimize(translation: factor, toState: .hidden)
                adaptiveButton.isUserInteractionEnabled = false
            } else {
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
                self.swipeToMinimize(translation: factor, toState: .fullScreen)
                self.minimizeButton.isHidden = false
                self.slider.isHidden = false
                self.durationLabel.isHidden = false
                self.expiredTimeLabel.isHidden = false
                
                isVideoMinimize = false
                adaptiveButton.isUserInteractionEnabled = true
            }
        default: break
        }
        
        if sender.state == .ended {
            self.state = finalState
            animate()
            didEndedSwipe(toState: self.state)
            if self.state == .hidden {
                self.playerLayer.player?.pause()
            }
        }
    }
    
    func changeValues(scaleFactor: CGFloat) {
        let scale = CGAffineTransform.init(scaleX: (1 - 0.5 * scaleFactor), y: (1 - 0.5 * scaleFactor))
        let trasform = scale.concatenating(CGAffineTransform.init(translationX: -(self.bounds.width / 4 * scaleFactor), y: -(self.bounds.height / 4 * scaleFactor)))
        self.transform = trasform
    }
    
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC) {
        switch toState {
        case .fullScreen:
            self.playerContainer.backgroundColor = UIColor.black
            self.frame.origin = positionDuringSwipe(scaleFactor: translation)
        case .hidden:
            self.frame.origin.x = UIScreen.main.bounds.width/2 - abs(translation) - 10
            playerLayer.player?.pause()
            killTimer()
        case .minimized:
            self.playerContainer.backgroundColor = UIColor.black
            self.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
            self.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        }
    }
    
    func didEndedSwipe(toState: stateOfVC) {
        animatePlayView(toState: toState)
    }
    
    func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
        let height = width * 9 / 16
        let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
        let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }
    
    func animatePlayView(toState: stateOfVC) {
        switch toState {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.beginFromCurrentState], animations: {
                self.frame.origin = self.fullScreenOrigin
                self.playerLayer.frame.origin = CGPoint(x: 0, y: 0)
                self.backgroundColor = .black
                
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.frame.origin = self.minimizedOrigin!
                self.playerLayer.frame.origin = CGPoint(x: 0, y: -20)
            })
        case .hidden:
            UIView.animate(withDuration: 0.3, delay: 0, options: .allowAnimatedContent, animations: {
                self.frame.origin = self.hiddenOrigin
            }, completion: { (completedAnimation) in
                self.removeFromSuperview()
            })
        }
    }
    
    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    
    let fullScreenOrigin = CGPoint.init(x: 0, y: 0)
    
    func animate()  {
        switch self.state {
        case .fullScreen:
            UIView.animate(withDuration: 0 , animations: {
                
                self.transform = CGAffineTransform.identity
                //  UIApplication.shared.isStatusBarHidden = true
            })
        case .minimized:
            UIView.animate(withDuration: 0 , animations: {
                // UIApplication.shared.isStatusBarHidden = false
                let scale = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                let trasform = scale.concatenating(CGAffineTransform.init(translationX: -self.bounds.width/4, y: -self.bounds.height/4))
                self.transform = trasform
            })
        default: break
        }
    }
    
    func addNewLink(tmpLink : String , isLandScape: Bool , buttonTitle: String) {
        playerLayer.player?.pause()
        adaptiveButton.isHidden = false
        adaptiveButton.setTitle(buttonTitle, for: UIControl.State.normal)
        
        link = tmpLink
    }
    
    @objc
    func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        var pointTapped: CGPoint = gestureRecognizer.location(in: self)
        pointTapped.x -= 0  //30Subtract left constraint (distance of the slider's origin from "self.view"
        
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        
        //If tap is too near from the slider thumb, cancel
        let thumbPosition = CGFloat((slider.value / slider.maximumValue)) * widthOfSlider
        let dif = abs(pointTapped.x - thumbPosition)
        let minDistance: CGFloat = 51.0  //You can calibrate this value, but I think this is the maximum distance that tap is recognized
        if dif < minDistance {
            // return
        }
        var newValue: CGFloat
        if pointTapped.x < 10 {
            newValue = 0  //Easier to set slider to 0
        } else {
            newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider)
        }
        
        slider.setValue(Float(newValue), animated: true)
        self.expiredTimeLabel.text = String(format: "\(Float64(newValue).format(using: [.hour, .minute, .second])!)")
        let targetTime:CMTime = CMTimeMake(value: Int64(newValue), timescale: 1)
        
        let seconds : Float64 = CMTimeGetSeconds((player.currentItem?.asset.duration)!)
        if expiredTimeLabel.text == String(format: "\(seconds.format(using: [.hour, .minute, .second])!)") {
            self.playButton.setImage(UIImage(named: "retry"), for: .normal)
        }
        player.seek(to: targetTime)
        // cashedTime = newValue - cashedTime
        print("=======================%@",cashedTime)
        sliderChangedValue = newValue
        if player.rate == 0 {
            player.play()
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            hidePlayerButtonsOnPlay()
        }
    }
    
    func hidePlayerButtonsOnPlay() {
        if self.player.rate == 0 {
            return
        }
        
        isContainerVisible = false
        self.playButton.isHidden = true
        self.minimizeButton.isHidden = true
        self.adaptiveButton.isHidden = true
        self.slider.isHidden = true
        self.sliderLabel.isHidden = true
        self.expiredTimeLabel.isHidden = true
        self.durationLabel.isHidden = true
        self.videoScaleButton.isHidden = true
    }
    
    func unhidePlayerButtonOnTap() {
        isContainerVisible = true
        self.playButton.isHidden = false
        self.minimizeButton.isHidden = false
        self.adaptiveButton.isHidden = false
        self.slider.isHidden = false
        self.sliderLabel.isHidden = false
        self.expiredTimeLabel.isHidden = false
        self.durationLabel.isHidden = false
        self.videoScaleButton.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.hidePlayerButtonsOnPlay()
        }
    }
    
    //CounterTimer functions implementation
    func killTimer() {
        counterTimer?.invalidate()
        counterTimer = nil
    }
    
    @objc func prozessTimer() {
        counter += 1
    }
    
}

// MARK : TimeInterval extension
extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        if self .isNaN {
            print("isNan")
            return " "
        }
        return formatter.string(from: self)
    }
}
