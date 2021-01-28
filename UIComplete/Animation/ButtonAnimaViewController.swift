//
//  ButtonAnimaViewController.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2020/2/22.
//  Copyright © 2020 waing. All rights reserved.
//

import UIKit
import SnapKit
class ButtonAnimaViewController: UIViewController {
    
    lazy var addButton : UIButton = {
        var btn = UIButton(type: .system)
        btn.setTitle("show", for: .normal)
        btn.addTarget(self, action: #selector(showAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var closeButton : UIButton = {
          var btn = UIButton(type: .system)
          btn.setTitle("close", for: .normal)
          btn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
          return btn
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initSubView()
        
        self.view.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view)
            make.left.equalTo(self.view).offset(100)
        }
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view)
            make.left.equalTo(self.view).offset(200)
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    private var scrollView = UIScrollView()
    
    func initSubView() {
        self.view.addSubview(scrollView)
        //        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaInsets)
            make.height.equalTo(120)
        }
        reloadData()
    }
    
    
    var buttonArray : [UIButton] = []
    let space = 20
    func reloadData() {
        var lastBtn : UIButton?
        for _ in 0..<6 {
            let button = UIButton(type: .custom)
            self.scrollView.addSubview(button)
            button.layer.cornerRadius = 30
            button.backgroundColor = UIColor.random
            button.snp.makeConstraints { (make) in
                make.height.width.equalTo(60)
                make.centerY.equalTo(self.scrollView)
                make.left.equalTo(lastBtn?.snp.right ?? self.scrollView.snp.left).offset(space)
            }
            buttonArray.append(button)
            lastBtn = button
        }
        lastBtn!.snp.makeConstraints { (make) in
            make.right.equalTo(self.scrollView).offset(-space)
        }
        buttonTransform()
    }
    
    func buttonTransform() {
        for button in self.buttonArray {
            button.transform = CGAffineTransform.init(translationX: 0, y: 100)
        }
    }
    
    @objc func showAction(){
        for (index, button) in self.buttonArray.enumerated() {
            UIView.animate(withDuration: 0.75, delay: Double(index) * 0.05,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.5,
                           options: .layoutSubviews,
                           animations: {
                            button.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    @objc func dismissAction(){
        for (index, button) in self.buttonArray.enumerated() {
            UIView.animate(withDuration: 0.75, delay: Double(index) * 0.05,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.5,
                           options: .layoutSubviews,
                           animations: {
                            button.transform = CGAffineTransform.init(translationX: 0, y: 100)
            }, completion: nil)
        }
    }
}
