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
        password.dotSize = CGSize(width: 40, height: 40)
        password.dataSource = self
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

extension ViewController: SBPasscodeFieldImageSource {
    func imageSource(_ passwordField: SBPasswordField, dotImageAtIndex: Int, filled: Bool) -> UIImage {
        if filled {
            return UIImage(named: "star_full")!
        }else {
            return UIImage(named: "star_empty")!
        }
    }
}


