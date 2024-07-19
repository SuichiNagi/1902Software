//
//  SideMenuVC.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/10/24.
//

import UIKit

class SideMenuVC: UIViewController {
    
//    let defaults = UserDefaults.standard
    
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
        showLoadingView()
        UserService().logoutUser { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let success):
                print(success)
                AuthService.shared.logout()
                
                DispatchQueue.main.async {
//                    self.clearSavedUsername()
                    let userLoginVC = UserLoginVC()
                    self.navigationController?.setViewControllers([userLoginVC], animated: true)
//                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    //clear saved username
//    func clearSavedUsername() {
//        defaults.removeObject(forKey: "savedUsername")
//    }
    
    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .systemBackground.withAlphaComponent(0)
    
        let statusBarHeight = getStatusBarHeight()
        
        view.addSubview(mainContainverView)
        mainContainverView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-50)
        }
        
        mainContainverView.addSubview(navContainerView)
        navContainerView.snp.makeConstraints { make in
            make.top.left.right.equalTo(mainContainverView)
            make.height.equalTo(44 + statusBarHeight)
        }
        
        navContainerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(navContainerView.snp.bottom).offset(-5)
            make.left.equalTo(navContainerView).offset(10)
            make.height.width.equalTo(40)
        }
        
        mainContainverView.addSubview(signoutContainerView)
        signoutContainerView.snp.makeConstraints { make in
            make.top.equalTo(navContainerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        signoutContainerView.addSubview(signoutLabel)
        signoutLabel.snp.makeConstraints { make in
            make.centerY.equalTo(signoutContainerView)
            make.left.equalTo(backButton.snp.right).offset(5)
        }
    }
    
    @objc func closeMenu() {
        delegate.closeMenu()
        print("Meow")
    }
    
    lazy var mainContainverView: UIView = {
        let mainContainerView = UIView()
        mainContainerView.backgroundColor = .systemBackground
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        return mainContainerView
    }()
    
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
    
    lazy var signoutContainerView: UIView = {
        let signoutContainerView = UIView()
        signoutContainerView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(signoutTap))
        signoutContainerView.addGestureRecognizer(tap)
        return signoutContainerView
    }()
    
    lazy var signoutLabel: SWTitleLabel = {
        let signoutLabel = SWTitleLabel(textAlignment: .left, fontSize: 22)
        signoutLabel.text = "Signout"
        signoutLabel.textColor = .black
        return signoutLabel
    }()
}
