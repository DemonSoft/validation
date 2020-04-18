//
//  DSValidationManager.swift
//  validation
//
//  Created by Dmitriy Soloshenko on 17.04.2020.
//  Copyright © 2020 Dmitriy Soloshenko. All rights reserved.
//

import UIKit

@objc protocol IValidationManager : class {
    func verificated()
}

@objc protocol IValidatable : class {
    var isValid: Bool { get }
}

class DSValidationManager : UIControl, IValidationManager
{
    @IBOutlet var verifiedControls: [UIControl]?
    @IBOutlet var managedControls: [UIControl]?

    private (set) var valid : Bool = false {
        didSet {
            self.sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.verificated()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.verificated()
    }

    func verificated() {
        self.checkVerifiedControls()
        self.controlsAction()
    }

    private func checkVerifiedControls() {
        guard let list:[IValidatable] = self.verifiedControls?.filter({$0 is IValidatable}) as? [IValidatable]
            else { return }
        self.valid = list.filter({!$0.isValid}).count == 0
    }
    
    private func controlsAction() {
        guard let list = self.managedControls else { return }
        for item in list {
            item.isEnabled = self.valid
        }
    }
}
