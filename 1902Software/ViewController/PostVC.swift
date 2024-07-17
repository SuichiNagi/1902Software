//
//  PostVC.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import UIKit

class PostVC: UIViewController {
    
    let imageService = UserService()
    
    var postModel: PostModel!
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUI()
        setPostData()
    }
    
    func setPostData() {
        Task { [weak self] in
            guard let self = self else { return }
            
            if let image = await NetworkManager.shared.downloadImage(from: postModel.image) {
                self.avatarImage.image = image
            } else {
                self.avatarImage.image = UIImage(named: "info-overlay-profpic")
            }
        }
        //        NetworkManager.shared.downloadImage(from: postModel.image) { [weak self] image in
        //            guard let self = self else { return }
        //            DispatchQueue.main.async {
        //                self.avatarImage.image = image ?? UIImage(named: "info-overlay-profpic")
        //            }
        //        }
        
        if postModel.title == "" || postModel.title == nil {
            self.titleLabel.text = "No title"
        } else {
            self.titleLabel.text = postModel.title
        }
        
        self.usernameLabel.text = username
        
        if postModel.body == "" || postModel.body == nil {
            self.bodyLabel.textAlignment = .center
        }
        self.bodyLabel.text     = postModel.body ?? "No description"
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
    
    func setUI() {
        view.backgroundColor = .systemBackground
        
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let statusBarHeight = getStatusBarHeight()
        
        view.addSubview(navContainerView)
        navContainerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(navigationBarHeight + statusBarHeight)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(navContainerView.snp.bottom).offset(-5)
            make.left.equalTo(navContainerView).offset(10)
            make.height.width.equalTo(40)
        }
        
        view.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navContainerView.snp.bottom).offset(20)
            make.height.width.equalTo(100)
        }
        
        view.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImage.snp.bottom).offset(5)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
        }
        
        view.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }
    
    
    lazy var navContainerView: UIView = {
        let navContainerView = UIView()
        navContainerView.backgroundColor = .white
        return navContainerView
    }()
    
    
    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named:  "ic-back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return backButton
    }()
    
    lazy var avatarImage: SWAvatarImageView = {
        let avatarImage                 = SWAvatarImageView(frame: .zero)
        avatarImage.layer.cornerRadius  = 50
        return avatarImage
    }()
    
    lazy var usernameLabel: SWTitleLabel = {
        let usernameLabel = SWTitleLabel(textAlignment: .left, fontSize: 22)
        return usernameLabel
    }()
    
    lazy var titleLabel: SWTitleLabel = {
        let titleLabel          = SWTitleLabel(textAlignment: .left, fontSize: 17)
        titleLabel.tintColor    = .secondaryLabel
        return titleLabel
    }()
    
    lazy var bodyLabel: SWParagraphLabel = {
        let bodyLabel = SWParagraphLabel(textAlignment: .left, fontSize: 15)
        return bodyLabel
    }()
}
