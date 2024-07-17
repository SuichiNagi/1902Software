//
//  SignUpVC.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import UIKit

class SignUpVC: UIViewController {
    
    let fontSize: CGFloat = 13
    
    var itemLabels: [UIView] = []
    var itemFields: [UIView] = []
    
    let userService = UserService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @objc func signUpUser() {
        let isAllFieldsEmpty = checkAllFieldsEmpty()
        guard !isAllFieldsEmpty else {
            print("empty")
            return
        }
        
        guard emailField.text!.isValidEmail else {
            print("invalid email")
            return
        }
        
        guard passwordField.text == repeatPasswordField.text else {
            print("invalid pass")
            return
        }
        
        showLoadingView()
        
        userService.registerUser(username: usernameField.text!, password: passwordField.text!, email: emailField.text!, name: fullnameField.text!) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.dismissLoadingView()
            }
            
            switch result {
            case .success(let success):
                print("Response: \(success)")
                DispatchQueue.main.async {
                    self.resetField()
                    self.backButtonTapped()
                }
                // Handle successful registration
            case .failure(let error):
                print("Error registering user: \(error)")
                // Handle error
            }
        }
        
//        NetworkManager.shared.registerUser(username: usernameField.text!, password: passwordField.text!, email: emailField.text!, name: fullnameField.text!) { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(let success):
//                print("Response: \(success)")
//                DispatchQueue.main.async {
//                    self.resetField()
//                }
//                // Handle successful registration
//            case .failure(let error):
//                print("Error registering user: \(error)")
//                // Handle error
//            }
//        }
    }
    
    func resetField() {
        fullnameField.text = ""
        usernameField.text = ""
        emailField.text = ""
        passwordField.text = ""
        repeatPasswordField.text = ""
    }
    
    func checkAllFieldsEmpty() -> Bool {
        // Check if all fields are empty
        let fullname = fullnameField.text ?? ""
        let email = emailField.text ?? ""
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        let repeatPassword = repeatPasswordField.text ?? ""
        
        // Return true if all fields are empty, false otherwise
        return fullname.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty || repeatPassword.isEmpty
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func setUI() {
        let backButton = UIBarButtonItem(image: UIImage(named: "ic-back"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        view.backgroundColor = .systemBackground
        
        let padding: CGFloat        = 50
        let topSpacing: CGFloat     = 10
        let bottomSpacing: CGFloat  = 30
        
        itemLabels = [fullnameLabel, emailLabel, usernameLabel, passwordLabel, repeatPasswordLabel]
        
        for itemLabel in itemLabels {
            view.addSubview(itemLabel)
            itemLabel.translatesAutoresizingMaskIntoConstraints = false
            
            itemLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(padding)
            }
        }
        
        itemFields = [fullnameField, emailField, usernameField, passwordField, repeatPasswordField]
        
        for itemField in itemFields {
            view.addSubview(itemField)
            itemField.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(padding)
                make.right.equalToSuperview().offset(-padding)
                make.height.equalTo(40)
            }
        }
        
        fullnameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
        }
        
        fullnameField.snp.makeConstraints { make in
            make.top.equalTo(fullnameLabel.snp.bottom).offset(topSpacing)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(fullnameField.snp.bottom).offset(bottomSpacing)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(topSpacing)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(bottomSpacing)
        }
        
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(topSpacing)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(bottomSpacing)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(topSpacing)
        }
        
        repeatPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(bottomSpacing)
        }
        
        repeatPasswordField.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordLabel.snp.bottom).offset(topSpacing)
        }
        
        view.addSubview(buttonSignUp)
        buttonSignUp.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordField.snp.bottom).offset(60)
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
    }

    lazy var fullnameLabel: SWTitleLabel = {
        let fullnameLabel = SWTitleLabel(textAlignment: .center, fontSize: fontSize)
        fullnameLabel.text = "FULL NAME"
        return fullnameLabel
    }()
    
    lazy var fullnameField: SWTextField = {
        let fullnameField = SWTextField(underLineColor: .secondaryLabel)
        return fullnameField
    }()
    
    lazy var emailLabel: SWTitleLabel = {
        let emailLabel = SWTitleLabel(textAlignment: .center, fontSize: fontSize)
        emailLabel.text = "EMAIL"
        return emailLabel
    }()
    
    lazy var emailField: SWTextField = {
        let emailField = SWTextField(underLineColor: .secondaryLabel)
        emailField.delegate = self
        return emailField
    }()
    
    lazy var usernameLabel: SWTitleLabel = {
        let usernameLabel = SWTitleLabel(textAlignment: .center, fontSize: fontSize)
        usernameLabel.text = "USERNAME"
        return usernameLabel
    }()
    
    lazy var usernameField: SWTextField = {
        let usernameField = SWTextField(underLineColor: .secondaryLabel)
        return usernameField
    }()
    
    lazy var passwordLabel: SWTitleLabel = {
        let passwordLabel = SWTitleLabel(textAlignment: .center, fontSize: fontSize)
        passwordLabel.text = "PASSWORD"
        return passwordLabel
    }()
    
    lazy var passwordField: SWTextField = {
        let passwordField = SWTextField(underLineColor: .secondaryLabel)
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    lazy var repeatPasswordLabel: SWTitleLabel = {
        let repeatPasswordLabel = SWTitleLabel(textAlignment: .center, fontSize: fontSize)
        repeatPasswordLabel.text = "REPEAT PASSWORD"
        return repeatPasswordLabel
    }()
    
    lazy var repeatPasswordField: SWTextField = {
        let repeatPasswordField = SWTextField(underLineColor: .secondaryLabel)
        repeatPasswordField.isSecureTextEntry = true
        return repeatPasswordField
    }()
    
    lazy var buttonSignUp: SWButton = {
        let buttonSignUp = SWButton(backgroundColor: .white, title: "SIGN UP")
        buttonSignUp.addTarget(self, action: #selector(signUpUser), for: .touchUpInside)
        return buttonSignUp
    }()
}

extension SignUpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Convert the replacement string to lowercase
        let lowercaseString = string.lowercased()
        
        // Update the text field's text with the lowercase version
        emailField.text?.replaceSubrange(Range(range, in: textField.text!)!, with: lowercaseString)
        
        // Return false because we are manually updating the text field's text
        return false
    }
}
