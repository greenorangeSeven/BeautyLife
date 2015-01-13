//
//  ChangPWDView.h
//  BeautyLife
//
//  Created by Seven on 14-9-16.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  修改密码界面
//

#import <UIKit/UIKit.h>

@interface ChangPWDView : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPwdTf;
@property (weak, nonatomic) IBOutlet UITextField *PwdTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainTf;

@property (weak, nonatomic) IBOutlet UIButton *changePwdBtn;
//修改密码
- (IBAction)changePwdAction:(id)sender;

@end
