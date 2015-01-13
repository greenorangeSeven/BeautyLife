//
//  DZTuan.h
//  BeautyLife
//
//  Created by Seven on 14-12-7.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  大众点评团购数据模型
//

#import <Foundation/Foundation.h>

@interface DZTuan : NSObject

@property (nonatomic,copy) NSString *deal_h5_url;  //团购页面链接
@property (nonatomic,copy) NSString *s_image_url;  //小尺寸照片链接，照片最大尺寸160×100
@property (nonatomic,copy) NSString *deal_id; //ID
@property (nonatomic,copy) NSString *title; //名称
@property (nonatomic,copy) NSString *desc; //描述
//@property (nonatomic,copy) NSString *description; //描述
@property double list_price; //原价
@property double current_price;  //团购价

@property (retain,nonatomic) UIImage * photoImgData;

@end
