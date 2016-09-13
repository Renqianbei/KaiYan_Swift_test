//
//  VideoModel.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/9/8.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import Foundation

class VideoModel: NSObject {
    
    var dataType : String!
    var id : Int = 0
    var hello : Float32 = 0
    var hello2 : Int32 = 0
    var num : NSNumber!
    var text : NSDate!
    var title : String!
    var vdescription: String!
    var duration : Int = 0
    var playUrl : String!
    var provider : Provider!
    var cover :Cover!
    var category : String!
//    var author : String!
    var tags : [Tag]!
    override class  func propertyToKeys() -> Dictionary<String,String>?{
        return ["description":"vdescription"]
    }
    
    //数组值的key对应的类型
    override class  func arrayClassForKey(key:String) -> AnyClass?{
        if  key == "tags" {
            return Tag.classForCoder()
        }
        return nil
    }
    
    //字典值的key对应的类型
    override  class func dicClassForKey(key:String) -> AnyClass?{
        if key == "provider" {
            return Provider.classForCoder()
        }else if (key == "cover"){
            return Cover.classForCoder()
        }
        return nil
    }
    
    var image:String!{
        set{
            
        }
        get {
            return self.cover.detail ?? self.cover.feed ?? self.cover.blurred ?? ""
        }
    }
    
}

class Provider: NSObject {
    var name : String!
    var alias : String!
    var icon : String!
}


class Tag: NSObject {
    var id : Int = 0
    var name : String!
    var actionUrl : String!
    
}

//封面图
class Cover: NSObject {
    var feed : String!
    var detail : String!
    var blurred : String!
}


