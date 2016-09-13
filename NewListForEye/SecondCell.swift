//
//  SecondCell.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/9/8.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import UIKit

class SecondCell: UICollectionViewCell,Reusable  {
    
    var imageView:UIImageView!
    var label:UILabel!
    
    var model:VideoModel! {
        
        didSet{
            //修改图片
            imageView.yy_setImageWithURL(NSURL(string: model.image), placeholder: nil)
            label.text = model.vdescription
            //更新image大小
            
            imageView.frame = self.bounds
            var frame = self.bounds
            frame.size.height = frame.size.height/4
            frame.origin.y =  frame.size.height*3
            label.frame = frame
            
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        self.addSubview(imageView)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}