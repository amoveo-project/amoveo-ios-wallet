//
//  EXACircleStrokeLoadingIndicator.swift
//
//  Created by Igor Efremov on 26/02/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

enum EXACircleStrokeLoadingIndicatorOption {
    case on, off
}

final class EXACircleStrokeLoadingIndicator: UIView {
    
    private let innerSize: CGSize = CGSize(width: 104, height: 104)
    private let loaderView: UIView = UIView(frame: CGRect.zero)
    private let logoImageView: UIImageView = UIImageView(image: EXAGraphicsResources.loaderImage)
    private let strokeCircleColor: UIColor = UIColor.white
    
    private(set) public var isAnimating: Bool = false
    private var strokeCircleLayer: CALayer?
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loaderView.frame = CGRect(origin: CGPoint.zero, size: innerSize)
        loaderView.backgroundColor = UIColor.mainColor
        self.addSubview(loaderView)
        self.backgroundColor = UIColor.clear
        initControl()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loaderView.center = convert(self.center, from: self.superview)
    }
    
    func startAnimating() {
        isHidden = false
        isAnimating = true
        loaderView.layer.speed = 1
        setUpAnimation()
        
        animateBackgroundColor(UIColor.rgba(0x000000de))
    }
    
    func stopAnimating() {
        isHidden = true
        isAnimating = false
        strokeCircleLayer?.removeAllAnimations()
        strokeCircleLayer?.removeFromSuperlayer()
        
        animateBackgroundColor(UIColor.clear)
    }
    
    private func initControl() {
        logoImageView.size = EXAGraphicsResources.loaderImage.size
        logoImageView.center = convert(loaderView.center, from: loaderView.superview)
        loaderView.addSubview(logoImageView)
        
        applyCircleMask()
        
        let outerCircle = outerCircleLayer(UIColor.rgb(0x557489))
        loaderView.layer.addSublayer(outerCircle)
    }
    
    private func outerCircleLayer(_ color: UIColor) -> CALayer {
        let outerCircleDistance: CGFloat = 6
        let imgSize = EXAGraphicsResources.loaderImage.size
        let imgSizeExt = CGSize(width: imgSize.width + outerCircleDistance, height: imgSize.height + outerCircleDistance)
        
        let outerCircle = layerWith(size: imgSizeExt, color: color)
        let outerCircleFrame = CGRect(
            x: (loaderView.layer.bounds.width - imgSizeExt.width)/2,
            y: (loaderView.layer.bounds.height - imgSizeExt.height)/2,
            width: imgSizeExt.width,
            height: imgSizeExt.height
        )
        
        outerCircle.frame = outerCircleFrame
        return outerCircle
    }
    
    private func applyCircleMask() {
        let c = convert(loaderView.center, from: loaderView.superview)
        let w = loaderView.frame.size.width
        let radius: CGFloat = ceil(w / 2)
        let circle = UIBezierPath(arcCenter: c, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        loaderView.mask(withPath: circle)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpAnimation() {
        let beginTime: Double = 0.5
        let strokeStartDuration: Double = 1.2
        let strokeEndDuration: Double = 0.7
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.byValue = Float.pi * 2
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = strokeEndDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = strokeStartDuration
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.beginTime = beginTime
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotationAnimation, strokeEndAnimation, strokeStartAnimation]
        groupAnimation.duration = strokeStartDuration + beginTime
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        strokeCircleLayer = outerCircleLayer(strokeCircleColor)
        if let theStrokeCircle = strokeCircleLayer {
            theStrokeCircle.add(groupAnimation, forKey: "animation")
            loaderView.layer.addSublayer(theStrokeCircle)
        }
    }
    
    fileprivate func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        let lineWidth: CGFloat = 2
        
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
        radius: size.width / 2,
        startAngle: -(.pi / 2),
        endAngle: .pi + .pi / 2,
        clockwise: true)
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = lineWidth
    
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    
        return layer
    }
}
