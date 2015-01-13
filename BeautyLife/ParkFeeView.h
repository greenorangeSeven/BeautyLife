//
//  ParkFeeView.h
//  BeautyLife
//
//  Created by Seven on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  停车缴费页面
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface ParkFeeView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate>
{
    UserModel *usermodel;
    //月单价
    double monthFee;
    //应缴物业费
    double shouldMoney;
    //应缴月数
    int shouldMonth;
    //预缴物业费
    double presetMoney;
    //预缴月数
    int presetMonth;
    //预缴数组
    NSArray *presetData;
    //是否自有车位
    bool havePackFee;
}

#pragma -mark 上级父页面View
@property (strong, nonatomic) UIView *parentView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *telLb;
@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *parkInfoLb;
@property (weak, nonatomic) IBOutlet UILabel *shouldFeeLb;
@property (weak, nonatomic) IBOutlet UIButton *presetBtn;
@property (weak, nonatomic) IBOutlet UILabel *sumMoneyLb;
@property (weak, nonatomic) IBOutlet UIButton *payfeeBtn;
@property (weak, nonatomic) IBOutlet UILabel *feeinfoLb;

#pragma -mark 显示预缴费用选择
- (IBAction)showPresetAction:(id)sender;
#pragma -mark  缴费
- (IBAction)payFeeAction:(UIButton *)sender;
#pragma -mark 显示我的缴费历史
- (IBAction)showHistoryAction:(UIButton *)sender;
@end
