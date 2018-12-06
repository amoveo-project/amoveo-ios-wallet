//
//  ReceiveViewController.swift
//
//  Created by Igor Efremov on 09/01/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

protocol ReceiveViewLayerProtocol {
    
    var onDidLoad: DefaultCallback? { get set }
    var onWillAppear: DefaultCallback? { get set }
    var onWillDisappear: DefaultCallback? { get set }
    
    var onShare: DefaultCallback? { get set }
    var onCopy: CopyOptionHandler? { get set }
    
    var onChangedWallet: ((WalletType) -> ())? { get set }
    
    func updateAddressPresentation(_ address: Address?)
    func loader(_ option: EXACircleStrokeLoadingIndicatorOption)
}

final class ReceiveViewController: CommonViewLayer {
    
    var onDidLoad: DefaultCallback?
    var onWillAppear: DefaultCallback?
    var onWillDisappear: DefaultCallback?
    
    var onShare: DefaultCallback?
    var onCopy: CopyOptionHandler?
    
    var onChangedWallet: ((WalletType) -> ())?
    
    private var receiveView = ReceiveView()
    
    override func loadView() {
        super.loadView()
        receiveView.frame = view.frame
        view = receiveView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onDidLoad?()
        subscriptForViewEvents()

        self.navigationItem.title = l10n(.tabReceiveTitle)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onWillAppear?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onWillDisappear?()
    }
}

extension ReceiveViewController: ReceiveViewLayerProtocol {
    
    func updateAddressPresentation(_ address: Address?) {
        updateBottomLabel(address)
        updateQR(address)
    }
    
    func loader(_ option: EXACircleStrokeLoadingIndicatorOption) {
        switch option {
        case .on:
            receiveView.loader.startAnimating()
        case .off:
            receiveView.loader.stopAnimating()
        }
    }
}

private extension ReceiveViewController {
    
    func updateBottomLabel(_ address: Address?) {
        receiveView.recipientAddressValue.text = address
    }
    
    func updateQR(_ address: Address?) {
        guard let addr = address, var qrCode = QRCode(addr) else {
            return
        }
        let qrCodeSize = view.width - 88 * 2
        qrCode.size = CGSize(width: qrCodeSize, height: qrCodeSize)
        receiveView.recipientQRCodeImageView.size  = CGSize(width: qrCodeSize, height: qrCodeSize)
        receiveView.recipientQRCodeImageView.image = qrCode.image
    }
    
    func subscriptForViewEvents() {
        receiveView.onCopy  = onCopy
        receiveView.onShare = onShare
    }
}
