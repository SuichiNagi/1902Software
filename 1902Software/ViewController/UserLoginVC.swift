//
//  ViewController.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import UIKit
import SnapKit

class UserLoginVC: UIViewController {
    let userService = UserService()
    let networkManager = NetworkManager.shared
    var loginModel: LoginModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @objc func loginUser() {
        let isAllFieldsEmpty = checkAllFieldsEmpty()
        guard !isAllFieldsEmpty else {
            print("empty")
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
                
                DispatchQueue.main.async {
                    let listVC = PostListVC()
                    listVC.username = self.usernameTextField.text!
                    self.navigationController?.pushViewController(listVC, animated: true)
                }
            case .failure(let error):
                print("Error logging in user: \(error)")
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
    
    
    func checkAllFieldsEmpty() -> Bool {
        // Check if all fields are empty
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // Return true if all fields are empty, false otherwise
        return username.isEmpty || password.isEmpty
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
        
        view.addSubview(buttonLogin)
        buttonLogin.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
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
        return passwordTextFieldTextField
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
    
    @objc func goSignUp() {
        print("Hey")
        let signUpVC = SignUpVC()
        
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

