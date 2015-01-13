//
//  ChooseAreaView.h
//  BeautyLife
//
//  Created by Seven on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//房屋选择方式界面
//

#import <UIKit/UIKit.h>
#import "SelectHomeAddressView.h"
#import "SearchAdderssView.h"

@interface ChooseAreaView : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *communityLb;
@property (weak, nonatomic) IBOutlet UILabel *regionLb;

//根据省市区选择
- (IBAction)selectHomeAddressForCityAction:(id)sender;
//搜索小区选择
- (IBAction)searchAddressAction:(id)sender;

@end
