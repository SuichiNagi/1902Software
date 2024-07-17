//
//  SWParagraphLabel.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/9/24.
//

import UIKit

class SWParagraphLabel: SWTitleLabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment  = textAlignment
        self.font           = UIFont.systemFont(ofSize: fontSize, weight: .medium)    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        numberOfLines = 0 // Allow multiple lines
    }
}
