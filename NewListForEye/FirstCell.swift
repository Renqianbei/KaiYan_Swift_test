//
//  FirstCell.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/8/30.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import UIKit

typealias   ClickEvent = (ItemModel)->()

class FirstCell: UITableViewCell,Reusable {
    
    
    var model : ItemModel!  {
        
        didSet {
            nameLabel.text = model.title + model.subTitle
            
            let image = model.feed ?? model.image ?? ""
            
            imageV.yy_setImageWithURL(NSURL(string:image), placeholder: nil, options:.Progressive, progress: nil, transform: nil, completion: nil)
//
            
        }
    }
    
    var callBack : ClickEvent?
    
    
    
    override func awakeFromNib() {
        //
        contentView.userInteractionEnabled = false
        imageV.contentMode = .ScaleAspectFill
    }
    
    @IBAction func play(sender: AnyObject) {
        print("播放")

        callBack?(model)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageV: UIImageView!
    
    
    
}
