//
//  OnlineLink.h
//  BeautyLife
//
//  Created by Seven on 14-10-27.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  在线服务数据模型
//

#import <Foundation/Foundation.h>

@interface OnlineLink : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *logo;
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *sort;

@property (retain,nonatomic) UIImage * imgData;

@end
