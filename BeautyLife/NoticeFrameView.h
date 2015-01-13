//
//  NoticeFrameView.h
//  BeautyLife
//
//  Created by Seven on 14-8-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
// 物业通知框架页
//

#import <UIKit/UIKit.h>
#import "NewsTableView.h"

@interface NoticeFrameView : UIViewController

//通知类型传递对象
@property (strong, nonatomic) NSString *presentType;

//物业通知
@property (strong, nonatomic) NewsTableView *noticeView;
//社区活动
@property (strong, nonatomic) NewsTableView *activityView;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *noticeBtn;
@property (strong, nonatomic) IBOutlet UIButton *activityBtn;

//物业通知点击
- (IBAction)noticeAction:(id)sender;
#pragma -mark 小区活动点击
- (IBAction)activityAction:(id)sender;

@end
