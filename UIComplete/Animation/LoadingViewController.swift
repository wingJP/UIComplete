//
//  LoadingViewController.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2020/7/25.
//  Copyright © 2020 waing. All rights reserved.
//

import UIKit

protocol LoadingAnimaable {
    var isAnimating : Bool { get }
    func startAnimating()
    func stopAnimating()
}

protocol Progresssabel {
    var progress : Float { get set }
}


class LoadingViewController: UIViewController {

    let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let scrollview = UIScrollView()
        self.view.addSubview(scrollview)
        scrollview.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollview.addSubview(stackView)
     
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollview.contentLayoutGuide)
            make.width.equalTo(view)
        }
        
//        let av = UIActivityIndicatorView()
//        av.hidesWhenStopped
        
        
        /// 添加view
        views.forEach { (view) in
            layoutLoadView(view)
        }
        
    }
    let views : [UIView] = [PointLoadingView(), CircularProgressView()]
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        views.forEach { (view) in
            if let anView = view as? LoadingAnimaable {
                anView.startAnimating()
            }
        }
        let timer = Timer.scheduledTimer(timeInterval: 0.2,
                                         target: self,
                                         selector: #selector(self.update),
                                         userInfo: nil, repeats: true)
    }
    
    var progress : Float = 0.1
    @objc func update() {
        progress += 0.1
        if progress >= 2 {
            progress = 0
        }
        views.forEach { (view) in
            if var anView = view as? Progresssabel {
                anView.progress = progress
            }
        }
    }
    
    
    
    func layoutLoadView(_ view: UIView) {
        view.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        stackView.addArrangedSubview(view)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
