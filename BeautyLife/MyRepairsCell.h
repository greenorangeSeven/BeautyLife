//
//  MyRepairsCell.h
//  BeautyLife
//
//  Created by Seven on 14-8-4.
//  Copyright (c) 2014年 Seven. All rights reserved.
//我的报修行模型
//

#import <UIKit/UIKit.h>

@interface MyRepairsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *bgLb;
@property (weak, nonatomic) IBOutlet UILabel *gradeLb;
@property (weak, nonatomic) IBOutlet UILabel *repairsNoLb;
@property (weak, nonatomic) IBOutlet UILabel *summaryLb;
@property (weak, nonatomic) IBOutlet UILabel *weixiuInfoLb;
@property (weak, nonatomic) IBOutlet UILabel *statusTextLb;

@end
