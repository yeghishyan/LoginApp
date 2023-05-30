//
//  MainMenuViewController.swift
//

import UIKit
import AVKit

class MainViewController: UIViewController {
    
    var mainViewModel: MainViewModel!
    
    private lazy var movieTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
        //view.bounces = false
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 350
        view.register(MovieTableCell.self, forCellReuseIdentifier: MovieTableCell.reuseIdentifier)
        view.register(MovieTableHeader.self, forHeaderFooterViewReuseIdentifier: MovieTableHeader.reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var group: DispatchGroup = {
        let group = DispatchGroup()
        return group
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
        
        setupViewController()
        setupView()
        
        updateView()
    }
    
    private func setupViewController() {
        let logOutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutPressed))
        self.navigationItem.rightBarButtonItem = logOutButton
        
        let label = UILabel()
        label.text = "Main View"
        label.textAlignment = .center
        self.navigationItem.titleView = label
        
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupView() {
        self.view.addSubview(movieTableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        movieTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        movieTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        movieTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        movieTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 10).isActive = true
    }
    
    private func fetchMovies() {
        self.group.enter()
        MovieAPI.shared.topSuggestions(page: self.mainViewModel.page) { movies, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let movies = movies {
                let data = movies.filter { $0.path != nil && $0.rating != 0 }
                self.mainViewModel.movies.append(contentsOf: data)
                self.mainViewModel.page += 1
            }
            self.group.leave()
        }
    }
    
    private func updateView() {
        group.notify(queue: .main, execute: {
            print("update table view: " + #function)
            self.movieTableView.reloadData()
            self.movieTableView.invalidateIntrinsicContentSize()
        })
    }
}

extension MainViewController {
    @objc
    private func logOutPressed(_ sender: UIButton) {
        self.mainViewModel?.logOut()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: false, completion: nil)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("MainView rows_in_section: " + #function)
        return 1 // TODO
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableCell.reuseIdentifier, for: indexPath) as? MovieTableCell else { return UITableViewCell() }
        cell.movies = mainViewModel.movies
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MovieTableHeader.reuseIdentifier) as? MovieTableHeader else { return UIView() }
        return header
    }
}
