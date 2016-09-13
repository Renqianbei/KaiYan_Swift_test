//
//  RQBApi_Helper.swift
//  NewListForEye
//
//  Created by 任前辈 on 16/8/30.
//  Copyright © 2016年 任前辈. All rights reserved.
//

import Foundation


struct APIHelper {
    
    static let API_Service = "http://baobab.wandoujia.com/api/v2/"
    // 一.每日精选api 参数 1.date:时间戳 2.num：数量(默认7)  date=1457883945551&num=7
    
    static let API_Choice = API_Service+"feed"
    /// 二.发现更多（分类） http://baobab.wandoujia.com/api/v2/categories
    
    static let API_Discover = API_Service+"categories"
    /// 三. 热门排行(周排行)
    static let API_Popular_Weakly = API_Service+"ranklist?strategy=weekly"
    /// 四.热门排行(月排行)
    static let API_Popular_Monthly = API_Service+"ranklist?strategy=monthly"
    /// 五.热门排行(总排行)
    static let API_Popular_Historical = API_Service+"ranklist?strategy=historical"
    /// 六.发现更多 - 按时间排序          参数：categoryId
    static let API_Discover_Date = API_Service+"videos?strategy=date"
    /// 七.发现更多 - 分享排行版          参数：categoryId
    static let API_Discover_Share = API_Service+"videos?strategy=shareCount"

}
