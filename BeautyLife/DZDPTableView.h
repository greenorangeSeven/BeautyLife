//
//  DZDPTableView.h
//  BeautyLife
//
//  Created by Seven on 14-11-22.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TQImageCache.h"
#import "DZDPTableCell.h"
#import "DZbusinesses.h"
#import "DZDPDetailView.h"

@interface DZDPTableView : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,IconDownloaderDelegate,CLLocationManagerDelegate>
{
    double latitude;
    double longitude;
    NSString *city;
    
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

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
