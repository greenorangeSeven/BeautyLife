//
//  StewardPageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  物业界面
//

#import <UIKit/UIKit.h>
#import "StewardFeeFrameView.h"
#import "RepairsFrameView.h"
#import "NoticeFrameView.h"
#import "ExpressView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ADVDetailView.h"

@interface StewardPageView : UIViewController<SGFocusImageFrameDelegate, UIActionSheetDelegate>
{
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
    UIWebView *phoneCallWebView;
//    MBProgressHUD *hud;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *advIv;
@property (strong, nonatomic) IBOutlet UIView *menuBg;
@property (strong, nonatomic) IBOutlet UILabel *telBg;

#pragma mark 物业缴费
- (IBAction)stewardFeeAction:(id)sender;
#pragma mark 物业报修
- (IBAction)repairsAction:(id)sender;
#pragma mark 物业通知
- (IBAction)noticeAction:(id)sender;
#pragma mark 快递收发
- (IBAction)expressAction:(id)sender;
#pragma mark 拨打物业电话
- (IBAction)telAction:(id)sender;

@end
