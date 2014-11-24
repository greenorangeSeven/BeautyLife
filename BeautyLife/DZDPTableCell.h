//
//  DZDPTableCell.h
//  BeautyLife
//
//  Created by Seven on 14-11-22.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZDPTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sphotoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *distanceLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIImageView *ratingimgIV;
@property (weak, nonatomic) IBOutlet UILabel *telLb;

@end
