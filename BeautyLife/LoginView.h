//
//  LoginView.h
//  BeautyLife
//
//  Created by Seven on 14-8-12.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  登陆界面
//

#import <UIKit/UIKit.h>
#import "NSString+STRegex.h"
#import "ReSetPwdView.h"
#import "XGPush.h"
#import "XGSetting.h"

@interface LoginView : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//登陆事件
- (IBAction)loginAction:(id)sender;
//忘记密码界面
- (IBAction)resetPwdActon:(id)sender;

@end
