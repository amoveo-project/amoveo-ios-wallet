//
// Created by Igor Efremov on 24/06/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class SendViewController: ViewLayer, RecipientViewActionDelegate, AddressScannerActionDelegate {
    private let lineViewAddress = UIView(frame: CGRect.zero)
    private let sendBtn: AWCircleButton = {
        let btn = AWCircleButton()
        btn.addTarget(self, action: #selector(onTapSend), for: .touchUpInside)
        return btn
    }()
    private let lineViewAmount = UIView(frame: CGRect.zero)
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let networkFee: AWLabel = {
        let lbl = AWLabel("")
        lbl.textColor = UIColor.mainColor
        lbl.textAlignment = .left
        lbl.font = UIFont.awFont(ofSize: 14.0, type: .regular)
        return lbl
    }()
    private let bottomView = ContainerBottomView()

    private let recipientView = RecipientView()
    private let amountView = AmountInputView()

    private let rateInfoLabel: AWLabel = {
        let lbl = AWLabel()
        lbl.textColor = UIColor.awGray
        lbl.textAlignment = .left
        lbl.font = UIFont.awFont(ofSize: 14.0, type: .regular)
        return lbl
    }()

    private var sendingTransactionDetails: AmoveoSendTransactionDetails?

    private let sendingService = VEOTransactionsService()

    private let transactionCreationService = TransactionCreationService()
    private let transactionSendingService = TransactionSendingService()
    private let selectorTypeTransactionService = SelectTransactionTypeService()

    //private var loadingView: EXACircleStrokeLoadingIndicator = EXACircleStrokeLoadingIndicator()

    private var amountValueParam: UInt64? = nil
    private var toAddressParam: Address? = nil
    private var availableAmount: AmountValue? = nil
    private var selectedTransactionType: TransactionBlockchainType? = nil

    private var keyboardHeight: CGFloat = 0.0
    private var tabbarHeight: CGFloat = 0.0

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabbarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0.0

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let allSubviews = [recipientView, amountView, rateInfoLabel]
        contentView.addMultipleSubviews(with: allSubviews)
        if DeviceType.isWideScreen {
            bottomView.addSubview(sendBtn)
            view.addMultipleSubviews(with: [bottomView])
        } else {
            view.addMultipleSubviews(with: [bottomView])
            view.addMultipleSubviews(with: [sendBtn])
        }

        bottomView.addSubview(networkFee)

        /*loadingView.fullScreenMode = true
        loadingView.isHidden = true
        loadingView.frame = self.view.frame*/

        recipientView.actionDelegate = self

        if let theBalanceStorage = AppState.sharedInstance.walletInfo?.balance {
            availableAmount = theBalanceStorage.getBalance(ticker: .VEO)
        }

        applyStyles()
        applyDefaultValues()
#if TEST
        if let theSendInfo = EXACommon.loadTestInfo(AmoveoConstants.testReceiveAddress) {
            parseSendInfoAndFill(theSendInfo)
        }
#endif

        view.addTapTouch(self, action: #selector(switchFirstResponder))
        checkStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)),
                name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: ScreenSize.screenWidth, height: ScreenSize.screenHeight + 20.0)
        updateConstraints()
    }

    private func updateConstraints() {
        applySizes()
    }

    func applyStyles() {
        //super.applyStyles()

        navigationItem.title = l10n(.tabSendTitle)
        view.backgroundColor = UIColor.mainColor

        amountView.actionDelegate = self

        recipientView.applyStyles()
        amountView.applyStyles()
    }

    func applyDefaultValues() {
        amountView.availableAmount = availableAmount

        validateAmountAndHighlight()
    }

    func parseSendInfoAndFill(_ value: String) {
        let parts = value.components(separatedBy: "?")
        if parts.count > 1 {
            recipientView.addressValue = parts[0]
        } else {
            recipientView.addressValue = value
        }
    }

    func applySizes() {
        let topOffset: CGFloat = 20

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets.zero)
        }

        bottomView.snp.updateConstraints { (make) in
            make.width.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(10.0)
            make.height.equalTo(130)
        }

        networkFee.snp.updateConstraints { (make) in
            make.width.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(UIEdgeInsets.zero)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView.contentSize.height)
        }

        recipientView.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.height.equalTo(97)
            make.top.equalTo(topOffset)
        }

        amountView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(118)
            make.top.equalTo(recipientView.snp.bottom).offset(20)
        }

        rateInfoLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.top.equalTo(amountView.snp.bottom).offset(10)
        }

        recipientView.applyLayout()
        amountView.applyLayout()

        if keyboardHeight > 1 {
            if DeviceType.isWideScreen {
                bottomView.snp.updateConstraints { (make) in
                    make.width.left.equalToSuperview()
                    make.bottom.equalToSuperview().offset(10 - keyboardHeight + tabbarHeight)
                    make.height.equalTo(130)
                }
            } else {
                sendBtn.snp.updateConstraints { (make) in
                    make.width.height.equalTo(sendBtn.radius * 2)
                    make.right.equalToSuperview().offset(-30)
                    make.bottom.equalToSuperview().offset(-30 - keyboardHeight + tabbarHeight)
                }
            }
        } else {
            sendBtn.snp.updateConstraints{ (make) in
                make.width.height.equalTo(sendBtn.radius * 2)
                make.right.equalToSuperview().offset(-30)
                make.bottom.equalToSuperview().offset(-30)
            }
        }
    }

    private func checkStatus() {
        //sendBtn.isEnabled = true
    }

    @objc func switchFirstResponder() {
        for v in [recipientView, amountView] as [UIView] {
            _ = v.resignFirstResponder()
        }
        _ = view.becomeFirstResponder()
    }

    @objc func onTapPrepare() {

    }

    private func validateAmount() -> Bool {
        let amountValueString = amountView.amountValue
        guard let amount = NumberFormatter().number(from: amountValueString)?.doubleValue else {
            return false
        }

        if amount < 0 {
            return false
        }

        let fee = getNetworkFee(selectedTransactionType)
        return AmountValidator.isPossibleAmount(amount: amount, availableAmount: availableAmount, fee: fee)
    }

    private func validateAddress(_ base64EncodedAddress: String) -> Bool {
        return AddressValidator.isCorrectAddress(base64EncodedAddress)
    }

    private func stopLoader() {
        //loadingView.stopAnimating()
    }

    private func validateAll() -> Bool {
        guard validateAmount() else {
            amountView.incorrect = true
            return false
        }

        guard validateAddress(recipientView.addressValue) else {
            recipientView.incorrect = true
            return false
        }

        return true
    }

    private func validateAndSend() {
        if !validateAll() {
            sendBtn.isEnabled = true
            stopLoader()
        }
    }

    func requestPassword() {
        EXADialogs.showEnterWalletPassword(completion: {
            [weak self]
            (pass) -> Void in
            if let wSelf = self {
                wSelf.checkPassword(pass)
            }
        })
    }

    func checkPassword(_ pass: String) {
        let walletManager = WalletManager()
        walletManager.decryptWallet(pass, accessGranted: {
            [weak self] (account) in
            if AppState.sharedInstance.walletsManager == nil {
                let wm = WalletsManager(account: account)
                AppState.sharedInstance.walletsManager = wm
            } else {
                AppState.sharedInstance.walletsManager?.setupAccount(account)
            }
            self?.createTransactionAndSend()
        }, accessDenied: {
            EXADialogs.showError(AWError.InvalidPassword)
        })
    }

    func createTransactionAndSend() {
        guard let toAddress = toAddressParam else { return }
        guard let amount = amountValueParam else { return }

        guard let theAddress = AppState.sharedInstance.walletInfo?.address else { NSLog("Address is NIL"); return }

        selectorTypeTransactionService.onSelectedType = { [weak self] selectedTransactionType in
            let transactionTemplate = TransactionTemplate(selectedTransactionType, amount: amount,
                    from: theAddress,
                    to: toAddress)

            let builder = TransactionTemplateBuilder(transactionTemplate)
            self?.transactionCreationService.onPrepared = { [weak self] preparedTransaction in
                if let serializedTransaction = self?.serializeTransaction(transaction: preparedTransaction) {
                    if let sign = self?.signTransaction(serializedTransaction) {
                        let signedTransaction = SignedTransaction(sign, preparedTransaction: preparedTransaction)
                        let serializer = SignedTransactionSerializer(signedTransaction)
                        self?.transactionSendingService.onSent = { txhash in
                            EXADialogs.showMessage("Transaction was sent.\nTx id: \(txhash)",
                                    title: EXAAppInfoService.appTitle, buttonTitle: l10n(.commonOk))
                        }
                        self?.transactionSendingService.send(serializer)
                    }
                }
            }
            self?.transactionCreationService.create(builder)
        }
        selectorTypeTransactionService.select(AddressSerializer(toAddress))
    }

    func setupSendParams(_ params: AppLinkerAddressWalletParams) {
        if let theAddress = params.address {
            recipientView.addressValue = theAddress
        }

        guard let theAmountString = params.amount else { return }
        if let theAmount = UInt64(theAmountString) {
            amountView.setupAmount(EXAWalletFormatter.prepareAmount(rawAmount: theAmount))
        }
    }

    @objc func onTapSend() {
        defer {
            sendBtn.isEnabled = true
        }

        amountValueParam = nil
        toAddressParam = nil

        sendBtn.isEnabled = false
        //loadingView.startAnimating()

        /*delay(0.3, closure: {
            self.validateAndSend()
        })*/
        var preparedAmount = amountView.amountValue
        if let theSeparator = NSLocale.current.decimalSeparator {
            preparedAmount = amountView.amountValue.replacingOccurrences(of: EXACommon.dotSymbol, with: theSeparator)
            preparedAmount = preparedAmount.replacingOccurrences(of: EXACommon.commaSymbol, with: theSeparator)
        }

        let amountValue = NSDecimalNumber(string: preparedAmount, locale: NSLocale.current)
        if amountValue == NSDecimalNumber.notANumber {
            NSLog("Amount is not a valid");
            return
        }

        let toAddress = recipientView.addressValue
        if !validateAddress(toAddress) {
            recipientView.incorrect = true

            NSLog("Address is not a valid");
            return
        } else {
            recipientView.incorrect = false
        }

        if let theWalletInfo = AppState.sharedInstance.walletInfo, let theOwnAddress = theWalletInfo.address {
            if theOwnAddress == toAddress {
                recipientView.incorrect = false
                EXADialogs.showMessage(l10n(.sendYourself), title: EXAAppInfoService.appTitle, buttonTitle: l10n(.commonOk))
                return
            }
        }

        let amount = amountValue.multiplying(byPowerOf10: 8).uint64Value

        amountValueParam = amount
        toAddressParam = toAddress

        requestPassword()
    }

    private func serializeTransaction(transaction: PreparedTransactionTemplate) -> Data {
        let encoder = BertEncoder()

        var arr: BertArray = BertArray()
        for index in 0..<transaction.fieldCount {
            arr.append(transaction[index])
        }

        NSLog("serialize Transaction")

        let result = encoder.encodeAny(any: arr)
        return result
    }

    private func signTransaction(_ serializedTransaction: Data) -> String? {
        if let hash = SecureData(data: serializedTransaction).sha256().data() {
            if let theAccount = AppState.sharedInstance.walletsManager?.account(.amoveo) {
                if let sign = theAccount.signDigest(hash) {
                    let signDER = theAccount.serialize(toDER: sign)

                    NSLog("sign Transaction")
                    if let theSignDER = signDER {
                        return theSignDER.base64EncodedString(options: [])
                    }
                }
            } else {
                NSLog("Account is NIL")
            }
        }

        NSLog("Error in signing transaction process")
        return nil
    }

    func scanQR() {
        showCamera()
    }

    func onAddressChanged() {
        validateAddressAndSetupFee(recipientView.addressValue)
    }

    private func showCamera() {
        let vc = AddressScannerViewController()
        vc.actionDelegate = self
        let nvc = EXANavigationController(rootViewController: vc)
        weak var wvc = vc
        self.present(nvc, animated: true, completion: {
            wvc?.startScanningQR()
        })
    }

    func onAddressRecognized(_ address: String) {
        parseSendInfoAndFill(address)
    }

    private func validateAddressAndSetupFee(_ address: String) {
        let result = validateAddress(address)
        recipientView.incorrect = !result
        if result {
            doAfterAddressFilled()
        } else {
            clearNetworkFee()
        }
    }

    private func doAfterAddressFilled() {
        selectorTypeTransactionService.onSelectedType = { [weak self] selectedTransactionType in
            self?.selectedTransactionType = selectedTransactionType
            self?.updateNetworkFee(selectedTransactionType)
        }
        selectorTypeTransactionService.select(AddressSerializer(recipientView.addressValue))
    }

    private func getNetworkFee(_ transactionType: TransactionBlockchainType?) -> AmountValue {
        guard let transactionType = transactionType else { return AmountValue(0.0) }
        return EXAWalletFormatter.prepareAmount(rawAmount: transactionType.fee)
    }

    private func updateNetworkFee(_ transactionType: TransactionBlockchainType) {
        networkFee.text = "Network fee: " + getNetworkFee(transactionType).toVEOString() + " " + CryptoTicker.VEO.description
    }

    private func clearNetworkFee() {
        networkFee.text = ""
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = 0
        self.updateConstraints()
    }

    @objc func keyboardDidShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let userInfoValue: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardSize: CGSize = userInfoValue.cgRectValue.size
                keyboardHeight = min(keyboardSize.height, keyboardSize.width)
                self.updateConstraints()
            }
        }
    }
}

extension SendViewController: AmountInputViewActionDelegate {

    func onAmountDidChange() {
        doAfterAmountChanged()
    }

    func sendAll() {
        let fee = getNetworkFee(selectedTransactionType)
        if let theValue = availableAmount {
            let maxValue = MaxAmount.maxAmount(availableAmount: theValue, fee: fee)
            amountView.setupAmount(maxValue)
            doAfterAmountChanged()
        }
    }

    private func doAfterAmountChanged() {
        updateAmountInAlternativeCurrency()
        validateAmountAndHighlight()
    }

    private func updateAmountInAlternativeCurrency() {
        let amountValueString = amountView.amountValue
        guard let amount = NumberFormatter().number(from: amountValueString)?.doubleValue,
            let theCurrentRate = AppState.sharedInstance.currentRate else {
            rateInfoLabel.text = ""
            return
        }

        let currency = AppState.sharedInstance.settings.selectedCurrency
        rateInfoLabel.text = EXAWalletFormatter.alternativeAmount(type: .total, currency: currency, amount: amount, rateValue: theCurrentRate)
    }

    private func validateAmountAndHighlight() {
        let result = validateAmount()
        amountView.incorrect = !result
        sendBtn.isEnabled = result
    }
}

