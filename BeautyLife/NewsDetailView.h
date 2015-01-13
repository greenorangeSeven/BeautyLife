//
//  NewsDetailView.h
//  BeautyLife
//
//  Created by Seven on 14-8-15.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  新闻详情页面
//

#import <UIKit/UIKit.h>

@interface NewsDetailView : UIViewController<UIActionSheetDelegate>
{
    UIWebView *phoneCallWebView;
}

//传递新闻对象
@property (weak, nonatomic) News *news;
@property int catalog;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *pointsBtn;
@property (weak, nonatomic) IBOutlet UIButton *baomingBtn;

#pragma -mark 点赞
- (IBAction)pointsAction:(id)sender;
#pragma -mark 报名
- (IBAction)baoming:(id)sender;
#pragma -mark 拨打电话
- (IBAction)telAction:(id)sender;

@end
