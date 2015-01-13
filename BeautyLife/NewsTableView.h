//
//  NewsTableView.h
//  BeautyLife
//
//  Created by Seven on 14-8-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  通知类列表模型
//

#import <UIKit/UIKit.h>
#import "NoticeTableCell.h"
#import "NewsDetailView.h"

@interface NewsTableView : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate>
{
    //通知数组
    NSMutableArray * news;
    //是否加载中
    BOOL isLoading;
    //是否全部加载
    BOOL isLoadOver;
    //新闻当前总数
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (weak, nonatomic) IBOutlet UITableView *newsTable;

//类型标记
@property int catalog;
#pragma -mark 重现加载类型数据
- (void)reloadType:(int)ncatalog;
#pragma -mark 刷新数组
- (void)reload:(BOOL)noRefresh;

//清空
- (void)clear;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
