//
//  ShoppingCartView.h
//  BeautyLife
//
//  Created by Seven on 14-8-25.
//  Copyright (c) 2014年 Seven. All rights reserved.
//购物车界面
//

#import <UIKit/UIKit.h>
#import "ShoppingCartCell.h"
#import "EGOImageView.h"
#import "OrderInfo.h"
#import "OrderBusiness.h"
#import "OrderGood.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "GoodsDetailView.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "RMMapper.h"
#import "PrintObject.h"

@interface ShoppingCartView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,SGFocusImageFrameDelegate>
{
    //商品数组
    NSMutableArray *goodData;
    MBProgressHUD *hud;
    //加个合计
    float total;
    UILabel *noDataLabel;
    
    //广告商品
    NSMutableArray *goods;
    SGFocusImageFrame *bannerView;
    int goodIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *recommendIv;
@property (weak, nonatomic) IBOutlet UITableView *goodTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalLb;
//商品支付
- (IBAction)balanceAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end
