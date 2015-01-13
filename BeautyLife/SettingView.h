//
//  SettingView.h
//  oschina
//
//  Created by wangjun on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  设置界面
//

#import <UIKit/UIKit.h>
#import "SettingModel.h"
#import "UserModel.h"
#import "RegisterView.h"
#import "UserInfoView.h"
#import "ChooseAreaView.h"
#import "LoginView.h"
#import "ShoppingCartView.h"
#import "MySendExpressView.h"
#import "ChangPWDView.h"

@interface SettingView : UIViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
{
    UIWebView *phoneCallWebView;
    NSArray * settings;
    NSMutableDictionary * settingsInSection;
}

@property (strong, nonatomic) IBOutlet UITableView *tableSettings;
//设置数组
@property (retain,nonatomic) NSArray * settings;
@property (retain,nonatomic) NSMutableDictionary * settingsInSection;

@end
