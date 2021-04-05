//
//  CaptchaViewController.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2021/3/15.
//  Copyright © 2021 waing. All rights reserved.
//

import UIKit

class CaptchaViewController: UIViewController {

    @IBOutlet weak var textField: CaptchaTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
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
