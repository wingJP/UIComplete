//
//  SBTextField.swift
//  shadowrocket
//
//  Created by 王剑鹏 on 2020/8/28.
//  Copyright © 2020 waing. All rights reserved.
//

import UIKit




class WATextField: UITextField, UITextFieldDelegate, TextValidationable {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tintClearImage()
    }
    
    
    //MARK: style
    private var tintedClearImage: UIImage?
    /// 给按钮染色
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
    
    typealias AttributedDic = [NSAttributedString.Key: Any]
    
    ///占位符 样式
    public var attributes : AttributedDic? = nil {
        didSet {
            placeholder = super.placeholder
        }
    }
    override var placeholder: String? {
        set {
            guard let attributes = attributes else {
                self.attributedPlaceholder = nil
                super.placeholder = newValue
                return
            }
            self.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes:attributes)
        }
        get {
            return self.attributedPlaceholder?.string
        }
    }

    /// TextField的名称
    var name : String?
    /// 长度范围
    var range : CountableClosedRange<Int>?
    
    /// 忽略空格
    var ignoreSpaces = true
    
    
    /// maxLange
    var maxLength : Int? {
        didSet {
            delegate = maxLength != nil ? self : nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= (maxLength ?? Int.max)
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//    }
}


//可校验
protocol TextValidationable: NSObject {
    
    var text : String? { get set }
    var ignoreSpaces : Bool { get }
    var range : CountableClosedRange<Int>? { get }
    
    func validatedNone() throws -> String
    func validatedEmail() throws -> String
    func validatedRegularExpression(_ re: String) throws -> String
    func validatedEquer(_ equal: String?) throws -> String
}

enum ValidationError : Swift.Error {
    /// 内容为空
    case empty
    /// 范围错误
    case range(Int, Bool)
    /// email格式错误
    case email
    /// 正则表达式错误
    case regular
    /// 不相等
    case notEquer
}


//MARK: 内容校验
extension TextValidationable {
    
    /// 校验是否为空 , 判断字数范围
    /// - Throws: 抛出 ValidationError 错误
    /// - Returns: 返回 清除前后空格与换行的字符串
    func validatedNone() throws -> String {
        guard var text = self.text else {
            throw ValidationError.empty
        }
        if ignoreSpaces {
            text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if text.isEmpty {
            throw ValidationError.empty
        }
        if let range = range ,!(range ~= text.count) {
            if text.count < range.lowerBound {
                throw ValidationError.range(range.lowerBound, true)
            }else {
                throw ValidationError.range(range.upperBound, false)
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
                throw ValidationError.email
            }
        }
    }
    
    /// 校验正则表达式
    /// - Throws: 抛出 ValidationError 错误
    /// - Returns: 返回校验结果
    func validatedRegularExpression(_ re: String) throws -> String {
        do {
            let text = try validatedNone()
            if validatedRegularExpression(re, text: text) {
                return text
            }else{
                throw ValidationError.email
            }
        }
    }
    
    fileprivate func validatedRegularExpression(_ pattern: String, text: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex.firstMatch(in: text, options: [], range: range) != nil
    }
    
    
    /// 相等错误
    /// - Parameter equal: 传入之后 如果不相等也当做错误，
    /// 不传入的话 只判空与长度校验
    func validatedEquer(_ equal: String? = nil) throws -> String {
        let text = try validatedNone()
        if let equalText = equal {
            if text == equalText {
                return text
            }else {
                throw ValidationError.notEquer
            }
        }else {
            return text
        }
    }
}
