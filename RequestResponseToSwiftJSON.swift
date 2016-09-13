//
//  RequestResponseToJSON.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/8/30.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
extension Request {
    
    func resopnseToSwiftJSON( complicateHander : ( JSON,  Bool, ErrorType?) ->()) -> Self {
        
        self.responseJSON { //网络请求框架 自动解析出json数据
            
         (response : Response) in
            
            //结果转成JSON格式  便于取值 避免取值不必要崩溃
                var jsonValue : JSON
            
                if  response.result.isSuccess {
                    jsonValue = JSON(response.result.value!)  
                }else{
                    jsonValue = JSON.null
                }
            
            complicateHander(jsonValue,response.result.isSuccess,response.result.error)

        }
        
        return self
    }
}