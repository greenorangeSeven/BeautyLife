//
//  News.h
//  BeautyLife
//
//  Created by Seven on 14-8-14.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  通知数据模型
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *cid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *published;
@property (nonatomic, retain) NSString *points;

@end
