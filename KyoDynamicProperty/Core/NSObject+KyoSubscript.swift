//
//  NSObject+KyoSubscript.swift
//  KyoDynamicProperty
//
//  Created by 王建星 on 2020/11/1.
//

import Foundation

public extension NSObject {
    
    /// 获取或设置动态属性
    subscript(dynamicProperty key: String) -> AnyObject? {
        set {self.addProperty(name: key, value: newValue)}
        get {self.getProperty(name: key)}
    }
    
}
