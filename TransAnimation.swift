//
//  TransAnimation.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/9/1.
//  Copyright © 2016年 任前辈. All rights reserved.
//

enum AnimationStyle {
    case roate
    case scare
}


class AppearAnimation : NSObject, UIViewControllerAnimatedTransitioning {
    var fromViewController : UIViewController!
    var toViewController : UIViewController!
    var percentTransition : UIViewControllerInteractiveTransitioning?
    var panIsCancle :Bool! = false
    var style : AnimationStyle = .roate
    
    var  duration : NSTimeInterval = 0.5
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //具体动画
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let containerView  = transitionContext.containerView()
        
        let fromView = (fromVC as! transNeedViewProtocol).fromView
        
        let fromViewsnapView = (fromVC as! transNeedViewProtocol).snapView
        
        let toFrame = (toVC as! transNeedViewProtocol).toFrame
        
        let  toView = (toVC as! transNeedViewProtocol).toView
        
        containerView?.addSubview(toVC.view)
        
        containerView?.addSubview(fromViewsnapView)
        
        toVC.view.alpha = 0
        toView?.alpha = 0
        fromView?.alpha = 0
        
        if  transitionContext.isInteractive() {
            
            UIView.animateWithDuration(duration, animations: {
                fromViewsnapView.frame = toFrame
                toVC.view.alpha = 1
                if self.style == .roate {
                fromViewsnapView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                fromViewsnapView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI*2))
                }
                
            }) { (bool) in
                fromViewsnapView.removeFromSuperview()
                toVC.view.alpha = 1
                toView?.alpha = 1
                fromView?.alpha = 1
                transitionContext.completeTransition(!self.panIsCancle)
            }
        }else{
            
            UIView.animateWithDuration(duration+0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 5, options: .LayoutSubviews, animations: {
                fromViewsnapView.frame = toFrame
                toVC.view.alpha = 1
                if self.style == .roate {
                    fromViewsnapView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                    fromViewsnapView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI*2))
                }
               
                fromVC.view.alpha = 0
                }, completion:
                { (bool) in
                    fromViewsnapView.removeFromSuperview()
                    toVC.view.alpha = 1
                    toView?.alpha = 1
                    fromView?.alpha = 1
                    fromVC.view.alpha = 1

                    transitionContext.completeTransition(!self.panIsCancle)
            })
            
        }
        
        
    }
}


protocol transNeedViewProtocol { //试图控制区转换  控制器遵循这个协议才能使用
    var fromView : UIView? {get} //需要变化截图的原图
    var snapView : UIView{get} //需要变化截图
    var toFrame : CGRect {get} //所要变化到的位置
    var toView : UIView?{get} //最终留在vc上的视图 替换snapView
    
    var animationTrainsTion : UIViewControllerAnimatedTransitioning?{get}
    
}

extension transNeedViewProtocol{
    var fromView : UIView? {
        return nil
    } //需要变化截图的原图
    
    var snapView:UIView {
        return UIView()
    }
    
    var toFrame :CGRect{
        return CGRectZero
    }
    var toView : UIView?{
        return nil
    }
    
    var animationTrainsTion : UIViewControllerAnimatedTransitioning?{
        get {
            return  AppearAnimation()
        }
    }
    
}
