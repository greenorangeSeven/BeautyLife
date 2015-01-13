//
//  MainPageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  首页页面
//

#import <UIKit/UIKit.h>
#import "StewardFeeFrameView.h"
#import "RepairsFrameView.h"
#import "NoticeFrameView.h"
#import "ExpressView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ADVDetailView.h"
#import "MyInBoxView.h"

@interface MainPageView : UIViewController<SGFocusImageFrameDelegate, UIActionSheetDelegate>
{
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
    
    MBProgressHUD *hud;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *advIv;
@property (strong, nonatomic) IBOutlet UILabel *menuBg;
@property (weak, nonatomic) IBOutlet UIButton *inboxBtn;
@property (weak, nonatomic) IBOutlet UIButton *pointsBtn;

#pragma mark -按钮点击事件
- (IBAction)inBoxAction:(id)sender;
#pragma mark 分享点击事件
- (IBAction)shareAction:(id)sender;

#pragma mark 便民服务
- (IBAction)clickService:(UIButton *)sender;

#pragma mark 在线充值
- (IBAction)clickRecharge:(UIButton *)sender;

#pragma mark 物业缴费
- (IBAction)stewardFeeAction:(id)sender;
#pragma mark 物业报修
- (IBAction)repairsAction:(id)sender;
#pragma mark 小区通知
- (IBAction)noticeAction:(id)sender;
#pragma mark 快递收发
- (IBAction)expressAction:(id)sender;
#pragma mark 精选特价
- (IBAction)clickSubtle:(UIButton *)sender;

#pragma mark 联盟商家
- (IBAction)clickBusiness:(UIButton *)sender;

#pragma mark 广告详情
- (IBAction)advDetailAction:(id)sender;
#pragma mark 点赞
- (IBAction)pointsAction:(id)sender;
#pragma mark 大众点评
- (IBAction)dzdpAction:(id)sender;
#pragma mark 大众团购
- (IBAction)dzTuanAction:(id)sender;

@end
