//
//  CreateWalletViewController.swift
//
//  Created by Igor Efremov on 09/01/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

private struct SizeConstants {
    
    static let leftOffset  = 20.0
    static let topOffset   = 10.0
    static let widthOffset = -leftOffset * 2
}

private typealias s = SizeConstants

final class CreateWalletViewController: CommonViewLayer {
    
    var navigation: AppNavigationProtocol?

    private let bottomView = ContainerBottomView()

    private let phraseTextView: EXAPhraseTextView = {
        let textView = EXAPhraseTextView()
        textView.sizeToFit()
        return textView
    }()

    private let noteLabel: AWLabel = {
        let lbl = AWLabel(l10n(.commonSafeNote))
        lbl.style = .main
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let continueButton: AWCircleButton = {
        let btn = AWCircleButton()
        btn.addTarget(self, action: #selector(onTapContinue), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createAppWallets()
    }
    
    private func createAppWallets() {
        let account = makeAccount()
        buildWallets(with: account)
        updateView(passphrase: account.mnemonicPhrase)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func onTapContinue(_ sender: UIButton) {
        navigation?.presentSingleFrame(for: .createPassword, data: nil as Bool?)
    }
}

private extension CreateWalletViewController {
    
    func makeAccount() -> Account {
        let accountFabric = AccountFabric()
        let account = accountFabric.createAccount()
        return account
    }
    
    func buildWallets(with commonAccount: Account) {
        let builder = WalletBuilder()
        builder.buildAll(with: commonAccount)
    }

    func updateView(passphrase: String) {
        phraseTextView.text = passphrase
    }
}

private extension CreateWalletViewController {
    
    func setupView() {
        setupTitle()
        applyStyle()
        addSubviews()
        applyLayout()
    }
    
    func applyStyle() {
        setupBackButton()
        view.backgroundColor = UIColor.mainColor
    }
    
    func setupTitle() {
        navigationItem.title = l10n(.createWalletTitle)
    }
    
    func addSubviews() {
        let allSubviews = [bottomView, phraseTextView, continueButton]
        bottomView.addSubview(noteLabel)
        view.addMultipleSubviews(with: allSubviews)
    }
    
    func applyLayout() {
        bottomView.snp.makeConstraints { (make) in
            make.width.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
            make.height.equalTo(149)
        }

        noteLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(30)
            make.width.equalToSuperview().offset(-150)
            make.height.equalToSuperview().offset(-60)
        }

        phraseTextView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(s.leftOffset)
            make.width.equalToSuperview().offset(s.widthOffset)
        }
        
        continueButton.snp.makeConstraints{ (make) in
            make.width.height.equalTo(continueButton.radius * 2)
            make.bottom.right.equalToSuperview().offset(-30)
        }
    }
}
