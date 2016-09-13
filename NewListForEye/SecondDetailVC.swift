//
//  SecondDetailVC.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/9/8.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import APESuperHUD

class SecondDetailViewController: BaseViewController {
    
    var model : VideoModel!
    @IBOutlet weak  var imageView : UIImageView!
    @IBOutlet weak   var label : UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    func prepareView(){
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.yy_setImageWithURL(NSURL.init(string: model.image), placeholder: nil)
        let gesture = UITapGestureRecognizer.init(target: self, action:#selector(DetailViewController.clickImageView(_:)))
        imageView .addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        label.text = model.title + model.vdescription
    }
    
    
    func clickImageView(sender : UITapGestureRecognizer) {
        
        guard model.playUrl != nil || model.playUrl != " " else {
            APESuperHUD.showOrUpdateHUD(icon: .SadFace, message: "无播放地址", duration: 0.5, presentingView: view, completion: nil)
            return
        }
        let vc = AVPlayerViewController()
        vc.player = AVPlayer.init(URL: NSURL.init(string: model.playUrl)!)
        vc.player?.play()
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
}


extension SecondDetailViewController : transNeedViewProtocol{
    
    var toView: UIView?{
        return imageView
    }
    var toFrame: CGRect{
        return CGRectMake(0, 0, UIConstant.SCREEN_Width, UIConstant.SCREEN_HEIGHT/2)
    }
    
    var animationTrainsTion: UIViewControllerAnimatedTransitioning?{//由该页面返回没有动画
        return nil
    }
}