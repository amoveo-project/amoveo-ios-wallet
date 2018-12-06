//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

enum EXAButtonStyle: UInt {
    case filled = 0, hollow
}

class EXAPhraseTextView: UITextView {
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControl()
    }

    fileprivate func initControl() {
        textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textAlignment = .justified
        font = UIFont.specialFont(ofSize: 20.0)
        textColor = UIColor.valueLabelColor
        isEditable = false
        isScrollEnabled = false
        isSelectable = false
        showsVerticalScrollIndicator = false
        layer.cornerRadius = 10.0
    }
}

class EXAButton: UIButton {
    private var color: UIColor = UIColor.awYellow

    static let defaultHeight: CGFloat = 42.0

    var style: EXAButtonStyle = .filled {
        didSet {
            if .hollow == style {
                backgroundColor = UIColor.clear
                setTitleColor(color, for: .normal)
                setTitleColor(UIColor.rgb(0x8b8617), for: .disabled)
                titleLabel?.font = UIFont.awFont(ofSize: 16.0, type: .medium)

                layer.borderColor = color.cgColor
                layer.cornerRadius = 5.0
                layer.borderWidth = 2
            }
        }
    }

    override var isEnabled: Bool {
        didSet {
            if .hollow == style {
                backgroundColor = UIColor.clear
                layer.borderColor = isEnabled ? color.cgColor : UIColor.rgb(0x8b8617).cgColor
            } else {
                if isEnabled {
                    backgroundColor = color
                } else {
                    backgroundColor = UIColor.awYellowInactive
                }
            }
        }
    }

    convenience init(with title: String?, color: UIColor = UIColor.awYellow) {
        self.init(frame: CGRect.zero)
        self.color = color
        initControl()
        setTitleColor(UIColor.awBlack, for: .normal)
        setTitle(title, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControl()
    }

    fileprivate func initControl() {
        layer.cornerRadius = 10.0
        titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        backgroundColor = color
    }
}
