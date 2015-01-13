//
//  MyCouponCell.h
//  LuoYang
//
//  Created by Seven on 14-10-15.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//我的优惠券行模型
//

#import <UIKit/UIKit.h>

@interface MyCouponCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbIv;
@property (weak, nonatomic) IBOutlet UILabel *storenameLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *validityLb;

@end
