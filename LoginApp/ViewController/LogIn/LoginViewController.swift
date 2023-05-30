//
//  LoginMenuViewController.swift
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginViewModel: LoginViewModel?
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 55, weight: .thin)
        label.textColor = AppConfig.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginTextField: NeumorphicTextField = {
        let textField = NeumorphicTextField()
        textField.placeholder = "Enter login"
        textField.setLeftIcon(UIImage(named: "person"))
        textField.delegate = self;
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: NeumorphicTextField = {
        let textField = NeumorphicTextField()
        textField.placeholder = "Enter password"
        textField.setLeftIcon(UIImage(named: "password"))
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    private lazy var loginButton: NeumorphicButton = {
        let button = NeumorphicButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(self.loginPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot your password?", for: .normal)
        button.setTitleColor(AppConfig.textColor, for: .normal)
        button.addTarget(self, action: #selector(self.forgotPasswordPressed), for: .touchUpInside)
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
    
    private lazy var dontAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Don`t have account?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.textColor = AppConfig.textColor
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(AppConfig.textColor, for: .normal)
        button.addTarget(self, action: #selector(self.signupPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgotPasswordViewController: UIViewController = {
        let viewController = ForgotPasswordViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        return viewController;
    }()
    
    //    private lazy var backgroundImageView: UIImageView = {
    //        let imageView = UIImageView(frame: .zero)
    //        imageView.image = UIImage(named: "backgroundImage")
    //        imageView.contentMode = .scaleToFill
    //        return imageView
    //    }()
    
    private lazy var loginTextFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var loginButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var signUpStackView: UIStackView = {
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
        
        setupViewController()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupViewController() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupHierarchy() {
        //view.addSubview(backgroundImageView)
        view.addSubview(loginLabel)
        view.addSubview(loginStackView)
        view.addSubview(line)
        view.addSubview(signUpStackView)
        
        //view.addSubview(connectLabel)
        
        loginTextFieldStackView.addArrangedSubview(loginTextField)
        loginTextFieldStackView.addArrangedSubview(passwordTextField)
        loginButtonStackView.addArrangedSubview(loginButton)
        loginButtonStackView.addArrangedSubview(forgotPasswordButton)
        loginStackView.addArrangedSubview(loginTextFieldStackView)
        loginStackView.addArrangedSubview(loginButtonStackView)
        
        signUpStackView.addArrangedSubview(dontAccountLabel)
        signUpStackView.addArrangedSubview(signUpButton)
    }
    
    private func setupLayout() {
        //        backgroundImageView.bottomAnchor.constraint(equalTO: view.bottomAnchor).isActive = true
        //        backgroundImageView.top.constraint(equalTO: view.topAnchor).isActive = true
        //        backgroundImageView.left.constraint(equalTO: view.leftAnchor).isActive = true
        //        backgroundImageView.right.constraint(equalTO: view.rightAnchor).isActive = true
        let safeArea = view.safeAreaLayoutGuide;
        
        loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginLabel.bottomAnchor.constraint(equalTo: loginStackView.topAnchor, constant: -90).isActive = true
        
        loginTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        loginStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        loginStackView.leadingAnchor.constraint(equalTo:  safeArea.leadingAnchor, constant: 30).isActive = true
        loginStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30).isActive = true
        
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30).isActive = true
        line.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30).isActive = true
        line.bottomAnchor.constraint(equalTo: signUpStackView.topAnchor, constant: -10).isActive = true
        
        signUpStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
}

extension LoginViewController {
    @objc
    private func loginPressed(_ sender: UIButton) {
        guard let username = loginTextField.text, let password = passwordTextField.text else { return }
        
        self.loginViewModel?.authenticate(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let accesToken):
                //self?.showAlert(message: accesToken!)
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
    private func signupPressed(_ sender: UIButton) {
        loginViewModel?.signup()
    }
    
    @objc
    private func forgotPasswordPressed(_ sender: UIButton) {
        self.present(forgotPasswordViewController, animated: false)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField === loginTextField) {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.textColor = (loginViewModel?.isValidUsername(newString))! ? AppConfig.textColor : UIColor.red
        }
        return true;
    }
}
