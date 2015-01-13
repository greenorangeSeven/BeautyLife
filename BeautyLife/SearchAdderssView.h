//
//  SearchAdderssView.h
//  BeautyLife
//
//  Created by Seven on 14-9-3.
//  Copyright (c) 2014年 Seven. All rights reserved.
//搜索小区界面
//

#import <UIKit/UIKit.h>

@interface SearchAdderssView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate, UISearchBarDelegate>
{
    NSString *searchWord;
    
    NSArray *communityData;
    NSArray *buildData;
    NSArray *houseData;
    
    NSString *selectCommunityId;
    NSString *selectCommunityStr;
    
    NSString *selectBuildId;
    NSString *selectBuildStr;
    
    NSString *selectHouseId;
    NSString *selectHouseStr;
    
    MBProgressHUD *hud;
}


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *selectCommunityBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBuildBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectHouseBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

//选择小区
- (IBAction)selectCommunityAction:(id)sender;
//选择区域
- (IBAction)selectBuildAction:(id)sender;
//选择房间
- (IBAction)selectHouseAction:(id)sender;
//完成
- (IBAction)finishAction:(id)sender;

@end
