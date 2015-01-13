//
//  StewardFeeFrameView.h
//  BeautyLife
//
//  Created by Seven on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  物业缴费框架（包括物业缴费，停车缴费）
//

#import <UIKit/UIKit.h>
#import "StewardFeeView.h"
#import "ParkFeeView.h"

@interface StewardFeeFrameView : UIViewController

#pragma mark 物业缴费View变量
@property (strong, nonatomic) StewardFeeView * stewardView;
#pragma mark 停车缴费View变量
@property (strong, nonatomic) ParkFeeView * parkView;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *stewardFeeBtn;
@property (strong, nonatomic) IBOutlet UIButton *parkFeeBtn;

#pragma mark 点击切换至物业缴费
- (IBAction)stewardFeeAction:(id)sender;
#pragma mark 点击切换至停车缴费
- (IBAction)parkFeeAction:(id)sender;

@end
