//
//  RqbConstant.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/8/30.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import UIKit
//swift中没有宏 可以用全局常量来表示  也可以用函数
let THEME_COLOR = UIColor.init(white: 0, alpha: 0.8)

func IOS_8() -> Bool {
    print(Double(UIDevice.currentDevice().systemVersion))
    
    return    Double(UIDevice.currentDevice().systemVersion) >= 8.0
}




struct UIConstant {
    
    static let SCREEN_Width : CGFloat = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT : CGFloat = UIScreen.mainScreen().bounds.height
    
    // 导航栏高度
    static let UI_NAV_HEIGHT : CGFloat = 64
    // tab高度
    static let UI_TAB_HEIGHT : CGFloat = 49

    static let ImageRowHeight : CGFloat = 250
    
}