//
//  MainTabBuilder.swift
//
//
//  Created by Vladimir Malakhov on 05/07/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

protocol MainTabBuilderProtocol {
    func assembly(_ frameType: AppTabFrameType) -> UINavigationController
}

final class MainTabBuilder: MainTabBuilderProtocol {
    
    private var wireframe: AppWireframeProtocol
    
    init(wireframe: AppWireframeProtocol) {
        self.wireframe = wireframe
    }
    
    func assembly(_ frameType: AppTabFrameType) -> UINavigationController {
        var viewLayer = makeLayer(frameType)
        addTab(for: &viewLayer, with: frameType)
        addTitle(for: &viewLayer, with: frameType)
        let navigation = viewLayer.wrapWithNavigation()
        return navigation
    }
}

private extension MainTabBuilder {
    
    func makeLayer(_ frameType: AppTabFrameType) -> ViewLayer {
        let frame = wireframe.constructTabFrame(for: frameType)
        let viewLayer = frame.viewLayer
        return viewLayer
    }
    
    func addTab(for viewLayer: inout ViewLayer, with type: AppTabFrameType) {
        viewLayer.addTabBar(with: type)
    }
    
    func addTitle(for viewLayer: inout ViewLayer, with type: AppTabFrameType) {
        viewLayer.title = type.title
    }
}
