//
// Created by Igor Efremov on 20/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

enum EXATimerType {
    case transaction
}

private enum TimerState {
    case suspended
    case resumed
}

final class EXATimer {

    var eventHandler: (() -> ())?

    private var state: TimerState = .suspended
    private var timer: DispatchSourceTimer

    init(_ type: EXATimerType) {

        var interval = 0
        switch type {
        case .transaction: interval = 20
        }

        timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: .seconds(interval))
        timer.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
    }

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }

    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
