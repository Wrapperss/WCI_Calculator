//
//  UIColorExtension.swift
//  WciCalculator
//
//  Created by Wrappers Zhang on 2017/10/28.
//  Copyright © 2017年 Wrappers. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
