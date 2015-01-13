//
//  OrderBusiness.h
//  BeautyLife
//
//  Created by Seven on 14-8-28.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  商家订单数据模型
//

#import <Foundation/Foundation.h>

@interface OrderBusiness : NSObject

@property (nonatomic, retain) NSNumber *store_id;
@property (nonatomic, retain) NSNumber *amount;
@property (nonatomic, retain) NSMutableArray *goodlist;

@end
