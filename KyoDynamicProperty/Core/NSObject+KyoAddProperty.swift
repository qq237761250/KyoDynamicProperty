//
//  NSObject+KyoAddProperty.swift
//  KyoDynamicProperty
//
//  Created by 王建星 on 2020/11/1.
//

import Foundation

extension NSObject {
    
    static let getter: (AnyObject, Selector) -> AnyObject? = { (self1, _cmd1) -> AnyObject? in
        let key = NSStringFromSelector(_cmd1)
        return (self1 as? NSObject)?.propertiesContainer[key] as AnyObject?
    }
    
    static let setter: (AnyObject, Selector, AnyObject?) -> Void = { (self1, _cmd1, newValue) in
        //移除set
        let originKey = NSStringFromSelector(_cmd1)
        var key = originKey.replacingCharacters(in: Range(NSMakeRange(0, 3), in: originKey)!, with: "")
        //首字母小写
        let head = String(key[key.startIndex..<key.index(key.startIndex, offsetBy: 1)]).lowercased()
        key = key.replacingCharacters(in: Range(NSMakeRange(0, 1), in: key)!, with: head)
        //移除后缀 ":"
        key = key.replacingCharacters(in: Range(NSMakeRange(key.count - 1, 1), in: key)!, with: "")
        //赋值
        (self1 as? NSObject)?.propertiesContainer[key] = newValue
    }
    
    private func handlePropertyName(_ name: String) -> String {
        //转换为小写，因为如果属性名有大写会在[target setValue:value forKey:propertyName];中crash
        var propertyName = name.lowercased()
        //去掉特殊字符
        propertyName = propertyName.replacingOccurrences(of: "[^0-9a-zA-Z]+",
                                                         with: "",
                                                         options: .regularExpression,
                                                         range: propertyName.range(of: propertyName))
        //将前面的数字去掉
        while propertyName.range(of: "[0-9]+([A-Za-z]+)", options: .regularExpression, range: propertyName.range(of: propertyName), locale: nil) != nil {
            propertyName = propertyName.replacingOccurrences(of: "[0-9]+([A-Za-z]+)",
                                                             with: "$1",
                                                             options: .regularExpression,
                                                             range: propertyName.range(of: propertyName))
        }
        return propertyName
    }
    
    
    /// 动态添加属性（可以在propertylist中查到属性名）
    /// - Parameters:
    ///   - name: 属性名
    ///   - value: 值
    func addProperty(name: String, value: AnyObject?) {
        let propertyName = self.handlePropertyName(name)
        let ivar = class_getInstanceVariable(self.classForCoder, "_" + propertyName)
        guard ivar == nil else {
            self.setValue(value, forKey: "_" + propertyName)
            return
        }
        guard let value = value else {
            self.propertiesContainer[name] = nil
            return
        }
        
        let type = objc_property_attribute_t(name: ("T" as NSString).utf8String!,
                                             value: (("\"" + NSStringFromClass((value as AnyObject).classForCoder) + "\"") as NSString).utf8String!)
        let ownership = objc_property_attribute_t(name: ("&" as NSString).utf8String!,
                                                  value: ("N" as NSString).utf8String!)
        let backingivar = objc_property_attribute_t(name: ("V" as NSString).utf8String!,
                                                    value: (("_" + propertyName) as NSString).utf8String!)
        let attrs = [type, ownership, backingivar]
        if class_addProperty(self.classForCoder, propertyName, attrs, 3) == false {
            class_replaceProperty(self.classForCoder, propertyName, attrs, 3)
        }
        //添加getter
        let selGetter = NSSelectorFromString(propertyName)
        let blockGetter: (AnyObject) -> AnyObject? = { self1 -> AnyObject? in
            return NSObject.getter(self1, selGetter)
        }
        let impGetter = imp_implementationWithBlock(unsafeBitCast(blockGetter as @convention(block) (AnyObject) -> AnyObject?, to: AnyObject.self))
        class_addMethod(self.classForCoder, selGetter, impGetter, "@@:")
        //添加setter
        let selSetter = NSSelectorFromString("set" + propertyName.capitalized + ":")
        let blockSetter: (AnyObject, AnyObject?) -> Void = { self1, newValue in
            NSObject.setter(self1, selSetter, newValue)
        }
        let impSetter = imp_implementationWithBlock(unsafeBitCast(blockSetter as @convention(block) (AnyObject, AnyObject?) -> Void, to: AnyObject.self))
        class_addMethod(self.classForCoder, selSetter, impSetter, "v@:@")
        //赋值
        self.setValue(value, forKey: propertyName)
    }
    
    /// 获取动态添加的属性
    /// - Parameter name: 属性名
    func getProperty(name: String) -> AnyObject? {
        let propertyName = self.handlePropertyName(name)
        let ivar = class_getInstanceVariable(self.classForCoder, "_" + propertyName)
        guard ivar == nil else {
            return object_getIvar(self, ivar!) as AnyObject
        }
        return self.propertiesContainer[propertyName]
    }
    
}
