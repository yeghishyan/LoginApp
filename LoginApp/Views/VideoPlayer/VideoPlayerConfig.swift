//
//  VideoPlayerConfig.swift
//

import UIKit
import AVKit

struct VideoPlayerConfig {
    //let media:
    var shouldLoopVideo: Bool = false
    var shouldAutoPlay: Bool = false
    
    var forwardSeekDuration: CGFloat = 5.0
    var rewindSeekDuration: CGFloat = 5.0
    
    var videoGravity: AVLayerVideoGravity = .resize
    var fullScrrenVideoGravity: AVLayerVideoGravity = .resizeAspectFill
    
    var isFullScreenShouldAutoRotate: Bool = true
}
