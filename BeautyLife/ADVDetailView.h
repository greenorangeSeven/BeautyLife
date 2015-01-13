//
//  ADVDetailView.h
//  BeautyLife
//
//  Created by Seven on 14-8-14.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  广告详情页
//

#import <UIKit/UIKit.h>
#import "Advertisement.h"

@interface ADVDetailView : UIViewController<UIActionSheetDelegate>
{
    MBProgressHUD *hud;
}

#pragma mark 传递广告对象
@property (weak, nonatomic) Advertisement *adv;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
