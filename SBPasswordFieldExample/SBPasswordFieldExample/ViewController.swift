//
//  ViewController.swift
//  SBPasswordFieldExample
//
//  Created by 宋碧海 on 2016/12/16.
//  Copyright © 2016年 songbihai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        
        let pass = SBPasswordField(frame: CGRect(x: 40, y: 50, width: UIScreen.main.bounds.width - 80, height: 50))
        pass.dotSize = CGSize(width: 10, height: 10)
        pass.keyboardType = .numberPad
        view.addSubview(pass)
        
        let password = SBPasswordField(frame: CGRect(x: 40, y: 140, width: UIScreen.main.bounds.width - 80, height: 50))
        //password.backgroundColor = UIColor.white
        password.dotSize = CGSize(width: 40, height: 40)
        //insertRegularExpression的pattern设置为"[^0-9]+"，只能输入数字跟设置keyboardType为.numberPad效果一样
        //password.insertRegularExpression = try? NSRegularExpression.init(pattern: "[^0-9]+", options: [])
        password.keyboardType = .emailAddress
        password.dataSource = self
        password.delegate = self
        view.addSubview(password)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension ViewController: SBPasscodeFieldImageSource, SBPasscodeFieldDelegate {
    func imageSource(_ passwordField: SBPasswordField, dotImageAtIndex: Int, filled: Bool) -> UIImage {
        if filled {
            return UIImage(named: "star_full")!
        }else {
            return UIImage(named: "star_empty")!
        }
    }
    
    func shouldInsert(_ passwordField: SBPasswordField, text: String) -> Bool {
        print("shouldInsert: " + text)
        return true
    }
    
    func shouldDeleteBackward(_ passwordField: SBPasswordField) -> Bool {
        print("shouldDeleteBackward: " + (passwordField.password ?? "is nil"))
        return true
    }
}


