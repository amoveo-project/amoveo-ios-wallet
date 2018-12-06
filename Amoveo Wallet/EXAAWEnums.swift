//
// Created by Igor Efremov on 17/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

enum EXALocalizedString: String {
    case commonAppTitle = "COMMON_APP_TITLE",
         commonCopiedToClipboard = "COMMON_COPIED_TO_CLIPBOARD",
         commonSafeNote = "COMMON_SAFE_NOTE",
         commonClose = "COMMON_CLOSE",
         commonCancel = "COMMON_CANCEL",
         commonContinue = "COMMON_CONTINUE",
         commonSend = "COMMON_SEND",
         commonJoin = "COMMON_JOIN",
         commonOk = "COMMON_OK",
         commonApply = "COMMON_APPLY",
         commonError = "COMMON_ERROR",
         commonWarning = "COMMON_WARNING",
         commonSkip = "COMMON_SKIP",
         commonEnable = "COMMON_ENABLE",
         commonPassphrase = "COMMON_PASSPHRASE",
         commonPassphraseEnter = "COMMON_PASSPHRASE_ENTER",
         commonEnterPassword = "COMMON_ENTER_PASSWORD",
         restoreButton = "RESTORE_WALLET_BTN",

         deleteWallet = "DELETE_WALLET_BTN",
         exportPrivateKey = "EXPORT_PRIVATE_KEY",

         walletRestored = "WALLET_RESTORED",
         walletCreated = "WALLET_CREATED",

         walletPasswordTitle = "WALLET_PASSWORD_TITLE_HEADER",
         walletPasswordVerify = "WALLET_PASSWORD_VERIFY_PASS",
         walletPasswordChanged = "WALLET_PASSWORD_CHANGED",
         walletPasswordExplanation = "WALLET_PASSWORD_EXPLANATION",
         walletPasswordSkip = "WALLET_PASSWORD_SKIP",

         walletOptionCreate = "WALLET_OPTION_CREATE",
         walletOptionRestore = "WALLET_OPTION_RESTORE",

         setupPassEnterPass = "WALLET_PASSWORD_ENTER_PASS",

         tabDashboardTitle = "TAB_DASHBOARD_TITLE",
         tabSendTitle = "TAB_SEND_TITLE",
         tabReceiveTitle = "TAB_RECEIVE_TITLE",
         tabSettingsTitle = "TAB_SETTINGS_TITLE",

         restoreTitle = "RESTORE_TITLE",
         restoreEnterDescription = "RESTORE_ENTER_DESCRIPTION",
         restoreInfo = "RESTORE_INFO",

         receiveHeadTitle = "RECEIVE_HEAD_TITLE",

         settingsAbout = "SETTINGS_ABOUT",
         aboutText = "ABOUT_TEXT",

         settingsNode = "SETTINGS_NODE",

         scanTitle = "SCAN_TITLE",
         scanCameraUnavailable = "SCAN_CAMERA_UNAVAILABLE",

         createExplanationTitle = "CREATE_EXPLANATION_TITLE",
         createWalletTitle = "CREATE_VC_TITLE",

         sendYourself = "SEND_YOURSELF",

         pinCodeCreate = "PIN_CREATE_SECURITY_CODE",
         pinCodeEnter = "PIN_ENTER_SECURITY_CODE",
         pinCodeConfirm = "PIN_CONFIRM_SECURITY_CODE",

         bannerNoConnection = "BANNER_NO_CONNECTION",
         bannerNoResponding = "BANNER_NO_RESPONDING",
         bannerWrongRequest = "BANNER_WRONG_REQUEST",

         authBioTouchId = "AUTH_BIO_TOUCH_ID_STRING",
         authBioFaceId = "AUTH_BIO_FACE_ID_STRING",
         authBioEnterPassword = "AUTH_BIO_ENTER_PASSWORD",

         auth_error_base = "AUTH_ERROR_BASE",
         authErrorBioLockout = "AUTH_ERROR_BIO_LOCKOUT",
         auth_error_bio_notallowed = "AUTH_ERROR_BIO_NOTALLOWED",
         authErrorPasscodeNotSet = "AUTH_ERROR_PASSCODE_NOT_SET",

         auth_bio_touch_message_setup = "AUTH_BIO_TOUCH_MESSAGE_SETUP",
         auth_bio_face_message_setup = "AUTH_BIO_FACE_MESSAGE_SETUP",

         viewInBlockchain = "VIEW_IN_BLOCKCHAIN"

    var l10n: String {
        return EXACommon.l10n(self.rawValue)
    }
}

enum AWDialogMessage: Int {
    case WalletSuccessfullyCreated

    var description: String {
        switch self {
        case .WalletSuccessfullyCreated: return "New wallet successfully created"
        }
    }

    var title: String {
        switch self {
        default:
            return EXAAppInfoService.appTitle
        }
    }

    var buttonTitle: String {
        switch self {
        default:
            return l10n(.commonOk)
        }
    }
}

enum AWError: Error {
    case WalletCreatingError(message: String)
    case WalletRestoringError(message: String)
    case WalletOpeningError
    case InvalidRequest
    case ErrorResponse
    case InvalidPassword
    case ParsingTransactionError

    var description: String {
        switch self {
        case let .WalletCreatingError(message): return "\(message)".capitalizedOnlyFirst
        case let .WalletRestoringError(message): return "\(message)".capitalizedOnlyFirst
        case .WalletOpeningError: return "Wallet couldn't be opened"
        case .InvalidRequest: return "Invalid request"
        case .ErrorResponse: return "Error response"
        case .InvalidPassword: return "Invalid password"
        case .ParsingTransactionError: return "Parsing transaction error"
        }
    }

    var title: String {
        switch self {
        case .WalletCreatingError(_): return "Wallet Creating Error"
        case .WalletRestoringError(_): return "Wallet Restoring Error"
        default:
            return "Error"
        }
    }
}
