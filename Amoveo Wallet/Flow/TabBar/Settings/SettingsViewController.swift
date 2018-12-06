//
// Created by Igor Efremov on 24/06/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit
import SDCAlertView

protocol SettingsViewProtocol {
    var onAboutSelected: DefaultCallback? { get set }
}

class SettingsViewController: CommonViewLayer, SettingsViewProtocol, PinCodeDismissDelegate {
    var onAboutSelected: DefaultCallback?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let blockchainNode: SettingOptionView = {
        let view = SettingOptionView(.node)
        return view
    }()

    private let pinCodeOption: SettingOptionView = {
        let view = SettingOptionView(.pin)
        return view
    }()

    private let rememberPassPhrase: SettingOptionView = {
        let view = SettingOptionView(.remember)
        return view
    }()

    private let alternativeCurrency: SettingOptionView = {
        let view = SettingOptionView(.alternativeCurrency)
        return view
    }()

    private let aboutAmoveo: SettingOptionView = {
        let view = SettingOptionView(.about)
        return view
    }()

    private let deleteBtn: EXAButton = {
        let btn = EXAButton(with: l10n(.deleteWallet), color: UIColor.localRed)
        btn.style = .hollow
        btn.addTarget(self, action: #selector(onTapDelete), for: .touchUpInside)
        return btn
    }()

    private let exportButton: EXAButton = {
        let btn = EXAButton(with: l10n(.exportPrivateKey), color: UIColor.white)
        btn.style = .hollow
        btn.addTarget(self, action: #selector(onTapExport), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        blockchainNode.addTapTouch(self, action: #selector(SettingsViewController.onTapNode))
        pinCodeOption.addTapTouch(self, action: #selector(SettingsViewController.onPinCode))
        rememberPassPhrase.addTapTouch(self, action: #selector(SettingsViewController.onRemember))
        alternativeCurrency.addTapTouch(self, action: #selector(SettingsViewController.onTapCurrency))
        aboutAmoveo.addTapTouch(self, action: #selector(SettingsViewController.onTapAbout))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: ScreenSize.screenWidth, height: ScreenSize.screenHeight)
        updateConstraints()
    }

    private func updateConstraints() {
        applyLayout()
    }

    func applyStyles() {
        navigationItem.title = l10n(.tabSettingsTitle)
        view.backgroundColor = UIColor.mainColor
    }

    func applyLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets.zero)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(UIEdgeInsets.zero)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView.contentSize.height)
        }

        blockchainNode.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(26)
            make.width.equalToSuperview().inset(10)
            make.height.equalTo(60)
        }

        pinCodeOption.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(-10)
            make.top.equalTo(blockchainNode.snp.bottom).offset(30)
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }

        rememberPassPhrase.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(-10)
            make.top.equalTo(pinCodeOption.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }

        alternativeCurrency.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(-10)
            make.top.equalTo(rememberPassPhrase.snp.bottom).offset(30)
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }

        aboutAmoveo.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(-10)
            make.top.equalTo(alternativeCurrency.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }

        exportButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(aboutAmoveo.snp.bottom).offset(40)
            make.width.equalTo(176)
            make.height.equalTo(42)
        }

        deleteBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(exportButton.snp.bottom).offset(20)
            make.width.equalTo(176)
            make.height.equalTo(42)
        }
    }

    @objc func onTapDelete() {
        let msg = "Are you sure you want to delete your Amoveo wallet?\n\nYour assets will be lost forever unless you have written down the recovery phrase and kept it somewhere safe.\nTo view your recovery phrase press “Cancel” then go to Settings – Remind Passphrase."
        let alert = AlertController(title: EXAAppInfoService.appTitle, message: msg, preferredStyle: .alert)
        alert.visualStyle = EXAInputDialogVisualStyle(alertStyle: .alert)
        let OKAction = AlertAction(title: l10n(.commonOk), style: .destructive, handler: { [weak self]
        (action) -> Void in
            if let wSelf = self {
                wSelf.deleteWalletFiles()
                EXAAppNavigationDispatcher.sharedInstance.resetWalletAndStartNew()
            }
        })

        let cancelAction = AlertAction(title: l10n(.commonCancel), style: .preferred, handler: nil)

        alert.addAction(OKAction)
        alert.addAction(cancelAction)
        alert.present()
    }

    private func deleteWalletFiles() {
        if let theDocumentsDirectory = EXACommon.documentsDirectory {
            let walletFilePath = theDocumentsDirectory.appendPathComponent(AWConfiguration.shared.encryptedWalletFileName)
            if FileManager.default.fileExists(atPath: walletFilePath) {
                try? FileManager.default.removeItem(atPath: walletFilePath)
            }
        }
    }

    @objc func onTapExport() {
        EXADialogs.showEnterWalletPassword(completion: { pass in
            let walletManager = WalletManager()
            walletManager.decryptWallet(pass, accessGranted: { (account) in
                let shareService = SharingService()
                shareService.share(account.privateKey)
            }, accessDenied: {
                EXADialogs.showError(AWError.InvalidPassword)
            })
        }, cancel: nil)
    }

    @objc func onTapNode() {
        navigationController?.pushViewController(
                BlockchainNodeViewController(), animated: true)
    }

    @objc func onTapCurrency() {
        navigationController?.pushViewController(
                AlternativeCurrencyViewController(), animated: true)
    }

    @objc func onTapAbout() {
        navigationController?.pushViewController(
                AboutViewController(), animated: true)
    }

    @objc func onPinCode() {
        setupPIN()
    }

    @objc func onRemember() {
        showPassphrase()
    }

    private func setupPIN() {
        let pinCodeMode: PinCodeMode
        if let _ = UserDefaults.standard.string(forKey: PinCodeConstants.kPincodeDefaultsKey) {
            pinCodeMode = .change
        } else {
            pinCodeMode = .create
        }
        _ = PinCodeViewController().present(with: pinCodeMode, delegate: self)
    }

    private func showPassphrase() {
        EXADialogs.showEnterWalletPassword(completion: { pass in
            let walletManager = WalletManager()
            walletManager.decryptWallet(pass, accessGranted: {
                [weak self] (account) in
                let rememberVc = RememberViewController()
                if account.mnemonicPhrase == "" {
                    EXADialogs.showMessage("Sorry, but it can't be possible, because you restored your wallet with private key.\n\nIn future we will offer you transfer to new account with mnemonic passphrase support.", title: EXAAppInfoService.appTitle, buttonTitle: l10n(.commonOk))
                    return
                }

                rememberVc.updateView(passphrase: account.mnemonicPhrase)
                self?.navigationController?.pushViewController(rememberVc, animated: true)
            }, accessDenied: {
                EXADialogs.showError(AWError.InvalidPassword)
            })
        }, cancel: nil)
    }

    func onDismiss() {

    }
}

private extension SettingsViewController {

    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let allSubviews = [deleteBtn, exportButton, blockchainNode, pinCodeOption, rememberPassPhrase, alternativeCurrency, aboutAmoveo]
        contentView.addMultipleSubviews(with: allSubviews)
    }

    func setupView() {
        addSubviews()
        applyStyles()
        //applyLayout()
    }
}
