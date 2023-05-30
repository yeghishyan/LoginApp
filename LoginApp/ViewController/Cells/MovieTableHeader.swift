//
//  MovieTableHeader.swift
//

import UIKit
import AVKit

class MovieTableHeader: UITableViewHeaderFooterView {
    
    private var videoPlayer: VideoPlayer = {
        let videoPlayer = VideoPlayer()
        videoPlayer.videoAssets = [
            AVURLAsset(url: Bundle.main.url(forResource: "oppenheimer", withExtension: "mp4")!)
        ]
        
        videoPlayer.videoURLs = [
            //URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_5MB.mp4")!,
        ]
        videoPlayer.translatesAutoresizingMaskIntoConstraints = false
        return videoPlayer
    }()
    
    lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Popular"
        label.backgroundColor = .clear
        label.textColor = AppConfig.textColor
        label.font = .systemFont(ofSize: 25, weight: .init(0.3))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "popular")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        self.addSubview(videoPlayer)
        self.addSubview(headerImageView)
        self.addSubview(headerTitle)
        
        let mp: CGFloat = 1
        
        NSLayoutConstraint.activate([
            videoPlayer.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            videoPlayer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: mp),
            videoPlayer.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: (9/16)*mp),
            videoPlayer.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            headerImageView.centerYAnchor.constraint(equalTo: headerTitle.centerYAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            headerImageView.widthAnchor.constraint(equalToConstant: 20),
            headerImageView.heightAnchor.constraint(equalToConstant: 20),
            
            headerTitle.topAnchor.constraint(equalTo: videoPlayer.bottomAnchor, constant: 10),
            headerTitle.leadingAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: 5),
        ])
    }
}
