//
//  MyInBoxView.h
//  BeautyLife
//
//  Created by Seven on 14-8-20.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  我的收件箱
//

#import <UIKit/UIKit.h>
#import "AddInboxView.h"
#import "MySendExpressCell.h"
#import "KuaiDi100View.h"

@interface MyInBoxView : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UserModel *usermodel;
    //我的收件数组
    NSArray *myInExpressData;
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *inboxNumLb;
@property (weak, nonatomic) IBOutlet UITableView *myInboxTable;
#pragma -mark 添加我的收件
- (IBAction)addMyInBoxAciton:(id)sender;

@end
