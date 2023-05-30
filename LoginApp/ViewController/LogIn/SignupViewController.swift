//
//  SignupViewController.swift
//

import UIKit

class SignupViewController: UIViewController {
    
    var signupViewModel: SignupViewModel?
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Getting Started"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 55, weight: .semibold)
        label.textColor = AppConfig.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: CustomStyleTextField = {
        let textField = CustomStyleTextField()
        textField.placeholder = "Full name"
        textField.setLeftIcon(UIImage(named: "fullname"))
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var emailTextField: CustomStyleTextField = {
        let textField = CustomStyleTextField()
        textField.placeholder = "Email"
        textField.setLeftIcon(UIImage(named: "email"))
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: CustomStyleTextField = {
        let textField = CustomStyleTextField()
        textField.placeholder = "Password"
        textField.setLeftIcon(UIImage(named: "key"))
        //textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var signupButton: NeumorphicButton = {
        let button = NeumorphicButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(AppConfig.textColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.signupPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.opacity = 0.3
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var alreadyHaveAccount: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.textColor = AppConfig.textColor
        return label
    }()
    
    private lazy var singinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(AppConfig.textColor, for: .normal)
        button.addTarget(self, action: #selector(self.signinPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    //    private lazy var backgroundImageView: UIImageView = {
    //        let imageView = UIImageView(frame: .zero)
    //        imageView.image = UIImage(named: "backgroundImage")
    //        imageView.contentMode = .scaleToFill
    //        return imageView
    //    }()
    
    private lazy var signupTextFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var signupStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppConfig.backgroundColor
        
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        //view.addSubview(backgroundImageView)
        view.addSubview(loginLabel)
        view.addSubview(signupStackView)
        view.addSubview(loginStackView)
        view.addSubview(line)
        
        signupTextFieldStackView.addArrangedSubview(nameTextField)
        signupTextFieldStackView.addArrangedSubview(emailTextField)
        signupTextFieldStackView.addArrangedSubview(passwordTextField)
        signupStackView.addArrangedSubview(signupTextFieldStackView)
        signupStackView.addArrangedSubview(signupButton)
        
        loginStackView.addArrangedSubview(alreadyHaveAccount)
        loginStackView.addArrangedSubview(singinButton)
    }
    
    private func setupLayout() {
        //        backgroundImageView.bottomAnchor.constraint(equalTO: view.bottomAnchor).isActive = true
        //        backgroundImageView.top.constraint(equalTO: view.topAnchor).isActive = true
        //        backgroundImageView.left.constraint(equalTO: view.leftAnchor).isActive = true
        //        backgroundImageView.right.constraint(equalTO: view.rightAnchor).isActive = true
        let safeArea = view.safeAreaLayoutGuide;
        
        loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginLabel.bottomAnchor.constraint(equalTo: signupStackView.topAnchor, constant: -90).isActive = true
        
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        signupStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        signupStackView.leadingAnchor.constraint(equalTo:  safeArea.leadingAnchor, constant: 30).isActive = true
        signupStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30).isActive = true
        
        loginStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30).isActive = true
        line.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30).isActive = true
        line.bottomAnchor.constraint(equalTo: loginStackView.topAnchor, constant: -10).isActive = true
    }
}

extension SignupViewController {
    @objc
    func signupPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        self.signupViewModel?.signup(username: email, password: password) { [weak self] result in
            switch result {
            case .success(let accesToken):
                print(accesToken!)
                
            case .failure(let error):
                switch error {
                case .invalidCredentials:
                    self?.showAlert(message: "Username or password is incorrect")
                case .validationError(let errorMessage):
                    self?.showAlert(message: errorMessage)
                case .serviceError(let serviceError):
                    self?.showAlert(message: serviceError?.localizedDescription ?? "")
                }
            }
        }
        
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    @objc
    func signinPressed(_ sender: UIButton) {
        signupViewModel?.signin()
    }
}
