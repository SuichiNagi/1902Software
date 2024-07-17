//
//  SWButton.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import UIKit

class SWButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func config() {
        layer.cornerRadius     = 5
        layer.borderColor      = UIColor.secondaryLabel.cgColor
        layer.borderWidth      = 1
        titleLabel?.font       = UIFont.preferredFont(forTextStyle: .title2)
        
        setTitleColor(.black, for: .normal)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
