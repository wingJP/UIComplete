//
//  UserDefineSwitchViewController.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2020/6/29.
//  Copyright © 2020 waing. All rights reserved.
//

import UIKit


enum SwtichTest : Int, UserDefaultsSwitchable {
    case switch1 = 0b1 //开关1
    case switch2 = 0b10 //开关1
    case switch3 = 0b100 //开关1
    case switch4 = 0b1000 //开关1
}

class UserDefineSwitchViewController: UIViewController {

    @IBOutlet weak var switchA: UISwitch!
    @IBOutlet weak var switchB: UISwitch!
    @IBOutlet weak var switchC: UISwitch!
    @IBOutlet weak var switchD: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchA.isOn = SwtichTest.switch1.isOn
        switchB.isOn = SwtichTest.switch2.isOn
        switchC.isOn = SwtichTest.switch3.isOn
        switchD.isOn = SwtichTest.switch4.isOn
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        SwtichTest.init(rawValue: sender.tag)?.setSwitch(isOn: sender.isOn)
        
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
