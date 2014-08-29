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

@interface LifePageView : UIViewController<SGFocusImageFrameDelegate>
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

- (IBAction)clickService:(UIButton *)sender;
- (IBAction)clickRecharge:(UIButton *)sender;
- (IBAction)clickSubtle:(UIButton *)sender;
- (IBAction)clickBusiness:(UIButton *)sender;

@end
