//
//  ReSetPwdView.h
//  BeautyLife
//
//  Created by Seven on 14-9-16.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  重置密码界面
//

#import <UIKit/UIKit.h>

@interface ReSetPwdView : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mobileTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainTf;
@property (weak, nonatomic) IBOutlet UITextField *securityCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *securityCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

//获取短信验证码
- (IBAction)sendSecurityCodeAction:(id)sender;
//重置密码
- (IBAction)resetAction:(id)sender;

@end
