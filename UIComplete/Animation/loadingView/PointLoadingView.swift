//
//  SBLoadingView.swift
//  SBVideoTool
//
//  Created by 王剑鹏 on 2020/7/2.
//  Copyright © 2020 小毅. All rights reserved.
//

import UIKit

@IBDesignable class PointLoadingView: UIView, LoadingAnimaable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubView()
    }
    override func tintColorDidChange() {
        layerList.forEach({ $0.backgroundColor = tintColor.cgColor })
    }
    
    var layerList = [CALayer]()
    var pointCount = 8
    func initSubView() {
        for i in 0..<pointCount {
            let layer = CALayer()
            layer.backgroundColor = tintColor.cgColor
            layer.opacity = 1 - Float(i) * 0.1
            self.layer.addSublayer(layer)
            layerList.append(layer)
        }
    }
    fileprivate var _center : CGPoint = .zero 
    
    fileprivate var _radius : CGFloat { return bounds.width / 2 - 10 }
    fileprivate var path : UIBezierPath {
        return UIBezierPath(arcCenter: _center,
                            radius: _radius,
                            startAngle: -.pi / 2,
                            endAngle: .pi / 2 * 3, clockwise: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let pointRadius = bounds.width / 16
        if bounds.midX != 0 && bounds.midY != 0 { // 避免在stackview 中被折叠导致定位错误
            _center = CGPoint(x: bounds.midX, y: bounds.midY)
            stopAnimating()
            if isAnimating {            
                startAnimating()
            }
        }
        for (index ,layer) in layerList.enumerated() {
            layer.setRadius(pointRadius * (1 - CGFloat(index) * 0.08))
            layer.position = position(atCenter: _center,
                                      radius: _radius,
                                      angle: 0)
        }
    }
    
    func position(atCenter center: CGPoint, radius r: CGFloat, angle: CGFloat) -> CGPoint {
        let radians = angle * (.pi / 180.0);
        let pointY = center.y - (cos(radians) * r); // specific point y on the circle for the angle
        let pointX = center.x + (sin(radians) * r); // specific point x on the circle for the angle
        return CGPoint(x: pointX, y: pointY)
    }
    
    
    
    var isAnimating = false
    var hidesWhenStopped = false
    func startAnimating() {
        if isAnimating {
            return
        }
        if _center == .zero && bounds.midX != 0 && bounds.midY != 0 { // 避免在stackview 中被折叠导致定位错误
            _center = CGPoint(x: bounds.midX, y: bounds.midY)
        }
        isAnimating = true
        self.isHidden = false
        for (index ,layer) in layerList.enumerated() {
            let timeOffset = 0.15 * Double(index)
            let rotation = CAKeyframeAnimation(keyPath: "position")
            rotation.path = path.cgPath
            rotation.duration = 3
            rotation.continuityValues = [0, 0.25, 0.5, 0.75, 1]
            rotation.keyTimes         = [0, 0.15, 0.3, 0.45, 0.6, 1]
            rotation.repeatCount = Float.greatestFiniteMagnitude
            rotation.isAdditive = false
            rotation.beginTime = CACurrentMediaTime() + timeOffset
            layer.add(rotation, forKey: "rotationAnimation")
        }
    }
    
    func stopAnimating() {
        layerList.forEach({ $0.removeAllAnimations() })
        if hidesWhenStopped {
            self.isHidden = true
        }
        isAnimating = false
    }
    
}

extension CALayer {
    func setRadius(_ radius: CGFloat) {
        var frame = self.frame
        frame.size = CGSize(width: 2 * radius, height:  2 * radius)
        self.frame = frame
        self.cornerRadius = radius
    }
}
