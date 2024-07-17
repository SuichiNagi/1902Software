//
//  SWAlertVC.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/17/24.
//

import UIKit

class SWAlertVC: UIViewController {

    let padding: CGFloat = 20
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    init(alertTitle: String? = nil, message: String? = nil, buttonTitle: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(view)
            make.width.equalTo(280)
            make.height.equalTo(220)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(containerView).offset(padding)
            make.trailing.equalTo(containerView).offset(-padding)
            make.height.equalTo(28)
        }
        
        containerView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(containerView).offset(-padding)
            make.leading.equalTo(containerView).offset(padding)
            make.height.equalTo(44)
        }
        
        containerView.addSubview(bodyMessageLabel)
        bodyMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(containerView).offset(padding)
            make.trailing.equalTo(containerView).offset(-padding)
            make.bottom.equalTo(actionButton.snp.top).offset(-12)
        }
    }
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor       = .systemBackground
        container.layer.cornerRadius    = 16
        container.layer.borderWidth     = 2
        container.layer.borderColor     = UIColor.white.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var titleLabel: SWTitleLabel = {
        let label  = SWTitleLabel(textAlignment: .center, fontSize: 20)
        label.text = alertTitle ?? "Something went wrong"
        return label
    }()
    
    lazy var actionButton: SWButton = {
        let button = SWButton(backgroundColor: .systemRed, title: "Ok")
        button.setTitle(buttonTitle ?? "Ok", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    lazy var bodyMessageLabel: SWBodyLabel = {
        let messageLabel                = SWBodyLabel(textAlignment: .center)
        messageLabel.text               = message ?? "Unable to complete request"
        messageLabel.numberOfLines      = 4
        return messageLabel
    }()
}
