//
//  UIView+Layer.swift
//  validation
//
//  Created by Dmitriy Soloshenko on 17.04.2020.
//  Copyright © 2020 Dmitriy Soloshenko. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable public var borderColor:UIColor? {
        get {
            if let color = self.layer.borderColor {
                return  UIColor(cgColor: color)
            }
            return .black
        }
        set {
            self.layer.borderColor = newValue?.cgColor
           }
       }
       
    @IBInspectable public var borderWidth:CGFloat {
           get {
            return self.layer.borderWidth
           }
           set {
               self.layer.borderWidth = newValue
            }
       }
    
       @IBInspectable public var cornerRadius:CGFloat {
           get {
               return layer.cornerRadius
           }
           set {
               layer.cornerRadius = newValue
               layer.masksToBounds = newValue > 0
           }
       }
}
