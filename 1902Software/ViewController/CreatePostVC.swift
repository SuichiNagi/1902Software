//
//  CreatePostVC.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/9/24.
//

import UIKit

class CreatePostVC: UIViewController {
    
    weak var delegate: PostListVCDelegate!
    
    let userService = UserService()
    
    let fontSize: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    @objc func backMenu() {
        dismiss(animated: true)
    }
    
    @objc func saveFunc() {
        let isAllFieldsEmpty = checkAllFieldsEmpty()
        guard !isAllFieldsEmpty else {
            print("empty")
            return
        }
        
        userService.createPost(title: fullNameTextfield.text!, body: designationTextfield.text!) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.delegate.refreshPostList()
                DispatchQueue.main.async {
                    self.backMenu()
                }
                print("Post created successfully: \(success)")
            case .failure(let error):
                print("Failed to create post: \(error.localizedDescription)")
            }
        }
    }
    
    func checkAllFieldsEmpty() -> Bool {
        // Check if all fields are empty
        let username = fullNameTextfield.text ?? ""
        let password = designationTextfield.text ?? ""
        
        // Return true if all fields are empty, false otherwise
        return username.isEmpty || password.isEmpty
    }
    
    func setUI() {
        view.backgroundColor = .systemBackground
        
        setNav()
        
        let padding: CGFloat = 15
        let spacingTop: CGFloat = 10
        
        view.addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.equalToSuperview().offset(15)
        }
        
        view.addSubview(fullNameTextfield)
        fullNameTextfield.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(spacingTop)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.height.equalTo(40)
        }
        
        view.addSubview(designationLabel)
        designationLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameTextfield.snp.bottom).offset(spacingTop)
            make.left.equalToSuperview().offset(15)
        }
        
        view.addSubview(designationTextfield)
        designationTextfield.snp.makeConstraints { make in
            make.top.equalTo(designationLabel.snp.bottom).offset(spacingTop)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.height.equalTo(40)
        }
        
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(designationTextfield.snp.bottom).offset(spacingTop)
            make.leading.equalToSuperview().offset(15)
        }
        
        view.addSubview(requiredFields)
        requiredFields.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview().offset(-padding)
        }
    }
    
    func setNav() {
        title = "Add"
        
        let titleFontAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold) // Change the font size and weight as needed
        ]
        navigationController?.navigationBar.titleTextAttributes = titleFontAttributes
        
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backMenu))
        navigationItem.leftBarButtonItem = backButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveFunc))
        navigationItem.setRightBarButton(addButton, animated: true)
    }

    lazy var fullNameLabel: SWTitleLabel = {
        let fullNameLabel = SWTitleLabel(textAlignment: .center, fontSize: fontSize)
        fullNameLabel.text = "Full name *"
        return fullNameLabel
    }()
    
    lazy var fullNameTextfield: SWTextField = {
        let fullNameTextfield = SWTextField(underLineColor: .lightGray.withAlphaComponent(0.3))
        return fullNameTextfield
    }()
    
    lazy var designationLabel: SWTitleLabel = {
        let designationLabel = SWTitleLabel(textAlignment: .center, fontSize: fontSize)
        designationLabel.text = "Designation *"
        return designationLabel
    }()
    
    lazy var designationTextfield: SWTextField = {
       let designationTextfield = SWTextField(underLineColor: .lightGray.withAlphaComponent(0.3))
        return designationTextfield
    }()
    
    lazy var infoLabel: SWTitleLabel = {
        let infoLabel = SWTitleLabel(textAlignment: .center, fontSize: fontSize)
        infoLabel.text = "Information about employee *"
        return infoLabel
    }()

    lazy var requiredFields: SWTitleLabel = {
        let requiredFields = SWTitleLabel(textAlignment: .center, fontSize: fontSize)
        requiredFields.text = "Require fields *"
        return requiredFields
    }()
}