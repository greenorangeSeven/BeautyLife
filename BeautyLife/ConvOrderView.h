//
//  ConvOrder.h
//  BeautyLife
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  便民服务详情界面
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "StoreMapPointView.h"

@interface ConvOrderView : UIViewController<UIWebViewDelegate>
{
    //便民服务详情对象
    Shop *shopDetail;
    MBProgressHUD *hud;
    UIWebView *phoneCallWebView;
}

//传递商家对象
@property (weak, nonatomic) Shop *shop;
//我的定位模型
@property  CLLocationCoordinate2D mycoor;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *telLb;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)telAction:(id)sender;
//联系商家
- (IBAction)telShopAction:(id)sender;
//进入地图页面
- (IBAction)mapPointAction:(id)sender;

@end
