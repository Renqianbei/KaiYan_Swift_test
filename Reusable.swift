//
//  Reusable.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/8/30.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import Foundation

protocol Reusable {
    static var identifier : String {get}
}

extension Reusable{
    static var identifier : String {
        return String(Self)
    }
}

/*
extension Reusable where Self : FirstCell {
    
    static var identifier : String {
        return String(Self)
    }
}
 */