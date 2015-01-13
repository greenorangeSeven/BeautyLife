//
//  ConvView.h
//  BeautyLife
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
// 联盟商家页面
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "Shop.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "BusinessCateCell.h"
#import "BusinessCell.h"
#import "BusinessDetailView.h"
#import "BusniessSearchView.h"

@interface BusinessView : UIViewController<UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    //商家数据
    NSMutableArray *shopData;
    //商家分类数据
    NSMutableArray *shopCateData;
    //定位点模型
    BMKMapPoint myPoint;
    //定位服务
    BMKLocationService* _locService;
    MBProgressHUD *hud;
    //所选分类
    NSString *catid;
    UILabel *noDataLabel;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *cateCollection;

@end
