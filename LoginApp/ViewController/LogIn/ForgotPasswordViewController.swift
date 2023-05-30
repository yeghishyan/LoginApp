//
//  ForgotPasswordView.swift
//

import UIKit

class ForgotPasswordViewController: ModalViewController {
    private enum PageState: Int {
        case EmailState = 0
        case CodeState = 1
        case ResetState = 2
    }
    
    private var currentState: PageState = .EmailState
    
    private let titles = ["Forgot password", "Enter 4 Digit Code", "Reset Password"]
    
    private let descriptions = [
        "Enter your email for the verification process we will send 4 digits code to your email.",
        "Enter 4 digits code that you received on your email.",
        "Set the new password for your account so you can access all the features.",]
    private let lableName = ["Email", "", "Password"]
    private let buttonName = ["Continue", "Continue", "Reset Password"]
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titles[0]
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = AppConfig.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = descriptions[0]
        //label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppConfig.subTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var continueButton: NeumorphicButton = {
        let button = NeumorphicButton(type: .system)
        button.setTitle(buttonName[0], for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(AppConfig.textColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var textFieldLable: UILabel = {
        let label = UILabel()
        label.text = lableName[0]
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = AppConfig.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextField: NeumorphicTextField = {
        let textField = NeumorphicTextField()
        textField.placeholder = "email"
        textField.setLeftIcon(UIImage(named: "email"))
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: NeumorphicTextField = {
        let textField = NeumorphicTextField()
        textField.placeholder = "password"
        textField.setLeftIcon(UIImage(named: "password"))
        textField.isSecureTextEntry = true
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        return textField
    }()
    
    private lazy var pinCodeField: PinCodeField = {
        let view = PinCodeField()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        containerView = UIView()
        
        setupView()
        setupLayout()
        super.viewDidLoad()
    }
    
    private func setupView() {
        containerView!.addSubview(titleStackView)
        containerView!.addSubview(inputStackView)
        containerView!.addSubview(continueButton)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(descriptionLabel)
        
        inputStackView.addArrangedSubview(textFieldLable)
        inputStackView.addArrangedSubview(passwordTextField)
        inputStackView.addArrangedSubview(emailTextField)
        inputStackView.addArrangedSubview(pinCodeField)
        
        currentState = .EmailState
        switchPage()
    }
    
    private func setupLayout() {
        let safeArea = containerView!.safeAreaLayoutGuide
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pinCodeField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        titleStackView.topAnchor.constraint(equalTo:  safeArea.topAnchor, constant: 30).isActive = true
        titleStackView.leadingAnchor.constraint(equalTo:  safeArea.leadingAnchor, constant: 30).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo:  safeArea.trailingAnchor, constant: -30).isActive = true
        
        inputStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 40).isActive = true
        inputStackView.leadingAnchor.constraint(equalTo:  safeArea.leadingAnchor, constant: 30).isActive = true
        inputStackView.trailingAnchor.constraint(equalTo:  safeArea.trailingAnchor, constant: -30).isActive = true
        
        continueButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
    }
    
    private func switchPage() {
        switch currentState {
        case .EmailState:
            emailTextField.isHidden = false
            pinCodeField.isHidden = true
            passwordTextField.isHidden = true
            
        case .CodeState:
            emailTextField.isHidden = true
            pinCodeField.isHidden = false
            passwordTextField.isHidden = true
            
        case .ResetState:
            emailTextField.isHidden = true
            pinCodeField.isHidden = true
            passwordTextField.isHidden = false
        }
        
        let index = currentState.rawValue
        titleLabel.text = titles[index]
        descriptionLabel.text = descriptions[index]
        textFieldLable.text = lableName[index]
        continueButton.setTitle(buttonName[index], for: .normal)
        
        //containerView!.layoutIfNeeded()
    }
}

extension ForgotPasswordViewController {
    @objc
    private func buttonPressed(_ sender: UIButton) {
        switch currentState {
        case .EmailState:
            print(emailTextField.text ?? "")
            currentState = .CodeState
            
        case .CodeState:
            print(pinCodeField.pinCode)
            currentState = .ResetState
            
        case .ResetState:
            print(passwordTextField.text ?? "")
            currentState = .EmailState
            self.animateDismissView()
        }
        
        self.switchPage()
    }
    
    @objc
    private func pinCodeDidChange(_ sender: UIButton) {
        
    }
}
