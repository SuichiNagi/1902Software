//
//  SWAvatarImageView.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import UIKit

class SWAvatarImageView: UIImageView {

    let placeholderImage = UIImage(named: "listing-img-1")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        clipsToBounds       = true
        contentMode         = .scaleAspectFill
        layer.cornerRadius  = 30
        image               = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}
