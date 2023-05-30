//
//  MovieCell.swift
//

import UIKit

let imagePrefix = "https://image.tmdb.org/t/p/w500"

class MovieCell: UICollectionViewCell {
    
    var fraction: CGFloat = 16
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            
            //titleLabel.text = movie.title
            ratingView.ratingLabel.text = String(movie.rating)
            isTop = (movie.rating >= 7)
            
            guard let url = movie.path else { return }
            imageView.loadFrom(URLAddress: imagePrefix + url)
            //imageView.image?.scalePreservingAspectRatio(targetSize: bounds.size)
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = self.bounds.height/fraction
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var ratingView: RatingView = {
        let view = RatingView()
        view.ratingLabel.textColor = .white
        view.imageView.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isTop: Bool? {
        didSet {
            guard let isTop = isTop else { return }
            if isTop {
                self.ratingView.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
            }
            else {
                self.ratingView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        //setupShadow()
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(imageView)
        imageView.addSubview(ratingView)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.bounds.width - 5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.bounds.height - 5).isActive = true
        
        let inset = bounds.size.width * 0.05
        ratingView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: inset).isActive = true
        ratingView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -inset).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setupShadow() {
        if AppConfig.darkTheme == false {
            self.layer.cornerRadius = self.bounds.height/fraction
            self.clipsToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize.zero
            self.layer.shadowRadius = 4
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16).cgPath
        }
    }
    
    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.cornerRadius = self.bounds.height/fraction
        gradient.colors = [
            UIColor.clear.cgColor,
            AppConfig.backgroundColor.withAlphaComponent(0.2).cgColor,
            AppConfig.backgroundColor.withAlphaComponent(0.4).cgColor,
            AppConfig.backgroundColor.withAlphaComponent(0.6).cgColor,
            AppConfig.backgroundColor.withAlphaComponent(0.8).cgColor,
            AppConfig.backgroundColor.withAlphaComponent(1).cgColor,
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.6)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        imageView.layer.insertSublayer(gradient, at: 0)
    }
}
