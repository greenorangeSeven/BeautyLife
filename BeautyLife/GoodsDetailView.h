//
//  GoodsDetailView.h
//  BeautyLife
//  商品详情
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "ShoppingCartView.h"

@interface GoodsDetailView : UIViewController<UIWebViewDelegate>
{
    //商品详情模型
    Goods *goodDetail;
    MBProgressHUD *hud;
}

//页面传递商品基本信息
@property (weak, nonatomic) Goods *good;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *picIv;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *addShopCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;

// 购物车点击
- (IBAction)toShoppingCartAction:(id)sender;
//马上购买点击
- (IBAction)buyAction:(id)sender;

@end
