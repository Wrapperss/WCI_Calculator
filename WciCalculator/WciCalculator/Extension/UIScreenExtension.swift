//
//  UIScreenExtension.swift
//  WciCalculator
//
//  Created by Wrappers Zhang on 2017/10/28.
//  Copyright © 2017年 Wrappers. All rights reserved.
//

import UIKit

extension UIScreen {
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    class var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
}
