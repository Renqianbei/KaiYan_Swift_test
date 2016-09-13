//
//  SecondViewController.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/9/6.
//  Copyright © 2016年 任前辈. All rights reserved.
//
import Alamofire
import Foundation

class SecondViewController: BaseViewController {
    
    var selectIndexPath : NSIndexPath!
    
    private lazy var refreshControl : UIRefreshControl = {
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SecondViewController.load😆Data), forControlEvents:.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString.init(string: "正在加载中", attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
        refreshControl.tintColor = UIColor.redColor()
        return refreshControl
        
    }()
    
    lazy var collectionView : UICollectionView! = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 5
        let view : UICollectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        view.backgroundColor = UIColor.whiteColor()
        view.registerClass(SecondCell.self, forCellWithReuseIdentifier: SecondCell.identifier)
        view.delegate = self
        view.dataSource = self
        
        view.addSubview(self.refreshControl)
        
        return view
    }()
    
    var models : [VideoModel]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load😆Data()
        
        view.addSubview(collectionView)
     
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    
    //获取数据
    func load😆Data()  {
        if !self.refreshControl.refreshing {
            self.showLoading()
        }
        request(.GET, APIHelper.API_Popular_Weakly).resopnseToSwiftJSON { (json, success, error) in
            
//            print(json,success,error)
            
            let array = json.dictionaryValue["videoList"]?.rawValue as! [AnyObject]
            
            self.models = array.map({ (dic) -> VideoModel in
                
                return VideoModel.modelWithDictionary(dic as! NSDictionary)
            })
            self.finishLoading()
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SecondViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
       return  self.models.count
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        
        (cell as! SecondCell).model = models[indexPath.item]
        let center = cell.center
        let frame = cell.frame
        cell.clipsToBounds = true
        cell.frame = CGRectZero
        cell.center = center
        
        UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .LayoutSubviews, animations: {
            cell.frame = frame
        },completion:nil)
    
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectIndexPath = indexPath
        
        let model = models[indexPath.item]
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SecondDetailViewController") as! SecondDetailViewController
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SecondCell.identifier, forIndexPath: indexPath) as! SecondCell
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if  (indexPath.item + 1)%3 == 1 {
            return CGSizeMake(UIConstant.SCREEN_Width - (collectionViewLayout as!UICollectionViewFlowLayout).minimumInteritemSpacing*2, 200)
        }else{
            return CGSizeMake((UIConstant.SCREEN_Width - (collectionViewLayout as!UICollectionViewFlowLayout).minimumInteritemSpacing*3)/2, 150)
        }
    }
    
    
    

}


extension SecondViewController : transNeedViewProtocol{
    
    var fromView: UIView?{
        
        return collectionView.cellForItemAtIndexPath(selectIndexPath)
    }
    
    var snapView: UIView{
        let view = fromView as! SecondCell
        let imageview = UIImageView()
        imageview.contentMode = .ScaleAspectFill
        imageview.image = view.imageView.image
        let frame = collectionView.convertRect(view.frame, toView: self.view)
        imageview.frame = frame
        return imageview
    }
    
    var animationTrainsTion: UIViewControllerAnimatedTransitioning?{
        
        let an = AppearAnimation()
        an.style = .scare
        return an
        
    }
    
    
}

