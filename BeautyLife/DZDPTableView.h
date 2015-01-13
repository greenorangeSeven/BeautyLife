//
//  DZDPTableView.h
//  BeautyLife
//
//  Created by Seven on 14-11-22.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  大众点评页面
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TQImageCache.h"
#import "DZDPTableCell.h"
#import "DZbusinesses.h"
#import "DZDPDetailView.h"

@interface DZDPTableView : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,IconDownloaderDelegate,CLLocationManagerDelegate>
{
    //经纬度
    double latitude;
    double longitude;
    //城市
    NSString *city;
    
    //商家数据
    NSMutableArray * shops;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    BOOL isInitialize;
    TQImageCache * _iconCache;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (weak, nonatomic) IBOutlet UITableView *shopsTable;

- (void)reload:(BOOL)noRefresh;

//清空
- (void)clear;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) NSMutableDictionary *thumbDownloadsInProgress;

//定位控件
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
