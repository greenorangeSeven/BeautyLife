//
//  ConvView.h
//  BeautyLife
//
//  Created by mac on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  便民服务页面
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "Shop.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "BusinessCateCell.h"
#import "ConvCell.h"
#import "ConvOrderView.h"
#import "BusniessSearchView.h"

@interface ConvView : UIViewController<UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    // 商家模型数组
    NSMutableArray *shopData;
    // 商家类型数组
    NSMutableArray *shopCateData;
    //我的百度地图模型点
    BMKMapPoint myPoint;
    //百度地图定位服务
    BMKLocationService* _locService;
    MBProgressHUD *hud;
    //所选类型ID
    NSString *catid;
    UILabel *noDataLabel;
    //我的经纬度模型对象
    CLLocationCoordinate2D mycoor;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *cateCollection;

@end
