//
//  UserDefineSwitch.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2020/6/29.
//  Copyright © 2020 waing. All rights reserved.
//

import UIKit

// MARK: temper

/*
class UserDefaultsSwitchableTemper {
    enum SwtichTemp : Int, UserDefaultsSwitchable {
        case switch1 = 0b1 //开关1
        case switch2 = 0b10 //开关1
        case switch3 = 0b100 //开关1
        case switch4 = 0b1000 //开关1
    }
    func test() {
        let ison = SwtichTemp.switch1.isOn
        SwtichTemp.switch1.setSwitch(isOn: !ison)
    }
}
*/


// MARK: main
/// 枚举  实现该协议,能够快速存储选择状态， 
protocol UserDefaultsSwitchable  {
    typealias RawValue = Int
    var rawValue : RawValue { get }
}

let defineKey = "com.UserDefaultsSwitch."

extension UserDefaultsSwitchable {
    fileprivate var saveKey : String {
        var arr = String(reflecting: self).components(separatedBy: ".")
        _ = arr.popLast()
        return defineKey + arr.last!
    }
    
    fileprivate var mainKey : Int {
        if let key = UserDefaults.standard.object(forKey: saveKey) as? Int {
            return key
        }
        return 0
    }
    
    func setSwitch(isOn newValue: Bool) {
        var _mainKey = self.mainKey
        if newValue {
            _mainKey = _mainKey | self.rawValue
        }else{
            _mainKey = _mainKey & ~self.rawValue
        }
        UserDefaults.standard.set(_mainKey, forKey: saveKey)
        UserDefaults.standard.synchronize()
    }
    
    var isOn : Bool {
        return mainKey & self.rawValue != 0
    }
    
    func check() {
        debugPrint(String(mainKey, radix: 2))
    }
}
