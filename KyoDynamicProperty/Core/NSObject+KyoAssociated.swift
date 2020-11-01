//
//  NSObject+KyoAssociated.swift
//  KyoDynamicProperty
//
//  Created by 王建星 on 2020/11/1.
//

import Foundation
import UIKit

extension NSObject {
    fileprivate static let propertiesContainerKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "propertiesContainerKey".hashValue)
}

extension NSObject {
    var propertiesContainer: [String: AnyObject] {
        set {
            objc_setAssociatedObject(self,
                                     NSObject.propertiesContainerKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let pc = objc_getAssociatedObject(self, NSObject.propertiesContainerKey) as? [String: AnyObject] {
                return pc
            }
            
            let temp: [String: AnyObject] = [:]
            self.propertiesContainer = temp
            return temp
        }
    }
}
