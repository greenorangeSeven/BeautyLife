//
//  ExpressView.h
//  BeautyLife
//
//  Created by Seven on 14-8-6.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySendExpressView.h"
#import "EGOImageView.h"
#import "MyInBoxView.h"

@interface ExpressView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate>
{
    //类型数组
    NSArray *typeData;
    //所选类型
    NSString *typeStr;
    UIWebView *phoneCallWebView;
}

@property (weak, nonatomic) IBOutlet UILabel *inboxNumLb;
@property (weak, nonatomic) IBOutlet UILabel *inboxBtnLb;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLb;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UITextField *descTv;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

#pragma -mark 我的发件箱
- (IBAction)mySendExpressAction:(id)sender;
#pragma -mark 发件
- (IBAction)sendAction:(id)sender;
#pragma -mark 选择类型
- (IBAction)selectTypeAction:(id)sender;
- (IBAction)telAction:(id)sender;

@end
