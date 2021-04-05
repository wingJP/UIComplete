//
//  CaptchaTextField.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2021/3/15.
//  Copyright © 2021 waing. All rights reserved.
//

import UIKit
import SnapKit
class CaptchaTextField: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViews()
    }
    fileprivate func initViews() {
        labels = (0..<captchaLength).map({ _ in
            let label = CharacterLabel()
            label.isUserInteractionEnabled = false
            return label
        })
        self.backgroundColor = UIColor.yellow
        self.delegate = self
        
        _ = labels.compactMap(stackView.addArrangedSubview)
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.isUserInteractionEnabled = false
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addTarget(self, action: #selector(updateLabels), for: .editingChanged)
    }
    var validCharacterSet = CharacterSet(charactersIn: "1234567890")
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let newText = text
            .map { $0 as NSString }
            .map { $0.replacingCharacters(in: range, with: string) } ?? ""
        let newTextCharacterSet = CharacterSet(charactersIn: newText)
        
        let isValidLength = newText.count <= captchaLength
        let isUsingValidCharacterSet = validCharacterSet.isSuperset(of: newTextCharacterSet)

        if isValidLength, isUsingValidCharacterSet {
            textField.text = newText
            sendActions(for: .editingChanged)
        }
        return false
    }
    
    /// 验证码长度
    open var captchaLength : Int = 4
    
    fileprivate var labels = [CharacterLabel]()
    fileprivate var stackView = UIStackView()
    
    
    /// 光标位置
    override func caretRect(for position: UITextPosition) -> CGRect {
        var index = 0
        if let text = self.text {
            index = text.count
            if index == captchaLength {
                return .zero
            }
        }
        let label = labels[index]
        var frame = stackView.convert(label.frame, to: self)
        frame.origin.x = frame.midX
        frame.origin.y = frame.height * 0.25
        frame.size.width = 2
        frame.size.height = frame.height * 0.5
        return frame
    }
    
    override var selectedTextRange: UITextRange? {
        get { return super.selectedTextRange }
        set { super.selectedTextRange = textRange(from: endOfDocument, to: endOfDocument) }
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        /// 只提供粘贴操作
        return action == #selector(paste(_:))
    }

    
    @objc
    private func updateLabels(isEditing: Bool = true) {
        if let text = self.text {
            var flag = isEditing
            for i in 0..<captchaLength {
                if i < text.count {
                    let index = text.index(text.startIndex, offsetBy: i)
                    labels[i].update(character: text[index], isFocusingCharacter: flag, isEditing: false)
                }else {
                    labels[i].update(character: nil, isFocusingCharacter: flag, isEditing: false)
                    flag = false
                }
            }
        }
    }

    override func becomeFirstResponder() -> Bool {
        defer { updateLabels() }
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        defer { updateLabels(isEditing: false) }
        return super.resignFirstResponder()
    }

    override func deleteBackward() {
        defer { sendActions(for: .editingChanged) }
        super.deleteBackward()
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        self.bounds
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect { .zero } // 隐藏文字
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect  { .zero } // 隐藏占位文字
    override func borderRect(forBounds bounds: CGRect) -> CGRect { .zero } // 隐藏边框
}

class CharacterLabel: UILabel {
    var isEditing = false
    var isFocusingCharacter = false

    func update(character: Character?, isFocusingCharacter: Bool, isEditing: Bool) {
        self.text = character.map { String($0) }
        self.isEditing = isEditing
        self.isFocusingCharacter = isFocusingCharacter
        self.textAlignment = .center
        self.font = .systemFont(ofSize: self.bounds.height / 2)
        
        self.layer.borderColor = isFocusingCharacter ? tintColor.cgColor : UIColor.systemGroupedBackground.cgColor
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGroupedBackground.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
