//
//  SBTextField.swift
//  shadowrocket
//
//  Created by 王剑鹏 on 2020/8/28.
//  Copyright © 2020 waing. All rights reserved.
//

import UIKit

enum ValidationError : Swift.Error {
    /// 状态码错误
    case empty(String?)
    /// model解析错误
    case range(String?, (UInt, UInt))
    /// email格式错误
    case email(String?)
    
    case password(String?)
}


class SBTextField: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tintClearImage()
    }
    
    private var tintedClearImage: UIImage?
    /// 给清空按钮染色
    private func tintClearImage() {
        for view in subviews where view is UIButton {
            guard let button = view as? UIButton,
                  let image = button.image(for: .highlighted) else { continue }
            if self.tintedClearImage == nil {
                tintedClearImage = image.withTintColor(UIColor.white)
            }
            button.setImage(self.tintedClearImage, for: .normal)
            button.setImage(self.tintedClearImage, for: .highlighted)
        }
    }
    
    
    /// TextField的名称
    var name : String?
    /// 长度范围
    var range : (UInt, UInt)?
    
}

//MARK: 内容校验
extension SBTextField {
    
    /// 校验是否为空 , 判断字数范围
    /// - Throws: 抛出 ValidationError 错误
    /// - Returns: 返回 清除前后空格与换行的字符串
    func validatedNone() throws -> String {
        guard var text = self.text, text.isEmpty else {
            throw ValidationError.empty(self.name)
        }
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let range = range {
            let maxCount = max(range.0, range.1)
            let minCount = min(range.0, range.1) // 取出最小值，最小值不小于0
            assert(maxCount >= minCount, "输入框:\(self.name ?? self.description),范围\(range)配置错误")
            if minCount...maxCount ~= UInt(text.count) {
                throw ValidationError.range(self.name, (minCount, maxCount))
            }
        }
        self.text = text
        return text
    }
    
    
    /// 校验邮箱
    /// - Throws: 抛出 ValidationError 错误
    /// - Returns: 返回邮箱
    func validatedEmail() throws -> String {
        do {
            let text = try validatedNone()
            if validatedRegularExpression(
                "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$",
                text: text) {
                return text
            }else{
                throw ValidationError.email(self.name)
            }
        }
    }
    
    fileprivate func validatedRegularExpression(_ pattern: String, text: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex.firstMatch(in: text, options: [], range: range) != nil
    }
    
    
    /// 密码判断
    /// - Parameter equal: 传入之后 如果不相等也当做错误，
    /// 不传入的话 只判空与长度校验
    func validatedPassword(_ equal: String? = nil) throws -> String {
        let text = try validatedNone()
        if let equalText = equal {
            if text == equalText {
                return text
            }else {
                throw ValidationError.password(self.name)
            }
        }else {
            return text
        }
    }
}
