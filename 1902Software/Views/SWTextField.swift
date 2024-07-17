//
//  SWTextField.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import UIKit

class SWTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    convenience init(underLineColor: UIColor) {
        self.init(frame: .zero)
        bottomBorder.backgroundColor = underLineColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        setUI()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        textColor                   = .label
        tintColor                   = .label
        textAlignment               = .center
        font                        = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth   = true
        minimumFontSize             = 12
        
        backgroundColor             = .tertiarySystemBackground
        autocorrectionType          = .no
        returnKeyType               = .go
        clearButtonMode             = .whileEditing
    }
    
    private func setUI() {
        addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(1)
        }
    }
    
    private lazy var bottomBorder: UIView = {
        let bottomBorder = UIView()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        return bottomBorder
    }()
}
