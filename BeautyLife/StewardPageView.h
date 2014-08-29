//
//  StewardPageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StewardFeeFrameView.h"
#import "RepairsFrameView.h"
#import "NoticeFrameView.h"
#import "ExpressView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface StewardPageView : UIViewController<SGFocusImageFrameDelegate, UIActionSheetDelegate>
{
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
    
//    MBProgressHUD *hud;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *advIv;
@property (strong, nonatomic) IBOutlet UIView *menuBg;
@property (strong, nonatomic) IBOutlet UILabel *telBg;

- (IBAction)stewardFeeAction:(id)sender;
- (IBAction)repairsAction:(id)sender;
- (IBAction)noticeAction:(id)sender;
- (IBAction)expressAction:(id)sender;

@end
