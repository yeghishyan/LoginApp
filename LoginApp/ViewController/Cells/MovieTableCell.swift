//
//  MovieDataSource.swift
//

import UIKit

class MovieTableCell: UITableViewCell {
    
    var movies: [Movie] = []
    var page: Int = 1
    
    private lazy var flowLayout: SnappingCollectionViewLayout = {
        let layout = SnappingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        return refreshControl
    }()
    
    private lazy var moviesCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = AppConfig.backgroundColor
        collectionView.bounces = true
        collectionView.decelerationRate = .fast
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell: MovieCell.self)
        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupShadow()
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let safeArea = self.safeAreaLayoutGuide
        self.backgroundColor = .clear
        self.addSubview(moviesCollection)
        
        let constraints = [
            moviesCollection.topAnchor.constraint(equalTo: safeArea.topAnchor),
            moviesCollection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            moviesCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            moviesCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupShadow() {
        if AppConfig.darkTheme == false {
            self.layer.cornerRadius = self.bounds.height/16
            self.clipsToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize.zero
            self.layer.shadowRadius = 4
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16).cgPath
        }
    }
    
    private func updateView() {
        print("updated MovieTableCell: " + #function)
        self.moviesCollection.reloadData()
    }
    
    @objc
    private func reloadData() {
        self.page = 1
        updateView()
        //self.movies.removeAll()
        //self.fetchMovies()
        ////self.getCategories()
        ////self.fetchByType()
        //self.updateView()
    }
    
}

extension MovieTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("MovieTableCell items_in_section: " + #function)
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("MovieTableCell cell_for_item: " + #function)
        guard let cell = collectionView.dequeue(for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        cell.movie = self.movies[indexPath.item]
        return cell
    }
}

extension MovieTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("MovieTableCell layout_size_of_item: " + #function)
        let width = collectionView.bounds.width
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width-spacing*(itemsPerRow+1)
        let itemDimension = floor(availableWidth/itemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension*7/5)
    }
}

