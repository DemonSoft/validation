//
//  DSTextField.swift
//  validation
//
//  Created by Dmitriy Soloshenko on 17.04.2020.
//  Copyright © 2020 Dmitriy Soloshenko. All rights reserved.
//

import UIKit

class DSTextField: UITextField, IValidatable
{
   
    
    @IBInspectable var valueRequired :Bool         = false
    @IBInspectable var borderMistakeColor :UIColor = .clear
    @IBInspectable var borderEmptyColor :UIColor   = .clear
    @IBInspectable var borderFilledColor :UIColor  = .clear
    @IBInspectable var expression :String          = ""
    @IBInspectable var mistake :String             = ""
    @IBInspectable var showMistake :Bool           = true

    @IBOutlet var validateDelegates: [IValidationManager]?
    private let label = UILabel()
    
    var isValid: Bool {
        return self.text.verification(self.expression, required:self.valueRequired)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustView()
    }
    
    override func layoutSubviews() {
        self.appendLabel()
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.adjustView()
    }
    
    private func adjustView() {
        self.addTarget(self, action: #selector(self.textEditAction(_:)), for: .editingChanged)
        self.addTarget(self, action: #selector(self.textEditEndedAction(_:)), for: .editingDidEnd)
    }
    
    private func appendLabel() {
        if let _ = self.label.superview { return }
        guard let superview = self.superview else { return }

        superview.addSubview(self.label)
        let height:CGFloat = 20
        
        NSLayoutConstraint.activate([
        self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
        self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: -height-1),
        self.label.heightAnchor.constraint(equalToConstant: height)
        ])
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.text = self.mistake
        self.label.font = UIFont.systemFont(ofSize: 12)
        self.label.textColor = self.borderMistakeColor
        self.label.isHidden = true
    }
    
    
    @objc func textEditAction(_ sender: UITextField) {
        self.handleDelegateAction(sender)
        sender.borderColor = self.calcBorderColor(sender)
        if !self.label.isHidden {
            self.label.isHidden = self.isValid
        }
    }
    
    @objc func textEditEndedAction(_ sender: UITextField) {
        if self.mistake.count == 0 { return }
        self.label.isHidden = self.isValid && self.showMistake
    }
    
    private func calcBorderColor(_ sender: UITextField) -> UIColor {
        if !self.isValid {
            return self.borderMistakeColor
        }
        
        if let text = sender.text, text.count > 0 {
            return self.borderFilledColor
        }
        
        return self.borderEmptyColor
    }
    
    private func handleDelegateAction(_ sender: UITextField) {
        guard let list = self.validateDelegates else { return }

        for validateDelegate in list {
            validateDelegate.verificated()
        }
    }
}
