//
//  RepairsFrameView.h
//  BeautyLife
//
//  Created by Seven on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  物业报修框架页
//

#import <UIKit/UIKit.h>
#import "RepairsFormView.h"
#import "MyRepairsView.h"

@interface RepairsFrameView : UIViewController

//物业报修表单提交页
@property (strong, nonatomic) RepairsFormView *repairsView;
//我的历史报修页面
@property (strong, nonatomic) MyRepairsView *myRepairsView;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *repairsBtn;
@property (strong, nonatomic) IBOutlet UIButton *myRepairsBtn;

//显示报修表单页
- (IBAction)repairsAction:(id)sender;
//显示我的历史报修
- (IBAction)myRepairsAction:(id)sender;

@end
