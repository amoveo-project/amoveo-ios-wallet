//
//  RestoreWalletViewController.swift
//
//  Created by Igor Efremov on 08/02/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import QuartzCore
import SnapKit

import BetterSegmentedControl

private struct SizeConstants {
    
    static let sideOffset        = 30.0
    static let widthOffset       = -60.0
    static let topOffset         = 30.0
    static let betweenDistance   = 20.0
    static let extraBetweenDist = DeviceType.isiPhone6OrMore ? 30.0 : 20.0
    
    static let buttonSize        = 35.0
}

private typealias s = SizeConstants


final class RestoreWalletViewController: CommonViewLayer {
    private let wordTextFields = [UnderlineTextField]()
    private let passPhraseLength = 12

    private let restoreSelectorControl = BetterSegmentedControl(
            frame: CGRect(x: 20, y: 0, width: 300, height: 36),
            segments: LabelSegment.segments(withTitles: ["With passphrase", "With private key"],
                    normalFont: UIFont.awFont(ofSize: 16.0, type: .medium),
                    normalTextColor: UIColor.rgb(0x8a8c96),
                    selectedFont: UIFont.awFont(ofSize: 16.0, type: .medium),
                    selectedTextColor: UIColor.mainColor),
            index: 0, options: [.backgroundColor(.white), .indicatorViewBackgroundColor(UIColor.awYellow)])
    
    private let titleInfoLabel: UILabel = {
        let lbl = UILabel(l10n(.restoreInfo))
        lbl.textColor = UIColor.titleLabelColor
        lbl.font = UIFont.awFont(ofSize: 12, type: .regular)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let phraseTextView: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.layer.borderColor = UIColor.mainColor.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 10.0
        textView.backgroundColor = UIColor.white
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.textAlignment = .left
        textView.keyboardType = .alphabet
        textView.keyboardAppearance = .dark
        textView.font = UIFont.specialFont(ofSize: 20.0)
        textView.textColor = UIColor.mainColor
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.becomeFirstResponder()
#if TEST
        textView.text = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
#endif
        return textView
    }()
    
    private let restoreBtn: EXAButton = {
        let btn = EXAButton(with: l10n(.restoreButton), color: UIColor.awYellow)
        btn.style = .hollow
        btn.addTarget(self, action: #selector(onContinueTap), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = l10n(.restoreTitle)
        
        let allSubviews = [restoreSelectorControl, phraseTextView, restoreBtn, titleInfoLabel]
        view.addMultipleSubviews(with: allSubviews)
        view.addTapTouch(self, action: #selector(switchFirstResponder))

        restoreSelectorControl.addTarget(self, action: #selector(restoreSelectorValueChanged(_:)), for: .valueChanged)
        
        applyStyles()
        applySizes()
        applyPreparation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @objc func restoreSelectorValueChanged(_ sender: UISegmentedControl) {
        if restoreSelectorControl.index == 0 {
            phraseTextView.text = ""
        } else {
            phraseTextView.text = ""
        }
    }
    
    @objc private func onContinueTap() {
        let phrase = preparePhrase()
        var account: Account? = nil

        if restoreSelectorControl.index == 0 {
            if AmoveoInnerWallet.isValidMnemonicPhrase(phrase) {
                account = Account.create(mnemonic: phrase)
            } else {
                phraseTextView.textColor = UIColor.rgb(0xfc431d)
                return
            }
        }
        else if restoreSelectorControl.index == 1 {
            if isValidPrivateKey(phrase) {
                account = Account.create(privateKey: phrase)
            } else {
                phraseTextView.textColor = UIColor.rgb(0xfc431d)
                return
            }
        }

        if let theAccount = account {
            buildWallets(with: theAccount)
            let params = CreatePasswordParams()
            params.account = theAccount
            params.isRestored = true
            let presenter = CreatePasswordPresenter()
            let viewLayer = CreatePasswordViewLayer()
            presenter.viewLayer = viewLayer
            presenter.start(with: params)
            self.navigationController?.pushViewController(viewLayer, animated: true)
        } else {
            phraseTextView.textColor = UIColor.rgb(0xfc431d)
        }
    }
    
    func buildWallets(with commonAccount: Account) {
        let builder = WalletBuilder()
        builder.buildAll(with: commonAccount)
    }
}

private extension RestoreWalletViewController {
    
    func applyPreparation() {
        setupBackButton()
        restoreBtn.isEnabled = preValidate()
        phraseTextView.delegate = self
    }
    
    func applyStyles() {
        view.backgroundColor = UIColor.mainColor

        restoreSelectorControl.applyStyles()
    }
    
    func applySizes() {
        restoreSelectorControl.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(s.topOffset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(s.sideOffset)
            make.height.equalTo(36)
        }
        
        phraseTextView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(s.sideOffset)
            make.height.equalTo(160)
            make.centerX.equalToSuperview()
            make.top.equalTo(restoreSelectorControl.snp.bottom).offset(s.betweenDistance)
        }
        
        restoreBtn.snp.makeConstraints { (make) in
            make.width.equalTo(148)
            make.height.equalTo(EXAButton.defaultHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(phraseTextView.snp.bottom).offset(s.extraBetweenDist)
        }
        
        titleInfoLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(s.widthOffset)
            make.left.equalToSuperview().offset(s.sideOffset)
            make.top.equalTo(restoreBtn.snp.bottom).offset(s.extraBetweenDist)
        }
    }
}

extension RestoreWalletViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        phraseTextView.textColor = UIColor.valueLabelColor
        restoreBtn.isEnabled = preValidate()
    }
    
    @objc func switchFirstResponder() {
        phraseTextView.resignFirstResponder()
        view.becomeFirstResponder()
    }
    
    fileprivate func preValidate() -> Bool {
        if wordCount() == 1 {
            return isValidPrivateKey(phraseTextView.text)
        }

        return wordCount() == passPhraseLength
    }

    fileprivate func isValidPrivateKey(_ phrase: String) -> Bool {
        if wordCount() == 1 {
            return phrase.count == 64 && phrase.isValidHexNumber()
        }

        return false
    }
    
    fileprivate func splitPassPhrase(_ phrase: String) {
        let words = phrase.split(separator: " ", omittingEmptySubsequences: true)
        for index in 0..<max(words.count, passPhraseLength) {
            wordTextFields[index].text = String(words[index])
        }
    }
    
    fileprivate func wordCount() -> Int {
        return splitByWords().count
    }

    fileprivate func splitByWords() -> [String.SubSequence] {
        let rawPhrase = String(phraseTextView.text!.trim().filter { !"\n\t\r".contains($0) })
        return rawPhrase.split(separator: " ", omittingEmptySubsequences: true)
    }
    
    fileprivate func preparePhrase() -> String {
        var phrase = ""
        let words = splitByWords()
        for index in 0..<min(words.count, passPhraseLength) {
            let preparedWord = words[index].lowercased()
            if index != 0 {
                phrase.append(" ")
            }
            phrase.append(preparedWord)
        }
        
        return phrase
    }
}
