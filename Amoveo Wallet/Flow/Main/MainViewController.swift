//
//  MainViewController.swift
//  Amoveo Wallet
//
//  Created by Igor Efremov on 09/01/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

final class MainViewController: CommonViewLayer {
    
    var wireframe: AppWireframeProtocol?
    var navigation: AppNavigationProtocol?
    
    private let logoImageView: UIImageView = {
        let img = UIImageView()
        img.image = EXAGraphicsResources.logo
        return img
    }()
        
    private let createWalletView: WalletOptionView = {
        let view = WalletOptionView(.create)
        return view
    }()
    
    private let restoreWalletView: WalletOptionView = {
        let view = WalletOptionView(.restore)
        return view
    }()

    private let aboutStaticLabel: UILabel = {
        let lbl = UILabel(l10n(.settingsAbout), textColor: UIColor.white, font: UIFont.awFont(ofSize: 18.0, type: .medium))
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let aboutTapArea: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .clear
        return view
    }()

    private let versionLabel: AWLabel = {
        let lbl = AWLabel(EXAAppInfoService.appVersion)
        lbl.textColor = UIColor.exaPlaceholderColor
        lbl.textAlignment = .right
        lbl.font = UIFont.awFont(ofSize: 16.0, type: .regular)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        subscriptForViewEvents()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func subscriptForViewEvents() {
        createWalletView.onTapped = { [weak self] in
            self?.navigation?.presentSingleFrame(for: .walletPassphrase, data: nil as Bool?)
        }
        
        restoreWalletView.onTapped = { [weak self] in
            self?.navigation?.presentSingleFrame(for: .restoreWallet, data: nil as Bool?)
        }
    }

    @objc func onAboutTap() {
        navigation?.presentSingleFrame(for: .about, data: nil as Bool?)
    }
}

private extension MainViewController {
    
    func setupView() {
        applyStyle()
        setupTap()
        addSubviews()
        applyLayout()
    }
    
    func applyStyle() {
        setupBackButton()
        view.backgroundColor = UIColor.mainColor
    }
    
    func setupTap() {
        aboutTapArea.addTapTouch(self, action: #selector(onAboutTap))
    }
    
    func addSubviews() {
        let allSubviews = [logoImageView, createWalletView, restoreWalletView,
                           aboutStaticLabel, aboutTapArea, versionLabel]
        view.addMultipleSubviews(with: allSubviews)
    }
    
    func applyLayout() {
        logoImageView.snp.makeConstraints { (make) in
            make.width.equalTo(EXAGraphicsResources.logo.size.width)
            make.height.equalTo(EXAGraphicsResources.logo.size.height)
            make.top.equalTo(view).offset(60)
            make.centerX.equalToSuperview()
        }
        
        createWalletView.snp.makeConstraints{ (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(78)
            make.width.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(-10)
            make.height.equalTo(60)
        }
        
        restoreWalletView.snp.makeConstraints{ (make) in
            make.top.equalTo(createWalletView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(-10)
            make.width.equalTo(createWalletView.snp.width)
            make.height.equalTo(createWalletView.snp.height)
        }
        
        aboutStaticLabel.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalToSuperview()
            make.height.equalTo(24)
        }

        versionLabel.snp.makeConstraints{ (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalToSuperview()
            make.height.equalTo(24)
        }
        
        aboutTapArea.snp.makeConstraints{ (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
}
