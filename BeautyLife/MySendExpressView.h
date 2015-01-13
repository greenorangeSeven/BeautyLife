//
//  MySendExpressView.h
//  BeautyLife
//
//  Created by Seven on 14-8-6.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  我的发件箱
//

#import <UIKit/UIKit.h>
#import "MySendExpressCell.h"
#import "MyInBoxView.h"
#import "KuaiDi100View.h"

@interface MySendExpressView : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    //我的发件数组
    NSArray *myOutExpressData;
    //提示kuang
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UILabel *inboxNumLb;
@property (weak, nonatomic) IBOutlet UILabel *inboxBtnLb;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *myExpressTable;

@end
