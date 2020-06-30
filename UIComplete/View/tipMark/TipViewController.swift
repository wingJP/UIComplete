//
//  TipViewController.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2020/6/30.
//  Copyright © 2020 waing. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var view1: UIView!
    
    
    var maskView = TipMaskView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let play = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(playTapped))

        navigationItem.rightBarButtonItems = [add, play]
        
        maskView.tipList.append(.init(tipView: button1, text: "此功能为VIP功能，可免费试用七天"))
        maskView.tipList.append(.init(tipView: button2, text: "可免费试用七天"))
        maskView.tipList.append(.init(tipView: view1, text: "可免费试用七天"))
        
        
        if let barView = self.navigationItem.rightBarButtonItems?.first?.value(forKey: "view") as? UIView {
            maskView.tipList.append(.init(tipView: barView, text: "此功能为VIP功能，可免费试用七天"))
        }
//        maskView.tipList.append(.init(tipView: play.value(forKey: "view") as! UIView, text: "可免费试用七天"))
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        maskView.show(at: UIApplication.shared.keyWindow)
    }
    
    @objc func addTapped() {
        
    }
    @objc func playTapped() {
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
