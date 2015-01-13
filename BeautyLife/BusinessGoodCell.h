//
//  BusinessGoodCell.h
//  BeautyLife
//
//  Created by Seven on 14-8-25.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  商家商品单元格模型
//

#import <UIKit/UIKit.h>

@interface BusinessGoodCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picIv;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLb;

@end
