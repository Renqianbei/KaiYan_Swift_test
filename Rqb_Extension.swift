//
//  NSObject+Extension.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/9/7.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import Foundation

//protocol analysisProtocol {
//    //需要转换的key
//   static func propertyToKeys() -> Dictionary<String,String>?
//    //数组值的key对应的类型
//   static func arrayClassForKey(key:String) -> AnyClass?
//    //字典值的key对应的类型
//   static func dicClassForKey(key:String) -> AnyClass?
//}

extension NSObject{
    //需要转换的key
    class  func propertyToKeys() -> Dictionary<String,String>?{
        return nil
    }
    //数组值的key对应的类型
    class  func arrayClassForKey(key:String) -> AnyClass?{
        return nil
    }
    //字典值的key对应的类型
    class func dicClassForKey(key:String) -> AnyClass?{
        return nil
    }

}

extension NSObject {
    
    static func modelWithDictionary(dic : NSDictionary) -> Self {
        
        let object = self.init()
        print(dic)
        //运行时
        let KEYANDTYPE = propertyNameAndTypes()
        let pkeys = KEYANDTYPE.allKeys as! [String]
        
        let keysForOldKeys = self.propertyToKeys()
        
        for (key,value) in dic {
            
            let newkey = keysForOldKeys?[key as! String ] ?? key //1.有没有要替换的key
            var newValue = value
            
            if pkeys.contains(newkey as! String) {
                
                if value.isKindOfClass(NSArray.self) {
                    
                    if  let type = arrayClassForKey(newkey as! String )  {//如果数组中是字典
                      
                        newValue = NSMutableArray()
                        for o in value as! NSArray {
                            if o.isKindOfClass(NSDictionary.self){
                                let model = type.modelWithDictionary(o as! NSDictionary)
                                newValue.addObject(model)
                            }
                           
                        }
                    }
                    
                }else if (value.isKindOfClass(NSDictionary.self)){
                    
                    if let type = dicClassForKey(newkey as! String) {
                       
                        newValue = type.modelWithDictionary(value as! NSDictionary)

                    }

                    
                }
                
                
                if !value.isKindOfClass(NSNull.self){
                    object.setValue(newValue, forKey: newkey as! String )

                }
            }
        }
        
        return object
    }
    
    
    //获取成员变量名 和 类型（暂时获取的无效 目前swift好像获取的值没有）
    static func propertyNameAndTypes() -> NSMutableDictionary{
        
        var count : UInt32 = 0
        let propertys = class_copyPropertyList(self, &count)
        let dic = NSMutableDictionary()
        
        for i in 0 ..< Int(count)  {
            
            let p = propertys[i]
            let vName = property_getName(p)
            let typeCode = property_getAttributes(p)
            
            let name = String.fromCString(vName)!
            let CodeString = String.fromCString(typeCode)
                dic[name] = self.transformTypeFromCodeString(CodeString!)
        }
        
        return dic
        
    }
    
    
    static func transformTypeFromCodeString(code : String) -> String{
        
        let name  =  NSBundle.mainBundle().infoDictionary![(kCFBundleExecutableKey as String)] as! String
        var type : String = ""
        if code.hasPrefix("T@") {//说明是对象
          let newCode =  code.componentsSeparatedByString("\"")[1]
            if newCode.containsString(name) {
                let  range = newCode.rangeOfString(name)
                
                type = newCode.substringWithRange((range?.endIndex)! ..< newCode.endIndex)
                var num : String = ""
                for c in type.characters {
                    if c >= "0" && c <= "9"{
                        num += String(c)
                    }else{
                        break
                    }
                }
                
                let numRange = type.rangeOfString(num)
                type = type.substringWithRange(Range(numRange!.endIndex ..< type.endIndex))
                
            }else{
                
                type = newCode
                
            }
            
            
        }else{
            let rangeOfType = Range(code.startIndex.advancedBy(1) ... code.startIndex.advancedBy(1))
            type = code.substringWithRange(rangeOfType)
        }
        
        return type
    }
    
    
}


      /*
         属性类型编码 可以看这个去找表
        https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW1
         
        T@"NSString",N,C,VdataType
        Tq,N,Vid
        Tf,N,Vhello
        Ti,N,Vhello2
        T@"NSNumber",N,&,Vnum
        T@"NSDate",N,&,Vtext
        T@"NSString",N,C,Vtitle
        T@"NSString",N,C,Vvdescription
        Tq,N,Vduration
        T@"NSString",N,C,VplayUrl
        T@"_TtC13NewListForEye8Provider",N,&,Vprovider
        T@"_TtC13NewListForEye5Cover",N,&,Vcover
        T@"NSString",N,C,Vcategory
        T@"NSString",N,C,Vauthor
        T@"NSArray",N,C,Vtags              
        T@"NSString",N,C
        */
        

