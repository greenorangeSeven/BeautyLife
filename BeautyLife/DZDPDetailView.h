//
//  DZDPDetailView.h
//  BeautyLife
//
//  Created by Seven on 14-11-24.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZDPDetailView : UIViewController<UIWebViewDelegate>
{
    MBProgressHUD *hud;
}

- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) NSString *urlStr;

@end
