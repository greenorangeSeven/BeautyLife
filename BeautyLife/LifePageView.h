//
//  LifePageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-30.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ADVDetailView.h"

@interface LifePageView : UIViewController<SGFocusImageFrameDelegate>
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

- (IBAction)dzdpAction:(id)sender;
- (IBAction)dzTuanAction:(id)sender;

- (IBAction)clickService:(UIButton *)sender;
- (IBAction)clickRecharge:(UIButton *)sender;
- (IBAction)clickSubtle:(UIButton *)sender;
- (IBAction)clickBusiness:(UIButton *)sender;
- (IBAction)telAction:(id)sender;
@end
