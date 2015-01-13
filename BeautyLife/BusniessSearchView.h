//
//  BusniessSearchView.h
//  BeautyLife
//
//  Created by Seven on 14-8-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  商家搜索
//

#import <UIKit/UIKit.h>

#import "BMapKit.h"
#import "Shop.h"
#import "EGOImageView.h"
#import "BusinessCell.h"
#import "ConvCell.h"
#import "BusinessDetailView.h"
#import "ConvOrderView.h"

@interface BusniessSearchView : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>
{
    //商家数据
    NSMutableArray *shopData;
    MBProgressHUD *hud;
    //搜索关键字
    NSString *searchKey;
    UILabel *noDataLabel;
}

//我的定位模型
@property BMKMapPoint myPoint;
@property (strong, nonatomic) NSString *viewType;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
