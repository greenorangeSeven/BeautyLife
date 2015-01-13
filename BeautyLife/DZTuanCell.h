//
//  DZTuanCell.h
//  BeautyLife
//
//  Created by Seven on 14-12-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  团购行模型
//

#import <UIKit/UIKit.h>

@interface DZTuanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picIv;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UILabel *tuanPriLb;
@property (weak, nonatomic) IBOutlet UILabel *yuanPriLb;
@property (weak, nonatomic) IBOutlet UILabel *buyCountLb;

@end
