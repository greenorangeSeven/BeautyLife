//
//  SubtleView.h
//  BeautyLife
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  精选特价
//

#import <UIKit/UIKit.h>
#import "BusinessDetailView.h"

@interface SubtleView : UIViewController<SGFocusImageFrameDelegate>
{
    MBProgressHUD *hud;
    //广告商品数据
    NSMutableArray *goods;
    SGFocusImageFrame *bannerView;
    //当前商品指针
    int goodIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *recommendIv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//新品首发
- (IBAction)newProductAction:(id)sender;
//特价精选
- (IBAction)saleProductAction:(id)sender;
//热门商品
- (IBAction)hotProductAction:(id)sender;
//特价超市
- (IBAction)allProductAction:(id)sender;

@end
