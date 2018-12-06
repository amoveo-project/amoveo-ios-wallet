//
// Created by Igor Efremov on 30/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

final class AboutViewController: CommonViewLayer {
    private let logoImageView = UIImageView(image: EXAGraphicsResources.logoImage)
    private let telegramImageView: UIImageView = UIImageView(image: EXAGraphicsResources.telegram)
    private let telegramImageSize = EXAGraphicsResources.telegram.size
    private let telegramStaticLabel: AWLabel = AWLabel(EXAAppInfoService.telegramChannel, textColor: UIColor.white,
            font: UIFont.awFont(ofSize: 16.0, type: .medium))
    private let telegramTapArea: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        return view
    }()
    private let versionLabel: AWLabel = {
        let lbl = AWLabel(EXAAppInfoService.appVersion)
        lbl.textColor = UIColor.exaPlaceholderColor
        lbl.textAlignment = .center
        lbl.font = UIFont.awFont(ofSize: 16.0, type: .regular)
        return lbl
    }()

    private let aboutText: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.backgroundColor = UIColor.clear
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.textAlignment = .left
        textView.keyboardType = .alphabet
        textView.keyboardAppearance = .dark
        textView.font = UIFont.awFont(ofSize: 16.0, type: .regular)
        textView.textColor = UIColor.white
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets.zero
        textView.text = l10n(.aboutText)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackButton()
        setupTapTouch()
    }

    func applyStyles() {
        navigationItem.title = l10n(.settingsAbout)
        view.backgroundColor = UIColor.mainColor
    }

    func applyLayout() {
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.width.equalTo(EXAGraphicsResources.logoImage.size.width)
            make.height.equalTo(EXAGraphicsResources.logoImage.size.height)
        }

        versionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(30)
            make.width.equalToSuperview()
            make.height.equalTo(22)
        }

        aboutText.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(versionLabel.snp.bottom).offset(30)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }

        telegramImageView.snp.makeConstraints { (make) in
            make.width.equalTo(telegramImageSize.width)
            make.height.equalTo(telegramImageSize.height)
            make.top.equalTo(aboutText.snp.bottom).offset(22)
            make.left.equalTo(20)
        }

        telegramStaticLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-telegramImageView.right - 15)
            make.height.equalTo(30)
            make.top.equalTo(telegramImageView.snp.top)
            make.left.equalTo(telegramImageView.snp.right).offset(20)
        }

        telegramTapArea.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(telegramImageView.height + 10)
            make.top.equalTo(telegramImageView.snp.top).offset(-4)
            make.left.equalTo(telegramImageView.snp.left).offset(-4)
            make.bottom.equalTo(telegramStaticLabel.snp.bottom)
        }
    }

    func setupTapTouch() {
        telegramTapArea.addTapTouch(self, action: #selector(onTelegramLink))
    }

    @objc func onTapExport() {
        EXADialogs.showEnterWalletPassword(completion: { pass in
            let walletManager = WalletManager()
            walletManager.decryptWallet(pass, accessGranted: { account in
                let shareService = SharingService()
                shareService.share(account.privateKey)
            }, accessDenied: {
                EXADialogs.showError(AWError.InvalidPassword)
            })
        }, cancel: nil)
    }

    @objc func onTelegramLink() {
        guard let url = URL(string: EXAAppInfoService.telegramChannelLink) else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}

private extension AboutViewController {

    func addSubviews() {
        let allSubviews = [logoImageView, telegramImageView, telegramStaticLabel, telegramTapArea, versionLabel, aboutText]
        view.addMultipleSubviews(with: allSubviews)
    }

    func setupView() {
        addSubviews()
        applyStyles()
        applyLayout()
    }
}
