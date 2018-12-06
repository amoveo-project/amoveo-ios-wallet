//
//  ReceivePresenter.swift
//
//  Created by Igor Efremov on 09/08/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

protocol ReceivePresenterProtocol {
    func start()
}

final class ReceivePresenter {
    
    var viewLayer: ReceiveViewLayerProtocol?
    let viewModel = ReceiveViewModel()
}

extension ReceivePresenter: ReceivePresenterProtocol {
    
    func start() {
        setupViewModel()
        setupListener()
        subscriptForViewModel()
        subscriptForViewEvents()
    }
}

private extension ReceivePresenter {
    
    func setupViewModel() {
        guard let walletInfo = AppState.sharedInstance.walletInfo else {
            return
        }
        let mainAddress = walletInfo.address
        viewModel.mainAddress = mainAddress

        DispatchQueue.main.async { [weak self] in
            self?.updateUI(with: mainAddress)
        }
    }
    
    func subscriptForViewModel() {
        viewModel.onChangedWallet = { [weak self] address in
            self?.updateUI(with: address)
        }
    }
}

private extension ReceivePresenter {
    
    func subscriptForViewEvents() {
        viewLayer?.onDidLoad = onDidLoad
        viewLayer?.onWillAppear = onWillAppear
        viewLayer?.onWillDisappear = onDisappear
        viewLayer?.onCopy = onCopy
        viewLayer?.onShare = onShare
        viewLayer?.onChangedWallet = selectWallet
    }
    
    func onWillAppear() {
    }
    
    func onDisappear() {
    }
    
    func onDidLoad() {
    }
    
    func selectWallet(_ walletType: WalletType) {
        viewModel.type = walletType
    }
}

private extension ReceivePresenter {
    
    func setupListener() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onEnterBackground),
                                       name: UIApplication.willResignActiveNotification,
                                     object: nil)
    }
    
    @objc func onEnterBackground() {
        DispatchQueue.main.async { [weak self] in
            self?.updateUI(with: .amoveo)
        }
    }
}

private extension ReceivePresenter {
    
    func updateUI(with type: WalletType) {
        viewModel.type = .amoveo
    }
    
    func updateUI(with address: Address?) {
        DispatchQueue.main.async { [weak self] in
            self?.updateAddress(address)
        }
    }
    
    func updateAddress(_ address: Address?) {
        viewLayer?.updateAddressPresentation(address)
    }
}

private extension ReceivePresenter {
    
    func simple(_ account: Account) {
        setupViewModel()
    }
    
    private func showError(_ error: Error, title: String = l10n(.commonError), buttonTitle: String = l10n(.commonOk)) {
        EXADialogs.showError(error, title: title, buttonTitle: buttonTitle)
    }
}

private extension ReceivePresenter {
    
    func onCopy(_ optionCopy: CopyOption) {
        let address = viewModel.currentAddress
        EXAAppUtils.copy(toClipboard: address ?? "")
    }
    
    func onShare() {
        let shareService = SharingService()
        shareService.share(viewModel.currentAddress)
    }
}

