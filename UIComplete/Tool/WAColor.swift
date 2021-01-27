//
//  WAColor.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2020/3/7.
//  Copyright © 2020 waing. All rights reserved.
//
import UIKit


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        assert(0...255 ~= red, "Invalid red component")
        assert(0...255 ~= green, "Invalid green component")
        assert(0...255 ~= blue, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(hex:Int ,alpha: CGFloat = 1) {
        self.init(
            red:   (hex >> 16) & 0xff,
            green: (hex >> 8 ) & 0xff,
            blue:   hex        & 0xff,
            alpha:  alpha
        )
    }
    
    open class var random : UIColor {
        UIColor(hue: CGFloat.random(in: 0..<1), saturation: 0.85, brightness: 0.85, alpha: 1)
    }
}
