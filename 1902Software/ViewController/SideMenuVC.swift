//
//  SideMenuVC.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/10/24.
//

import UIKit

class SideMenuVC: UIViewController {
    
    weak var delegate: PostListVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    private func getStatusBarHeight() -> CGFloat {
        let statusBarHeight: CGFloat
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = 0
        }
        return statusBarHeight
    }
    
    @objc func signoutTap() {
        UserService().logoutUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    
        let statusBarHeight = getStatusBarHeight()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(navContainerView)
        navContainerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44 + statusBarHeight)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(navContainerView.snp.bottom).offset(-5)
            make.left.equalTo(navContainerView).offset(10)
            make.height.width.equalTo(40)
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(navContainerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        containerView.addSubview(signoutLabel)
        signoutLabel.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.left.equalTo(backButton.snp.right).offset(5)
        }
    }
    
    @objc func closeMenu() {
        delegate.closeMenu()
        print("Meow")
    }
    
    lazy var navContainerView: UIView = {
        let navContainerView = UIView()
        navContainerView.backgroundColor = .white
        navContainerView.translatesAutoresizingMaskIntoConstraints = false
        return navContainerView
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "ic-back"), for: .normal)
        backButton.addTarget(self, action: #selector(closeMenu), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(signoutTap))
        containerView.addGestureRecognizer(tap)
        return containerView
    }()
    
    lazy var signoutLabel: SWTitleLabel = {
        let signoutLabel = SWTitleLabel(textAlignment: .left, fontSize: 22)
        signoutLabel.text = "Signout"
        signoutLabel.textColor = .black
        return signoutLabel
    }()
}
