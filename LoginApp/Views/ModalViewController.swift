//
//  ModalViewController.swift
//

import UIKit

class ModalViewController: UIViewController {
    
    var containerView: UIView? {
        didSet {
            self.view.layoutIfNeeded()
        }
    }
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let maximumContainerHeight: CGFloat = 500
    private let defaultContainerHeight: CGFloat = 400
    private let minimumContainerHeight: CGFloat = 200
    private var currentContainerHeight: CGFloat = 400
    
    private var bottomConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if containerView == nil { containerView = UIView() }
        
        containerView!.backgroundColor = AppConfig.backgroundColor
        containerView!.layer.cornerRadius = 15
        containerView!.clipsToBounds = true
        containerView!.translatesAutoresizingMaskIntoConstraints = false
        
        setupView()
        setupLayout()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateDimmedView()
        animateContainerView()
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        
        view.addSubview(dimmedView)
        view.addSubview(containerView!)
    }
    
    private func setupLayout() {
        dimmedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        containerView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        bottomConstraint = containerView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultContainerHeight)
        heightConstraint = containerView!.heightAnchor.constraint(equalToConstant: defaultContainerHeight)
        bottomConstraint?.isActive = true
        heightConstraint?.isActive = true
    }
    
    func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanAction(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapAction(gesture:)))
        self.dimmedView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTapAction(gesture: UITapGestureRecognizer) {
        animateDismissView()
    }
    
    @objc
    func handlePanAction(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                heightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < minimumContainerHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultContainerHeight {
                animateContainerHeight(defaultContainerHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultContainerHeight)
            }
            else if newHeight > defaultContainerHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
            
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.heightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        
        currentContainerHeight = height
    }
    
    func animateContainerView() {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0.5
        }
    }
    
    func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint?.constant = self.defaultContainerHeight
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(
            withDuration: 0.4,
            animations: { self.dimmedView.alpha = 0 },
            completion: { _ in self.dismiss(animated: false) }
        )
    }
    
}
