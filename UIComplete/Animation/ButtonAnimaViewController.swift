//
//  ButtonAnimaViewController.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2020/2/22.
//  Copyright © 2020 waing. All rights reserved.
//

import UIKit

class ButtonAnimaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
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
            make.edges.equalTo(self)
        }
        
        reloadData()
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
