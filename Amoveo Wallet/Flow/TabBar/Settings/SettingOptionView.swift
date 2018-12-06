//
// Created by Igor Efremov on 30/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

enum SettingsOptionViewType {
    case node
    case pin
    case remember
    case alternativeCurrency
    case about

    var title: String {
        switch self {
        case .node:
            return "Blockchain node"
        case .pin:
            return "PIN Code"
        case .remember:
            return "Remind Passphrase"
        case .alternativeCurrency:
            return "Alternative currency"
        case .about:
            return l10n(.settingsAbout)
        }
    }
}

final class SettingOptionView: UIView {

    var onTapped: DefaultCallback?

    private var _type: SettingsOptionViewType = .pin
    private let title: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.textColor = UIColor.white
        title.font = UIFont.awFont(ofSize: 16, type: .medium)
        return title
    }()

    private let arrow: UIImageView = {
        let iv = UIImageView(image: EXAGraphicsResources.optionArrow)
        return iv
    }()

    init(_ type: SettingsOptionViewType) {
        super.init(frame: .zero)
        setup(with: type)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingOptionView {

    func setup(with type: SettingsOptionViewType) {
        setAttributes(for: type)
        addSubviews()
        applyLayout()
        applyStyle()
        addTapAction()
    }

    func setAttributes(for type: SettingsOptionViewType) {
        backgroundColor = UIColor.rgb(0x5c5f6d)
        title.text = type.title
    }

    func addSubviews() {
        let subviews = [title, arrow]
        addMultipleSubviews(with: subviews)
    }

    func applyLayout() {
        title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.width.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        arrow.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-22)
            make.width.equalTo(EXAGraphicsResources.optionArrow.size.width)
            make.height.equalTo(EXAGraphicsResources.optionArrow.size.height)
            make.centerY.equalToSuperview()
        }
    }

    func applyStyle() {
        layer.cornerRadius = 10.0
    }

    func addTapAction() {
        addTapTouch(self, action: #selector(tapAction))
    }

    @objc func tapAction() {
        onTapped?()
    }
}
