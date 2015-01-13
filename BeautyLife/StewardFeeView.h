//
//  StewardFeeView.h
//  BeautyLife
//
//  Created by Seven on 14-8-1.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  物业缴费逻辑页面
//

#import <UIKit/UIKit.h>
#import "PropertyFeeInfo.h"
#import "EGOImageView.h"
#import "UserInfoView.h"

@interface StewardFeeView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate, UIAlertViewDelegate>
{
    //个人信息缓存模型
    UserModel *usermodel;
    //月缴费变量
    double monthFee;
    //应缴物业费
    double arrearage;
    //欠费月数
    int arrearageMonth;
    //预缴物业费
    double presetValue;
    //预缴月数
    int presetMonth;
    //选择预缴费用数组
    NSArray *presetData;
}

@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
#pragma mark 上级父页面View
@property (strong, nonatomic) UIView *parentView;

@property (weak, nonatomic) IBOutlet UILabel *telLb;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *payfeeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLb;
@property (weak, nonatomic) IBOutlet UILabel *shouldPayLb;
@property (weak, nonatomic) IBOutlet UIButton *presetBtn;
@property (weak, nonatomic) IBOutlet UILabel *sumMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *feeinfoLb;

#pragma mark 点击出现预缴费用选择
- (IBAction)showPresetAction:(id)sender;
#pragma mark 缴费事件
- (IBAction)payFeeAction:(UIButton *)sender;
#pragma -mark 显示我的缴费历史
- (IBAction)showHistoryAction:(UIButton *)sender;
@end
