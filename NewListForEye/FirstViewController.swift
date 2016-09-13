//
//  FirstViewController.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/8/30.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import APESuperHUD

class People: NSObject {
    var newname : String!
    var age : NSNumber!
    var teachers : [People]!
//    var wife : People!
    override  class func propertyToKeys() -> Dictionary<String, String>? {
        return ["name":"newname"]
    }
    override class  func arrayClassForKey(key:String) -> AnyClass?{
        if key == "teachers" {
            return classForCoder()
        }
        return nil
    }
}


class FirstViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,transNeedViewProtocol{
    
    var models : [IssueModel]!
    var didSelectIndex:NSIndexPath!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }
    
    override func viewDidLoad() {
        //
        super.viewDidLoad()
        APESuperHUD.appearance.foregroundColor = UIColor.blackColor()//设置加载控件样式
        APESuperHUD.appearance.textColor = UIColor.whiteColor()

        models = [IssueModel]() //初始化数组
    
        //创建tableView
        view.addSubview(tableView)
        
        loadData()
        
}
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //懒加载
    private lazy var tableView : UITableView = {
        
        
    
        
        var tableView : UITableView = UITableView.init(frame: self.view.bounds, style: UITableViewStyle.Plain)
        tableView.registerNib(UINib.init(nibName: String(FirstCell.self), bundle: nil), forCellReuseIdentifier: FirstCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UIConstant.ImageRowHeight
        
        tableView.addSubview(self.refreshControl)
        
        return tableView
    }()
    
    
    private lazy var refreshControl : UIRefreshControl = {
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FirstViewController.loadData(_:)), forControlEvents:.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString.init(string: "正在加载中", attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
        refreshControl.tintColor = UIColor.redColor()
        return refreshControl

    }()
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].itemList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = models[section]
        
        if let title = model.headerTitle {
            return title
        }else{
            return "\(model.publishTime)"
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(FirstCell.identifier, forIndexPath: indexPath) as! FirstCell
            cell.selectionStyle = .None
       
        let model  = models[indexPath.section]
        cell.model = model.itemList[indexPath.row]
       
        
        cell.callBack = {
            print($0.subTitle)
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        didSelectIndex = indexPath
        let detailVC = DetailViewController()
        detailVC.currentIndex = didSelectIndex.row
        
        detailVC.models = models[indexPath.section].itemList
        self.navigationController?.pushViewController(detailVC, animated: true)
        
       
        
        detailVC.scrollToNextIndexCallBack = { (index  ) in
           
            self.didSelectIndex = NSIndexPath.init(forRow: index, inSection: self.didSelectIndex.section)
           
            let paths = self.tableView.indexPathsForVisibleRows
            for path in paths! {
                if path.row == index {
                    return
                }
            }
            //index不在范围内 要滚过去
            self.tableView.scrollToRowAtIndexPath(self.didSelectIndex, atScrollPosition: .Top, animated: false)
            
        }
    }
    

    
    
    //MARK: 加载数据
    func loadData( loading : Bool = true) {
        
        if loading {showLoading()}
   
        
        request(.GET, APIHelper.API_Choice, parameters: ["date":"\(Int64(NSDate().timeIntervalSince1970*1000))","num":"7"], encoding: .URLEncodedInURL, headers: nil).resopnseToSwiftJSON { (json, success, error) in
    
            if loading {  self.finishLoading(animated : true )}
            self.refreshControl.endRefreshing()

            guard success else{
                return
            }
                  //解析。，
            let array = json.rawValue["issueList"] as! [NSDictionary]
            
            self.models = array.map({ return IssueModel.init(dict: $0)
                
            })
            
            
            self.tableView.reloadData()

            
        }
        
        
    }

    //MARK: 动画需要的初始视图跟位置
    
    var fromView: UIView?{
        return tableView.cellForRowAtIndexPath(self.didSelectIndex) as! FirstCell
    }
    
    var snapView: UIView{
        //获取点击的那个视图
        let cell = fromView as!FirstCell
        let snapShotView = UIImageView()
        snapShotView.frame = tableView.convertRect(cell.frame, toView: view)
        snapShotView.image = cell.imageV.image
        snapShotView.contentMode = .ScaleAspectFill
        return snapShotView
    }
    
    
    var toView: UIView?{
      
        let cell =  tableView.cellForRowAtIndexPath(self.didSelectIndex) ?? tableView.visibleCells.first
        
          print("第几行",self.didSelectIndex,"cell",cell)
      
        return cell
        
    }
    
    var toFrame: CGRect {
        let rect = tableView.convertRect(toView!.frame , toView: view!)
        return rect ?? CGRectZero
    }
    
    
}







