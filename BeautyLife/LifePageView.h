//
//  LifePageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-30.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  生活界面
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ADVDetailView.h"

@interface LifePageView : UIViewController<SGFocusImageFrameDelegate>
{
    //广告数组
    NSMutableArray *advDatas;
    //顶部滑动控件
    SGFocusImageFrame *bannerView;
    //当前广告
    int advIndex;
    UIWebView *phoneCallWebView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *advIv;
@property (strong, nonatomic) IBOutlet UIView *menuBg;
@property (strong, nonatomic) IBOutlet UILabel *telBg;

#pragma mark 大众点评
- (IBAction)dzdpAction:(id)sender;
#pragma mark大众团购
- (IBAction)dzTuanAction:(id)sender;

#pragma mark 便民服务
- (IBAction)clickService:(UIButton *)sender;
#pragma mark 在线服务
- (IBAction)clickRecharge:(UIButton *)sender;
#pragma mark 精选特价
- (IBAction)clickSubtle:(UIButton *)sender;
#pragma mark联盟商家
- (IBAction)clickBusiness:(UIButton *)sender;
- (IBAction)telAction:(id)sender;
@end
