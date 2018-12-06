//
// Created by Igor Efremov on 01/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

final class BlockchainNodeViewController: CommonViewLayer {
    let nodeTextField: EXAHeaderTextFieldView = {
        let tf = EXAHeaderTextFieldView("Enter the node address", style: .pass, header: "Node address")
        tf.textField.keyboardType = .asciiCapable
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackButton()
    }

    func applyStyles() {
        nodeTextField.applyStyles()
        navigationItem.title = l10n(.settingsNode)
        view.backgroundColor = UIColor.mainColor
    }

    func applyLayout() {
        nodeTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(nodeTextField.defaultHeight)
        }

        nodeTextField.applyLayout()
    }

    func applyDefaultValues() {
        nodeTextField.textField.text = AWConfiguration.shared.serverConfiguration.url?.absoluteString
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let nodeAddress = self.nodeTextField.text

        if let theURL = URL(string: nodeAddress) {
            _ = AWConfiguration.shared.loadConfiguration(url: theURL)
        }
    }
}

private extension BlockchainNodeViewController {

    func addSubviews() {
        let allSubviews = [nodeTextField]
        view.addMultipleSubviews(with: allSubviews)
    }

    func setupView() {
        addSubviews()
        applyStyles()
        applyLayout()
        applyDefaultValues()
    }
}
