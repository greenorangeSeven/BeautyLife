//
//  RegisterView.h
//  BeautyLife
//
//  Created by Seven on 14-7-30.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  注册页面
//

#import <UIKit/UIKit.h>
#import "NSString+STRegex.h"
#import "EGOCache.h"

@interface RegisterView : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainTf;
@property (weak, nonatomic) IBOutlet UITextField *securityCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *securityCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)sendSecurityCodeAction:(id)sender;
- (IBAction)registerAction:(id)sender;

@end
