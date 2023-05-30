//
//  HomeHeader.swift
//

import UIKit

class HomeHeader: UICollectionReusableView {
    private lazy var movieLabel: UILabel = {
        let label = UILabel()
        label.text = "New releases"
        label.textColor = .black
        label.font = .systemFont(ofSize: 25, weight: .init(0.3))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "clapperboard")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        button.layer.cornerRadius = 18
        button.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.searchPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var moviesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = AppConfig.backgroundColor
        collection.isScrollEnabled = true
        //collection.alwaysBounceHorizontal = true
        collection.isDirectionalLockEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    //var delegate: SearchDelegate
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let views = [movieImageView, movieLabel, searchButton, moviesCollection]
        views.forEach { view in
            self.addSubview(view)
        }
        
        let constraints = [
            movieLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            movieLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 5),
            
            movieImageView.centerYAnchor.constraint(equalTo: movieLabel.centerYAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            movieImageView.widthAnchor.constraint(equalToConstant: 20),
            movieImageView.heightAnchor.constraint(equalToConstant: 20),
            
            searchButton.centerYAnchor.constraint(equalTo: movieLabel.centerYAnchor, constant: 0),
            searchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            searchButton.widthAnchor.constraint(equalToConstant: 35),
            searchButton.heightAnchor.constraint(equalToConstant: 35),
            
            moviesCollection.topAnchor.constraint(equalTo: movieLabel.bottomAnchor, constant: 10),
            moviesCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            moviesCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            moviesCollection.heightAnchor.constraint(equalToConstant: self.bounds.width*2/3*1.48),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }    
}

extension HomeHeader {
    @objc
    func searchPressed(_ sender: UIButton) {
        //TODO
    }
}
