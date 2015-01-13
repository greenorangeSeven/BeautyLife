//
//  ResponseCode.h
//  BeautyLife
//
//  Created by mac on 14-9-1.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  支付宝返回验证数据模型
//

#import <Foundation/Foundation.h>

@interface ResponseCode : NSObject

@property (nonatomic,copy) NSString *info;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *url;

@end
