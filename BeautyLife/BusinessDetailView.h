//
//  BusinessDetailViewViewController.h
//  BeautyLife
//
//  Created by mac on 14-8-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  商家详情（商家商品、优惠券）
//

#import <UIKit/UIKit.h>
#import "BusinessGoods.h"
#import "Coupons.h"
#import "Goods.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "StrikeThroughLabel.h"
#import "BusinessGoodCell.h"
#import "GoodsDetailView.h"
#import "CouponDetailView.h"
#import "BMapKit.h"
#import "StoreMapPointView.h"

@interface BusinessDetailView : UIViewController<SGFocusImageFrameDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIWebView *phoneCallWebView;
    //商品数据
    NSMutableArray *goods;
//优惠券数据
    NSMutableArray *coupons;
    MBProgressHUD *hud;
    //排序字段
    NSString *orderByStr;
    SGFocusImageFrame *bannerView;
    //优惠券数组指针
    int couponIndex;
}

//传递的商家模型
@property (weak, nonatomic) Shop *shop;
//商家名称
@property (weak, nonatomic) NSString *tjTitle;
//商家类型ID
@property (weak, nonatomic) NSString *tjCatId;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderSegmented;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *couponIv;
- (IBAction)segnebtedChangeAction:(id)sender;

@end
