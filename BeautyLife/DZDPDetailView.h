//
//  DZDPDetailView.h
//  BeautyLife
//
//  Created by Seven on 14-11-24.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  大众点评详情页面
//

#import <UIKit/UIKit.h>

@interface DZDPDetailView : UIViewController<UIWebViewDelegate>
{
    MBProgressHUD *hud;
}

//返回点击事件
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//页面传递详情URL
@property (weak, nonatomic) NSString *urlStr;

@end
