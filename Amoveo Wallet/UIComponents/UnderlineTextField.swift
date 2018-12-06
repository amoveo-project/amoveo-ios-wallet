//
//  UnderlineTextField.swift
//
//  Created by Igor Efremov on 07/02/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

enum UnderlineTextFieldStyle {
    
    case pass
    case verify
    
    var returnKeyType: UIReturnKeyType {
        switch self {
        case .pass:
            return .next
        case .verify:
            return .continue
        }
    }
}

final class UnderlineTextField: UITextField {
    
    var onEditChanged: TextFieldValueHandler?

    convenience init(_ placeholder: String, style: UnderlineTextFieldStyle, color: UIColor = UIColor.placeholderDarkColor) {
        self.init(frame: CGRect.zero)
        attributedPlaceholder = NSAttributedString(string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor : color])
        configStyle(style)
        addListener()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.useUnderline()
    }
}

private extension UnderlineTextField {
    
    func configStyle(_ style: UnderlineTextFieldStyle) {
        returnKeyType = style.returnKeyType
    }
    
    func commonSetup() {
        backgroundColor = UIColor.clear
        textColor = UIColor.titleLabelColor
        keyboardAppearance = .dark
    }
    
    func addListener() {
        addTarget(self, action: #selector(edit), for: .editingChanged)
    }
    
    @objc func edit(_ field: UITextField) {
        guard let text = field.text else { return }
        onEditChanged?(text)
    }
}


