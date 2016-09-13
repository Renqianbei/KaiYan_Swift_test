//
//  BaseNavigationController.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/9/1.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import Foundation

class BaseNavigationController: UINavigationController,UINavigationBarDelegate,UIGestureRecognizerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self;
    }
    
    //MARK : UINavigationBarDelegate
    func navigationBar(navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool // same as push methods
    {
        //滑动返回也会调用
        if self.viewControllers.count < navigationBar.items?.count {
            return true
        }
        
        
        
        let vc  = self.topViewController as? BaseViewController
        
        let bool : Bool = vc?.shouldReturn() ?? true
        
        if bool {
            self.popViewControllerAnimated(true)
        }
        
        return bool
    }
    

    

    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers[0] {
                return false
            }
        }
        
        return true
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool{ //允许多手势识别
        
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return otherGestureRecognizer is UIScreenEdgePanGestureRecognizer
    }

}


extension BaseNavigationController : UINavigationControllerDelegate {
    
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        

        if fromVC is transNeedViewProtocol && toVC is transNeedViewProtocol{
            return (fromVC as! transNeedViewProtocol).animationTrainsTion
        }else{
            return nil
        }
     
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if animationController is AppearAnimation {
            print("helloworld",(animationController as! AppearAnimation).percentTransition)
           
            return (animationController as? AppearAnimation)?.percentTransition
        }
        else{
            return nil
        }
        
    }
    
    
    
    
}