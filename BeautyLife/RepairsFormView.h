//
//  RepairsFormView.h
//  BeautyLife
//
//  Created by Seven on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//  物业报修表单提交页
//

#import <UIKit/UIKit.h>
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "EGOImageView.h"
#import "UserInfoView.h"

@interface RepairsFormView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate, UIAlertViewDelegate>
{
    //报修类型数组
    NSArray *cateData;
    //事件控件刷新TIME
    NSTimer *_timer;
    UserModel *usermodel;
    //所选的报修类型
    NSString *cateValue;
    //上传图像
    UIImage *picimage;
    UIWebView *phoneCallWebView;
}

@property (strong, nonatomic) UIView *parentView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITextView *descTv;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIButton *selectCateBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectPhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
#pragma -mark 拨打电话
- (IBAction)telAction:(id)sender;
#pragma -mark 选择类型
- (IBAction)selectTypeAction:(id)sender;
#pragma -mark 拨打电话
- (IBAction)selectPhoneAction:(id)sender;
#pragma -mark 提交报修
- (IBAction)submitAction:(id)sender;

@end
