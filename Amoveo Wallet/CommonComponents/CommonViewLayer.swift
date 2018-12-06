//
//  CommonViewLayer.swift
//
//  Created by Vladimir Malakhov on 02/07/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

typealias ViewLayer = UIViewController

class CommonViewLayer: ViewLayer {
    
    var onEnterBackground: DefaultCallback?
    
    private let notificationCenter = NotificationCenter.default
    
    init() {
        super.init(nibName: nil, bundle: nil)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardListener()
    }
}

private extension CommonViewLayer {
    
    func commonSetup() {
        setupUI()
    }
    
    func setupUI() {
        edgesForExtendedLayout = UIRectEdge()
    }
}

private extension CommonViewLayer {
    
    func addKeyboardListener() {
        notificationCenter.addObserver(self, selector: #selector(onEnterBackgroundEvent),
                                                 name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    func removeKeyboardListener() {
        notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification,
                                          object: nil)
    }
    
    @objc func onEnterBackgroundEvent() {
        DispatchQueue.main.async { [weak self] in
            self?.onEnterBackground?()
        }
    }
}
