//
//  HudExtension.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/8/31.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import Foundation
import APESuperHUD

extension UIViewController{
    
    func showLoading(message:[String] =  ["正在加载","别急嘛","妈的智障。。。","loading"]) {
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .Standard, messages:message, presentingView: view)
    }
    
    func finishLoading(animated animated : Bool = true , complicate : (()->Void)? = nil) {
        APESuperHUD.removeHUD(animated: animated, presentingView: view, completion: complicate)
    }
    
}

