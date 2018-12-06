//
//  AppInstructionLaunch.swift
//
//  Created by Vladimir Malakhov on 27/06/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

enum AppInstructionLaunchState {
    
    case `default`
    case authAttempt
    case authSuccess
    case authError
}

typealias RequiredAppInstruction = () -> ()
typealias OptionalAppInstruction = () -> ()

protocol AppInstructionLaunchProtocol {
    
    var authBioState: AppAuthenticationState? { set get }
    var authPinState: AppAuthenticationState? { set get }
    func instruction(required: @escaping RequiredAppInstruction,
                     optional: @escaping OptionalAppInstruction)
}

final class AppInstructionLaunch: AppInstructionLaunchProtocol {
    
    var authBioState: AppAuthenticationState? {
        didSet {
            if oldValue != authBioState {
                updateBioOrPinAuthState(authBioState)
            }
        }
    }
    
    var authPinState: AppAuthenticationState? {
        didSet {
            if oldValue != authPinState {
                updateBioOrPinAuthState(authPinState)
            }
        }
    }
    
    private var instruction: AppInstructionLaunchState = .authAttempt
    
    func instruction(required: @escaping RequiredAppInstruction,
                     optional: @escaping OptionalAppInstruction) {
        switch instruction {
        case .authSuccess:
            resetToDefault()
        case .default:
            optional()
        case .authAttempt:
            break
        case .authError:
            break
        }
        required()
    }
}

private extension AppInstructionLaunch {

    func updateBioOrPinAuthState(_ state: AppAuthenticationState?) {
        
        guard let state = state else {
            return
        }
        
        switch state {
            case .attempt: instruction = .authAttempt
            case .success: instruction = .authSuccess
            case .error: instruction = .authError
        }
    }
    
    func resetToDefault() {
        instruction = .default
    }
}
