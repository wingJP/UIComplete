//
//  TipMaskView.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2020/6/30.
//  Copyright © 2020 waing. All rights reserved.
//

import UIKit

class TipMaskView: UIView {
    
    public struct TipModel {
        var tipView : UIView
        var text : String
    }
    
    
    let corners : UIRectCorner = [.topLeft, .topRight, .bottomLeft]
    
    
    public var tipList : [TipModel] = []

    var maskColor: UIColor = UIColor(white: 0, alpha: 0.5) {
        didSet {
            maskBackgroundLayer.backgroundColor = maskColor.cgColor
        }
    }
    
    fileprivate lazy var shapeLine : CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineJoin = .round;
        layer.lineDashPattern = [3,3]
        layer.lineWidth = 2
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        return layer
    }()
    
    /// 镂空剪切layer
    fileprivate var maskLayer: CAShapeLayer = {
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.fillRule = CAShapeLayerFillRule.nonZero
        return maskLayer
    }()
    
    /// 半透明黑色
    fileprivate lazy var maskBackgroundLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = self.maskColor.cgColor
        return layer
    }()
    
    
    fileprivate lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initSubView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubView()
    }
    fileprivate func initSubView() {
        self.layer.addSublayer(maskBackgroundLayer)
        maskBackgroundLayer.mask = self.maskLayer
        
        self.layer.addSublayer(shapeLine)
        self.addSubview(tipLabel)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextAction(_:))))
    }
    
    public func show(at view: UIView?) {
        view?.addSubview(self)
        self.frame = view?.bounds ?? .zero
        if let model = tipList.first {
            loadTipModel(model)
        }
    }
    
    @objc func nextAction(_ sender:UITapGestureRecognizer) {
        self.tipList.removeFirst()
        if let model = tipList.first {
            loadTipModel(model)
        }else{
            self.removeFromSuperview()
        }
        
    }
    
    var maxRadii : CGFloat = 50
    
    fileprivate func loadTipModel(_ model : TipModel) {
        
        tipLabel.text = model.text
        
        guard var tipFrame = model.tipView.superview?.convert(model.tipView.frame, to: self.superview) else { return }
        tipFrame = tipFrame.outsideRect(edge: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        let path = UIBezierPath(roundedRect: self.frame, cornerRadius: 0)
        if tipFrame.width / 2 > maxRadii {
            let maskPath = UIBezierPath(roundedRect: tipFrame,
                                        byRoundingCorners: UIRectCorner.allCorners,
                                        cornerRadii: CGSize(width: maxRadii / 4, height: maxRadii / 4))
            path.append(maskPath.reversing())
        }else{
            let center = CGPoint(x: tipFrame.midX, y: tipFrame.midY)
            path.append(UIBezierPath(arcCenter: center, radius: tipFrame.width / 2 ,
                                     startAngle: 0, endAngle: 2 * .pi, clockwise: true).reversing())
        }
        
        maskLayer.path = path.cgPath
        
        tipLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(self.snp.left).offset((tipFrame.minX - 20))
            make.bottom.equalTo(self.snp.top).offset((tipFrame.minY - 20))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        maskBackgroundLayer.frame = self.bounds
        
        let rect = tipLabel.frame.outsideRect(edge: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20))
        let radii = rect.height / 2
        let maskPath = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radii, height: radii))
        shapeLine.path = maskPath.cgPath
    }
}
public extension CGRect {
    func insideRect(edge :UIEdgeInsets) -> CGRect {
        return CGRect(x: self.minX + edge.left,
                      y: self.minY + edge.top,
                      width: self.width - edge.left - edge.right,
                      height: self.height - edge.top - edge.bottom)
    }
    func outsideRect(edge :UIEdgeInsets) -> CGRect {
        return CGRect(x: self.minX - edge.left,
                      y: self.minY - edge.top,
                      width: self.width + edge.left + edge.right,
                      height: self.height + edge.top + edge.bottom)
    }
}
