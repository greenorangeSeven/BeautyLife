//
//  AddInboxView.h
//  BeautyLife
//
//  Created by Seven on 14-8-20.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  添加我的收件
//

#import <UIKit/UIKit.h>

@interface AddInboxView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate>
{
    //快递代码数组
    NSArray *expComData;
    //快递名称
    NSString *expComName;
    //快递编码
    NSString *expComCode;
    //包裹类型数组
    NSArray *typeData;
    //所选包裹类型
    NSString *typeStr;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *expComBtn;
@property (weak, nonatomic) IBOutlet UITextField *expNumLb;
@property (weak, nonatomic) IBOutlet UIButton *expTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *telBg;

//选择快递类型
- (IBAction)expComAction:(id)sender;
//选择包裹类型
- (IBAction)expTypeAction:(id)sender;
//添加我的收件
- (IBAction)addAction:(id)sender;

@end
