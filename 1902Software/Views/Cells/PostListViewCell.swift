//
//  PostListViewCell.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import UIKit

class PostListViewCell: UITableViewCell {
    
    let imageService = UserService()

    let padding: CGFloat = 12
    
    static let reuseID = "PostListViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(titleLabel)
        
        accessoryType = .disclosureIndicator
        
        setSnpConstraints()
    }
    
    func set(post: PostModel) {
        Task { [weak self] in
            guard let self = self else { return }
            
            if let image = await NetworkManager.shared.downloadImage(from: post.image) {
                self.avatarImageView.image = image
            } else {
                self.avatarImageView.image = UIImage(named: "info-overlay-profpic")
            }
        }
        
//        NetworkManager.shared.downloadImage(from: post.image) { [weak self] image in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.avatarImageView.image = image
//            }
//        }
        
        if post.title == "" || post.title == nil {
            titleLabel.text = "No title"
        } else {
            titleLabel.text = post.title
        }
    }
    
    private func setSnpConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(padding)
            make.height.width.equalTo(60)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(24)
            make.trailing.equalTo(self).offset(-padding)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(24)
            make.trailing.equalTo(self).offset(-padding)
        }
    }
    
    lazy var avatarImageView: SWAvatarImageView = {
        let avatarImageView = SWAvatarImageView(frame: .zero)
        return avatarImageView
    }()
    
    lazy var usernameLabel: SWTitleLabel = {
        let usernameLabel = SWTitleLabel(textAlignment: .left, fontSize: 22)
        return usernameLabel
    }()
    
    lazy var titleLabel: SWTitleLabel = {
        let titleLabel = SWTitleLabel(textAlignment: .left, fontSize: 17)
        titleLabel.tintColor = .secondaryLabel
        return titleLabel
    }()
}
