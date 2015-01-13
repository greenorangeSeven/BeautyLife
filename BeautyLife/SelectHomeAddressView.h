//
//  SelectHomeAddressView.h
//  BeautyLife
//
//  Created by Seven on 14-8-12.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOCache.h"
#import "AreaListModel.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "RegionModel.h"
#import "XGPush.h"
#import "XGSetting.h"

@interface SelectHomeAddressView : UIViewController< UIActionSheetDelegate, UIPickerViewDelegate>
{
    //省市区小区、楼栋、单元、房间模型对象
    NSArray *areaData;
    NSArray *communityData;
    NSArray *buildData;
    NSArray *houseData;
    
    NSArray *provinceArray;
    NSArray *cityArray;
    NSArray *regionArray;
    
    NSString *selectProvinceId;
    NSString *selectCityId;
    NSString *selectRegionId;
    
    NSString *selectProvinceStr;
    NSString *selectCityStr;
    NSString *selectRegionStr;
    
    NSString *selectCommunityId;
    NSString *selectCommunityStr;
    
    NSString *selectBuildId;
    NSString *selectBuildStr;
    
    NSString *selectHouseId;
    NSString *selectHouseStr;
    
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UIButton *selectAreaBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectCommunityBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBuildBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectHouseBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

//选择小区
- (IBAction)selectCommunityAction:(id)sender;
//选择单元
- (IBAction)selectBuildAction:(id)sender;
//选择房间
- (IBAction)selectHouseAction:(id)sender;
//选择市区
- (IBAction)selectRegionAction:(id)sender;

//完成
- (IBAction)finishAction:(id)sender;

@end
