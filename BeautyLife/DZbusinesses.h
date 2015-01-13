//
//  DZbusinesses.h
//  BeautyLife
//
//  Created by Seven on 14-11-22.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  大众点评商家数据模型
//

#import <Foundation/Foundation.h>

@interface DZbusinesses : NSObject

@property int avg_price; //人均价格，单位:元
@property int distance;  //商户与参数坐标的距离，单位为米，如不传入经纬度坐标，结果为-1
@property (nonatomic,copy) NSString *business_url;  //商户页面链接
@property (nonatomic,copy) NSString *s_photo_url;  //小尺寸照片链接，照片最大尺寸278×200
@property (nonatomic,copy) NSString *business_id; //商户ID
@property (nonatomic,copy) NSString *name; //商户名
@property (nonatomic,copy) NSString *branch_name; //分店名
@property (nonatomic,copy) NSString *address; //地址
@property (nonatomic,copy) NSString *telephone;  //带区号的电话
@property double avg_rating;  //星级评分
@property (nonatomic,copy) NSString *rating_s_img_url;  //小尺寸星级图片链接

@property (retain,nonatomic) UIImage * photoImgData;
@property (retain,nonatomic) UIImage * ratingImgData;

@end
