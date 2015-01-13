//
//  OrderInfo.h
//  BeautyLife
//
//  Created by Seven on 14-8-27.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  订单数据模型
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject

@property (nonatomic, retain) NSNumber *userid;
@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *receiver;

@property (nonatomic, retain) NSMutableArray *businessOrderList;

@end
