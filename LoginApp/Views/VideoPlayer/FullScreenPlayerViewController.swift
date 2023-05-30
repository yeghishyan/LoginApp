//
//  FullScreenPlayer.swift
//

import AVKit

class FullScreenPlayerViewController: VideoPlayer {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //TODO
    }
    
    private func setupView() {
        //if let 
    }
}
