//
//  ViewController.swift
//  KyoDynamicProperty
//
//  Created by Kyo on 11/01/2020.
//  Copyright (c) 2020 Kyo. All rights reserved.
//

import UIKit
import KyoDynamicProperty

class Test: NSObject {
    var a = 0
    var b = 1
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self[dynamicProperty: "test"])
        
        let test = Test()
        test.a = 10
        self[dynamicProperty: "test"] = test
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let afterTest = self[dynamicProperty: "test"] as? Test
            print(afterTest?.a)
            print(afterTest?.b)
        }
        
        let a: Int = 12
        self[dynamicProperty: "testA"] = a as AnyObject
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let afterTestA = self[dynamicProperty: "testA"] as? Int
            print(afterTestA)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

