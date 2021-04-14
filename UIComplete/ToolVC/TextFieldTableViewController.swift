//
//  TextFieldTableViewController.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2021/4/14.
//  Copyright © 2021 waing. All rights reserved.
//

import UIKit

class TextFieldTableViewController: UITableViewController {

    @IBOutlet weak var textField: WATextField!
    @IBOutlet weak var tipLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.name = "测试输入框"
        textField.placeholder = "占位符"
        textField.range = 2...5
    }
    
    @IBAction func placeholderSwitch(_ sender: UISwitch) {
        if sender.isOn {
            textField.attributes = [
                .foregroundColor: UIColor.red,
                .font : UIFont.systemFont(ofSize: 12)
            ]
        }else {
            textField.attributes = nil
        }
    }
    
    @IBAction func maxLengthSwitch(_ sender: UISwitch) {
        if sender.isOn {
            textField.maxLength = 10
        }else {
            textField.maxLength = nil
        }
    }
    
    @IBAction func validationAction(_ sender: UIButton) {
        do {
            switch sender.tag {
            case 1: try textField.validatedNone()
            case 2: try textField.validatedEmail()
            case 3: try textField.validatedEquer("123")
            default:( )
            }
            tipLabel.text = "内容正确"
        }catch let error as ValidationError {
            tipLabel.text = error.message
        }catch {
            
        }
    }
    
}

extension ValidationError  {
    var message :String {
        switch self {
        case .empty: return "内容为空"
        case .range(let count, let sort): return sort ? "长度必须大于\(count)" : "长度必须小于\(count)"
        case .email: return "不是有效邮箱"
        case .regular: return "不是有效邮箱"
        case .notEquer: return "不相等"   
        }
    }

}
