//
//  ViewController.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import UIKit
import SnapKit

class UserLoginVC: UIViewController, UITextFieldDelegate {
    let userService = UserService()
    let networkManager = NetworkManager.shared
//    var loginModel: LoginModel!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        retrieveSavedCredentials()
    }
    
    @objc func loginUser() {
        let isAllFieldsEmpty = checkAllFieldsEmpty()
        guard !isAllFieldsEmpty else {
            presentSWAlertOnMainThread(title: "Invalid", message: "Please enter you username and password", buttonTitle: "Ok")
            return
        }
        
        showLoadingView()
        
        userService.loginUser(username: usernameTextField.text!, password: passwordTextField.text!) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let authResponse):
                print("User logged in successfully")
                print("Response: \(authResponse)")
                
                userService.setAuthResponse(authResponse)
                AuthService.shared.saveLoginDetails(token: authResponse.token, rememberMe: stayLoginCheckbox.isChecked)
                
                DispatchQueue.main.async {
                    let listVC = PostListVC()
                    listVC.username = self.usernameTextField.text!
                    self.navigationController?.setViewControllers([listVC], animated: true)
                    
                    self.resetField()
                }
            case .failure(let error):
                print("Error logging in user: \(error)")
                presentSWAlertOnMainThread(title: "Invalid", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        
//        networkManager.loginUser(username: usernameTextField.text!, password: passwordTextField.text!) { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let authResponse):
//                    print("User logged in successfully")
//                    print("Response: \(authResponse)")
//                    self.networkManager.setAuthResponse(authResponse.token)
//                    let listVC = PostListVC()
//                    listVC.username = self.usernameTextField.text!
//                    self.navigationController?.pushViewController(listVC, animated: true)
//                case .failure(let error):
//                    print("Error logging in user: \(error)")
//                }
//            }
//        }
    }
    
    func resetField() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    func checkAllFieldsEmpty() -> Bool {
        // Check if all fields are empty
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // Return true if all fields are empty, false otherwise
        return username.isEmpty || password.isEmpty
    }
    
    //save credentials when remember me is checked / remove credentials when remember is unchecked
    @objc func rememberMecheckAndUncheck(_ sender: SWCheckbox) {
        rememberMeCheckbox.buttonClicked(sender: sender)
        
        if rememberMeCheckbox.isChecked {
            saveCredentials()
        } else {
            clearCredentials()
        }
    }
    
    @objc func stayLogincheckAndUncheck(_ sender: SWCheckbox) {
        stayLoginCheckbox.buttonClicked(sender: sender)
    }
    
    //retrieve credentials
    func retrieveSavedCredentials() {
        if let savedUsername = defaults.string(forKey: "savedUsername"),
           let savedPassword = defaults.string(forKey: "savedPassword") {
            usernameTextField.text = savedUsername
            passwordTextField.text = savedPassword
            rememberMeCheckbox.isChecked = true
        }
    }
    
    //save credentials
    func saveCredentials() {
        defaults.set(usernameTextField.text, forKey: "savedUsername")
        defaults.set(passwordTextField.text, forKey: "savedPassword")
    }
    
    //remove credentials
    func clearCredentials() {
        defaults.removeObject(forKey: "savedUsername")
        defaults.removeObject(forKey: "savePassword")
    }
    
    //if remember me is checked it automatically save updated credentials when user update username or password
    @objc func textFieldDidChange() {
        if rememberMeCheckbox.isChecked {
            saveCredentials()
        } else {
            clearCredentials()
        }
    }
    
    @objc func goSignUp() {
        let signUpVC = SignUpVC()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func setUI () {
        let padding: CGFloat = 50
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.height.width.equalTo(125)
        }
        
        view.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageLogo.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(padding)
        }
        
        view.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(padding)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        view.addSubview(rememberMeCheckbox)
        rememberMeCheckbox.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(padding)
        }
        
        view.addSubview(rememberMeLabel)
        rememberMeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rememberMeCheckbox)
            make.leading.equalTo(rememberMeCheckbox.snp.trailing).offset(5)
        }
        
        view.addSubview(stayLoginCheckbox)
        stayLoginCheckbox.snp.makeConstraints { make in
            make.top.equalTo(rememberMeCheckbox.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(padding)
        }
        
        view.addSubview(stayLoginLabel)
        stayLoginLabel.snp.makeConstraints { make in
            make.centerY.equalTo(stayLoginCheckbox)
            make.leading.equalTo(stayLoginCheckbox.snp.trailing).offset(5)
        }
        
        view.addSubview(buttonLogin)
        buttonLogin.snp.makeConstraints { make in
            make.top.equalTo(stayLoginCheckbox.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        view.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(buttonLogin.snp.bottom).offset(80)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.height.equalTo(30)
        }
        
        view.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomContainer)
            make.right.equalTo(bottomContainer.snp.centerX).offset(-1)
        }
        
        view.addSubview(createAccountLabel)
        createAccountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomContainer)
            make.left.equalTo(bottomContainer.snp.centerX).offset(1)
        }
    }
    
    lazy var imageLogo: UIImageView = {
        let imageLogo = UIImageView()
        imageLogo.image = UIImage(named: "logo-1902")
        imageLogo.translatesAutoresizingMaskIntoConstraints = false
        return imageLogo
    }()
    
    
    lazy var usernameLabel: SWTitleLabel = {
        let usernameLabel = SWTitleLabel(textAlignment: .center, fontSize: 13)
        usernameLabel.text = "USERNAME"
        return usernameLabel
    }()
    
    lazy var usernameTextField: SWTextField = {
        let usernameTextField = SWTextField(underLineColor: .secondaryLabel)
        usernameTextField.delegate = self
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return usernameTextField
    }()
    
    lazy var passwordLabel: SWTitleLabel = {
        let passwordLabel = SWTitleLabel(textAlignment: .center, fontSize: 13)
        passwordLabel.text = "PASSWORD"
        return passwordLabel
    }()
    
    lazy var passwordTextField: SWTextField = {
        let passwordTextFieldTextField = SWTextField(underLineColor: .secondaryLabel)
        passwordTextFieldTextField.isSecureTextEntry = true
        passwordTextFieldTextField.delegate = self
        passwordTextFieldTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return passwordTextFieldTextField
    }()
    
    lazy var rememberMeCheckbox: SWCheckbox = {
        let checkbox = SWCheckbox()
        checkbox.isChecked = false
        checkbox.addTarget(self, action: #selector(rememberMecheckAndUncheck(_:)), for: .touchUpInside)
        return checkbox
    }()
    
    lazy var rememberMeLabel: SWTitleLabel = {
        let rememberMeLabel = SWTitleLabel(textAlignment: .left, fontSize: 13)
        rememberMeLabel.text = "Remember me"
        rememberMeLabel.textColor = .systemGreen
        return rememberMeLabel
    }()
    
    lazy var stayLoginCheckbox: SWCheckbox = {
        let checkbox = SWCheckbox()
        checkbox.isChecked = false
        checkbox.addTarget(self, action: #selector(stayLogincheckAndUncheck(_:)), for: .touchUpInside)
        return checkbox
    }()
    
    lazy var stayLoginLabel: SWTitleLabel = {
        let stayLoginLabel = SWTitleLabel(textAlignment: .left, fontSize: 13)
        stayLoginLabel.text = "Stay logged in"
        stayLoginLabel.textColor = .systemGreen
        return stayLoginLabel
    }()
    
    lazy var buttonLogin: SWButton = {
        let buttonLogin = SWButton(backgroundColor: .white, title: "LOG IN")
        buttonLogin.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        return buttonLogin
    }()
    
    lazy var bottomContainer: UIView = {
        let bottomContainer = UIView()
        return bottomContainer
    }()
    
    lazy var bottomLabel: SWTitleLabel = {
        let bottomLabel = SWTitleLabel(textAlignment: .center, fontSize: 18)
        bottomLabel.text = "Not a member?"
        return bottomLabel
    }()
    
    lazy var createAccountLabel: SWTitleLabel = {
        let createAccountLabel = SWTitleLabel(textAlignment: .center, fontSize: 18)
        createAccountLabel.text = "Create an account"
        createAccountLabel.textColor = .systemGreen
        let attributedString = NSMutableAttributedString(string: createAccountLabel.text ?? "")
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        createAccountLabel.attributedText = attributedString
        createAccountLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(goSignUp))
        createAccountLabel.addGestureRecognizer(tap)
        return createAccountLabel
    }()
}

