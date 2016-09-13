//
//  DetailViewController.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/8/31.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import APESuperHUD

let ImageView_TAG = 100

typealias  CallBack = (Int) -> ()


class DetailViewController: BaseViewController{
    
    var currentIndex:Int = 0
    var models : [ItemModel]!
    lazy var appearmation : AppearAnimation! = {
        let app = AppearAnimation()
        return app
    }()
    var backGesture : UIScreenEdgePanGestureRecognizer!
    

    var scrollToNextIndexCallBack : CallBack?
    
    lazy var mainScrollView : UIScrollView = {
        
        var scrollview : UIScrollView = UIScrollView.init(frame: self.view.bounds)
        scrollview.pagingEnabled = true
        scrollview.delegate  = self
        scrollview.bounces = false
        scrollview.backgroundColor = UIColor.whiteColor()
        return scrollview
    }()
    
    var titleLabel : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.enabled = false
        automaticallyAdjustsScrollViewInsets = false
        addGesture()
        initView()
      
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.yy_imageWithColor(UIColor.clearColor()), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage.yy_imageWithColor(UIColor.clearColor())
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.enabled = true

    }
    
    func addGesture() {
        backGesture = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(DetailViewController.popBack(_:)))
        backGesture.edges = .Left
        backGesture.delegate = self
        backGesture.enabled = true
        view.addGestureRecognizer(backGesture)
    }
    
    
    func popBack(gesture : UIScreenEdgePanGestureRecognizer) {
        let currentx = gesture.translationInView(view).x
        
        let progress = abs(currentx)/UIConstant.SCREEN_Width
        switch gesture.state {
        case .Began :
                print("手势开始....................")
                scrollToNextIndexCallBack?(currentIndex)
               self.appearmation.percentTransition = UIPercentDrivenInteractiveTransition()
               self.navigationController?.popViewControllerAnimated(true)

        case .Changed :
            (self.appearmation.percentTransition as? UIPercentDrivenInteractiveTransition)?.updateInteractiveTransition(progress)
        case .Ended , .Cancelled :
            if gesture.velocityInView(view).x>0 {
                self.appearmation.panIsCancle = false
                (self.appearmation.percentTransition as? UIPercentDrivenInteractiveTransition)?.finishInteractiveTransition()
                print("手势结束")
            }else{
                self.appearmation.panIsCancle = true
                (self.appearmation.percentTransition as? UIPercentDrivenInteractiveTransition)?.cancelInteractiveTransition()
                print("手势取消")
            }
            
            self.appearmation.percentTransition = nil
        default:break
            
        }
        
    }
    
    
    func initView() {
        
        
        let width = mainScrollView.frame.size.width
        let height = mainScrollView.frame.size.height
        
        let superView = UIScrollView()
        superView.frame = mainScrollView.bounds
        superView.contentSize = CGSizeMake(width, height)
        superView.alwaysBounceHorizontal = true
        superView.backgroundColor = UIColor.blackColor()
        superView.delegate = self
        view.addSubview(superView)
        
        //设置scrollview的大小 偏移量
        mainScrollView.contentSize = CGSizeMake(width * CGFloat(models.count), height)
        mainScrollView.contentOffset = CGPointMake(CGFloat(currentIndex)*width, 0)
        
        superView.addSubview(mainScrollView)
        
        for (i,model) in models.enumerate(){
            
            let imageView : UIImageView = UIImageView.init(frame: CGRectMake(width * CGFloat(i), 0, width, height/2))
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            imageView.yy_setImageWithURL(NSURL.init(string: model.feed ?? model.image ?? ""), placeholder: nil)
            mainScrollView.addSubview(imageView)
            let gesture = UITapGestureRecognizer.init(target: self, action:#selector(DetailViewController.clickImageView(_:)))
            imageView.tag = i + ImageView_TAG
            imageView .addGestureRecognizer(gesture)
            
            imageView.userInteractionEnabled = true
        }
        
        titleLabel = UILabel.init(frame: CGRectMake(0, height/2, width, height/2))
        titleLabel.textAlignment = .Left
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.text = models[currentIndex].title  + models[currentIndex].description
        titleLabel.numberOfLines = 0
        superView.addSubview(titleLabel)
        
    }

    
    
    func clickImageView(sender : UITapGestureRecognizer) {
        
        let model = models[(sender.view!.tag - ImageView_TAG)]
        guard model.playUrl != nil || model.playUrl != " " else {
            APESuperHUD.showOrUpdateHUD(icon: .SadFace, message: "无播放地址", duration: 0.5, presentingView: view, completion: nil)
            return
        }
        let vc = AVPlayerViewController()
        vc.player = AVPlayer.init(URL: NSURL.init(string: model.playUrl)!)
        vc.player?.play()
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    
    
    override func shouldReturn() -> Bool {
        
        scrollToNextIndexCallBack?(currentIndex)
        
        return true
    }
    
    
}


extension DetailViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        
        return false
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if mainScrollView.contentOffset.x%mainScrollView.frame.size.width == 0 && (mainScrollView.superview as? UIScrollView)?.contentOffset.x == 0{
            return true
            
        }else{
            return false
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    

}



extension DetailViewController : UIScrollViewDelegate {
    
    //MARK: scrollviewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        guard scrollView == mainScrollView else {
            if currentIndex == 0  {
                if scrollView.contentOffset.x>0 {scrollView.contentOffset = CGPointMake(0, 0)}
            }else {
                if scrollView.contentOffset.x<0 {scrollView.contentOffset = CGPointMake(0, 0)}
            }
            return
        }
        
        
        guard scrollView.contentOffset.x>0 else{
            return
        }
        let width = scrollView.frame.size.width
        
        var offx = scrollView.contentOffset.x - CGFloat(currentIndex)*scrollView.frame.size.width
        offx = offx > 0 ?offx:-offx
        
        let percent = 1 - offx/width
        
        titleLabel?.alpha = percent
        
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        
        
        guard scrollView == mainScrollView else {
            return
        }
        
        currentIndex = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        
        
        self.titleLabel.text = "      \(currentIndex): " + models[currentIndex].title + models[currentIndex].description
        UIView.animateWithDuration(0.3) {
            self.titleLabel.alpha = 1
        }
        
        
    }

}






extension DetailViewController : transNeedViewProtocol{
    
    //MARK: transNeedViewProtocol协议
    
    
    var toFrame: CGRect {
        
        return  view.convertRect(toView!.frame, fromView: mainScrollView)
        
    }
    
    
    var toView: UIView?{
        return   fromView
    }
    
    //又此控制器跳转到其它控制器时
    var fromView: UIView?{
        return   mainScrollView.viewWithTag(ImageView_TAG+currentIndex)
    }
    
    var snapView: UIView {
        
        let snap = UIImageView()
        snap.image = (fromView as! UIImageView).image
        snap.contentMode = .ScaleAspectFill
        snap.frame = toFrame
        return snap
    }
    
    var animationTrainsTion: UIViewControllerAnimatedTransitioning? {
        get {
            return self.appearmation
        }
    }
    

}


