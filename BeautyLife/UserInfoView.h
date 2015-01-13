//
//  UserInfoView.h
//  BeautyLife
//
//  Created by Seven on 14-7-31.
//  Copyright (c) 2014年 Seven. All rights reserved.
//个人信息页面
//

#import <UIKit/UIKit.h>
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "EGOImageView.h"
#import "NSString+STRegex.h"
#import "ChooseAreaView.h"

@interface UserInfoView : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate, UIPickerViewDelegate>
{
    EGOImageView *faceEGOImageView;
}

@property (weak, nonatomic) IBOutlet UIImageView *userFaceIv;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UILabel *homeAddressLb;
@property (weak, nonatomic) IBOutlet UITextField *emailTf;
@property (weak, nonatomic) IBOutlet UITextField *idCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *saveInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectHomeAddressBtn;

//选择房间按钮事件
- (IBAction)selectHomeAddressAction:(id)sender;
//保存用户信息
- (IBAction)saveInfoAction:(id)sender;
//更换头像
- (IBAction)uploadFaceAction:(id)sender;

@end
