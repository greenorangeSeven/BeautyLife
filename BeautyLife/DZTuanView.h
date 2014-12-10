//
//  DZTuanView.h
//  BeautyLife
//
//  Created by Seven on 14-12-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQImageCache.h"
#import "DZDPDetailView.h"
#import "DZTuan.h"
#import "DZTuanCell.h"
#import "StrikeThroughLabel.h"

@interface DZTuanView : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,IconDownloaderDelegate>
{
    NSMutableArray *tuanIdList;
    
    NSMutableArray * tuans;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    BOOL isInitialize;
    TQImageCache * _iconCache;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (weak, nonatomic) IBOutlet UITableView *tuanTable;

- (void)reload:(BOOL)noRefresh;

//清空
- (void)clear;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@end
