//
//  BaseViewController.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/8/30.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import UIKit



class BaseViewController: UIViewController{

    override func viewDidLoad() {
        //
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        //创建tableView
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shouldReturn() -> Bool {
        return true
    }
    

}




