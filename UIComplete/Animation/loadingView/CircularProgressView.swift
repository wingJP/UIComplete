//
//  VideoProgressView.swift
//  SBVideoTool
//
//  Created by 王剑鹏 on 2020/6/22.
//  Copyright © 2020 Lete. All rights reserved.
//

import UIKit

class CircularProgressView: UIView, Progresssabel {
    
    lazy var progressLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(netHex: 0xEEEEEE)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        return label
    }()
    
    /// 进度条底色
    lazy var backlayer : CALayer = {
        var layer = CALayer()
        layer.borderColor = UIColor(netHex: 0xEEEEEE).cgColor
        layer.borderWidth = lineWitch
        return layer
    }()
    
    /// 进度条
    lazy var progressLayer : CAShapeLayer = {
        let progressLayer = CAShapeLayer()
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.lineWidth = lineWitch + 1
        return progressLayer
    }()
    
    
    /// 进度条 头
    lazy var progressHeader : CALayer = {
        let progressHeader = CALayer()
        progressHeader.backgroundColor = UIColor(netHex: 0xB077FF).cgColor
        progressHeader.cornerRadius = lineWitch / 2
        return progressHeader
    }()
    
    // 渐变
    lazy var gradientLayer : CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.addSublayer(gradientLayer1)
        gradientLayer.addSublayer(gradientLayer2)
        return gradientLayer
    }()
    lazy var gradientLayer1 : CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.1,0.8]
        gradientLayer.colors = [UIColor(netHex: 0x521CC3).cgColor,
                                UIColor(netHex: 0x7A42DD).cgColor]
        return gradientLayer
    }()
    lazy var gradientLayer2 : CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(netHex: 0xB077FF).cgColor,
                                UIColor(netHex: 0x7A42DD).cgColor]
        gradientLayer.locations = [0.1,0.8]
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubView()
    }
    func initSubView() {
        self.layer.addSublayer(backlayer)
        self.layer.addSublayer(progressLayer)
        self.layer.addSublayer(gradientLayer)

        self.layer.addSublayer(progressHeader)
        
        self.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { (mark) in
            mark.centerX.equalToSuperview()
            mark.centerY.equalToSuperview()
        }
        progressLabel.text = "0%"
    }
    
    public let lineWitch : CGFloat = 9
    lazy var oneCode : Void = {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let rect = self.bounds.inset(by: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        backlayer.frame = rect
        backlayer.cornerRadius = rect.width / 2
        
        progressLayer.frame = bounds
        let path = UIBezierPath(arcCenter: CGPoint(x: (rect.width ) / 2 ,y: (rect.height )  / 2 ),
                                radius: (rect.width - lineWitch) / 2 ,
                                startAngle: toRadians(degrees: -90),
                                endAngle: toRadians(degrees: -91),
                                clockwise: true)
        progressLayer.path = path.cgPath
        progressLayer.strokeEnd = 0
        
        gradientLayer.frame = rect
        gradientLayer1.frame = CGRect(x: 0, y: 0,
                                      width: gradientLayer.bounds.width / 2 + lineWitch / 8,
                                      height: gradientLayer.bounds.height)
        gradientLayer2.frame = CGRect(x: gradientLayer.bounds.width / 2 - lineWitch / 8, y: 0,
                                      width: gradientLayer.bounds.width / 2 + lineWitch / 8 ,
                                      height: gradientLayer.bounds.height)
        gradientLayer.mask = progressLayer
        
        progressHeader.frame = CGRect(x: rect.minX + (rect.width - lineWitch) / 2, y: rect.minY, width: lineWitch , height: lineWitch)

        CATransaction.commit()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = oneCode
    }
    func toRadians(degrees:CGFloat) -> CGFloat {
        return .pi*(degrees)/180.0
    }
    
    func showAdded(to view: UIView?) {
        view?.addSubview(self)
        self.frame = view?.bounds ?? .zero
    }
    
    func hide() {
        self.removeFromSuperview()
        self.progressLayer.strokeEnd = 0
    }
    
    var progress : Float = 0.0 {
        didSet {
            CATransaction.begin()
            CATransaction.setDisableActions(progress == 0 ? true : false)
            progressLabel.text = String.init(format: "%d%%", Int(progress * 100.0))
            progressLayer.strokeEnd = CGFloat(progress / 1.0)
            CATransaction.commit()
        }
    }
}
