//
//  SearchAdderssView.m
//  BeautyLife
//
//  Created by Seven on 14-9-3.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "SearchAdderssView.h"
#import "MobClick.h"

@interface SearchAdderssView ()

@end

@implementation SearchAdderssView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"住址选择";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.searchBar.delegate = self;
    if (!IS_IOS7) {
        [self.searchBar setTintColor:[Tool getBackgroundColor]];
    }
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SearchAddressView"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SearchAddressView"];
}

- (void)getCommunity
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"小区搜索" andView:self.view andHUD:hud];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&words=%@", api_base_url, api_community, appkey, searchWord];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           communityData = [Tool readJsonStrToCommunityArray:operation.responseString];
                                           if ([communityData count] > 0) {
                                               [self.selectCommunityBtn setEnabled:YES];
                                               [self.selectBuildBtn setEnabled:YES];
                                               CommunityModel *community = (CommunityModel *)[communityData objectAtIndex:0];
                                               buildData = community.buildArray;
                                               selectCommunityId = community.id;
                                               selectCommunityStr = community.title;
                                               [self.selectCommunityBtn setTitle:selectCommunityStr forState:UIControlStateNormal];
                                           }
                                           else
                                           {
                                               UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                            message:@"没有搜索到与关键字相符的小区"
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:@"确定"
                                                                                  otherButtonTitles:nil];
                                               [av show];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

- (IBAction)selectCommunityAction:(id)sender {
    if (communityData != nil && [communityData count] > 0) {
        CommunityModel *community = (CommunityModel *)[communityData objectAtIndex:0];
        buildData = community.buildArray;
        selectCommunityId = community.id;
        selectCommunityStr = community.title;
    }
    else
    {
        [self.selectCommunityBtn setTitle:@"暂无小区" forState:UIControlStateNormal];
        return;
    }
    if (IS_IOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIPickerView *communityPicker = [[UIPickerView alloc] init];
        communityPicker.delegate = self;
        communityPicker.showsSelectionIndicator = YES;
        communityPicker.tag = 1;
        [alert.view addSubview:communityPicker];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    self.selectBuildBtn.enabled = YES;
                                                    [self.selectCommunityBtn setTitle:selectCommunityStr forState:UIControlStateNormal];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确  定", nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
        UIPickerView *communityPicker = [[UIPickerView alloc] init];
        communityPicker.delegate = self;
        communityPicker.showsSelectionIndicator = YES;
        communityPicker.tag = 1;
        [actionSheet addSubview:communityPicker];
    }
}

- (IBAction)selectBuildAction:(id)sender {
    if (buildData != nil && [buildData count] > 0) {
        BuildModel *build = (BuildModel *)[buildData objectAtIndex:0];
        houseData = build.houseArray;
        selectBuildId = build.id;
        selectBuildStr = build.name;
    }
    if (IS_IOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIPickerView *buildPicker = [[UIPickerView alloc] init];
        buildPicker.delegate = self;
        buildPicker.showsSelectionIndicator = YES;
        buildPicker.tag = 2;
        [alert.view addSubview:buildPicker];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    self.selectHouseBtn.enabled = YES;
                                                    [self.selectBuildBtn setTitle:selectBuildStr forState:UIControlStateNormal];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确  定", nil];
        actionSheet.tag = 2;
        [actionSheet showInView:self.view];
        UIPickerView *buildPicker = [[UIPickerView alloc] init];
        buildPicker.delegate = self;
        buildPicker.showsSelectionIndicator = YES;
        buildPicker.tag = 2;
        [actionSheet addSubview:buildPicker];
    }
}

- (IBAction)selectHouseAction:(id)sender {
    if (houseData != nil && [houseData count] > 0) {
        HouseModel *house = (HouseModel *)[houseData objectAtIndex:0];
        selectHouseId = house.id;
        selectHouseStr = house.house_number;
    }
    if (IS_IOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"\n\n\n\n\n\n\n\n\n\n"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIPickerView *housePicker = [[UIPickerView alloc] init];
        housePicker.delegate = self;
        housePicker.showsSelectionIndicator = YES;
        housePicker.tag = 3;
        [alert.view addSubview:housePicker];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    [self.selectHouseBtn setTitle:selectHouseStr forState:UIControlStateNormal];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确  定", nil];
        actionSheet.tag = 3;
        [actionSheet showInView:self.view];
        UIPickerView *housePicker = [[UIPickerView alloc] init];
        housePicker.delegate = self;
        housePicker.showsSelectionIndicator = YES;
        housePicker.tag = 3;
        [actionSheet addSubview:housePicker];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            self.selectBuildBtn.enabled = YES;
            [self.selectCommunityBtn setTitle:selectCommunityStr forState:UIControlStateNormal];
        }
    }
    else if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            self.selectHouseBtn.enabled = YES;
            [self.selectBuildBtn setTitle:selectBuildStr forState:UIControlStateNormal];
        }
    }
    else if (actionSheet.tag == 3) {
        if (buttonIndex == 0) {
            [self.selectHouseBtn setTitle:selectHouseStr forState:UIControlStateNormal];
        }
    }
}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 0) {
        return 3;
    }
    else if (pickerView.tag == 1 || pickerView.tag == 2 || pickerView.tag == 3)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
    {
        return [communityData count];
    }
    else if (pickerView.tag == 2)
    {
        return [buildData count];
    }
    else if (pickerView.tag == 3)
    {
        return [houseData count];
    }
    else
    {
        return 0;
    }
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
    {
        CommunityModel *community = (CommunityModel *)[communityData objectAtIndex:row];
        return community.title;
    }
    else if (pickerView.tag == 2)
    {
        BuildModel *build = (BuildModel *)[buildData objectAtIndex:row];
        return build.name;
    }
    else if (pickerView.tag == 3)
    {
        HouseModel *house = (HouseModel *)[houseData objectAtIndex:row];
        return house.house_number;
    }
    else
    {
        return nil;
    }
}

-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    if (pickerView.tag == 1)
    {
        CommunityModel *community = (CommunityModel *)[communityData objectAtIndex:row];
        buildData = community.buildArray;
        selectCommunityId = community.id;
        selectCommunityStr = community.title;
    }
    else if (pickerView.tag == 2)
    {
        BuildModel *build = (BuildModel *)[buildData objectAtIndex:row];
        houseData = build.houseArray;
        selectBuildId = build.id;
        selectBuildStr = build.name;
    }
    else if (pickerView.tag == 3)
    {
        HouseModel *house = (HouseModel *)[houseData objectAtIndex:row];
        selectHouseId = house.id;
        selectHouseStr = house.house_number;
    }
}

- (IBAction)finishAction:(id)sender {
    if (selectHouseStr == nil || [selectHouseStr length] == 0) {
        [Tool showCustomHUD:@"请完整选择您的住址" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    
    self.finishBtn.enabled = NO;
    UserModel *usermodel = [UserModel Instance];
    NSString *regUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_editinfo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:[usermodel getUserValueForKey:@"id"] forKey:@"id"];
    [request setPostValue:[usermodel getUserValueForKey:@"tel"] forKey:@"tel"];
    if (![selectCommunityId isEqualToString:@""] && ![selectBuildId isEqualToString:@""] && ![selectHouseStr isEqualToString:@""]) {
        [request setPostValue:selectCommunityId forKey:@"cid"];
        [request setPostValue:selectBuildId forKey:@"build_id"];
        [request setPostValue:selectHouseStr forKey:@"house_number"];
    }
    else
    {
        [request setPostValue:[usermodel getUserValueForKey:@"cid"] forKey:@"cid"];
        [request setPostValue:[usermodel getUserValueForKey:@"build_id"] forKey:@"build_id"];
        [request setPostValue:[usermodel getUserValueForKey:@"house_number"] forKey:@"house_number"];
    }
    [request setPostValue:[usermodel getUserValueForKey:@"email"] forKey:@"email"];
    [request setPostValue:[usermodel getUserValueForKey:@"card_id"] forKey:@"card_id"];
    [request setPostValue:[usermodel getUserValueForKey:@"name"] forKey:@"name"];
    [request setPostValue:[usermodel getUserValueForKey:@"nickname"] forKey:@"nickname"];
    [request setPostValue:[NSString stringWithFormat:@"%@%@%@", selectCommunityStr, selectBuildStr, selectHouseStr] forKey:@"address"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSaveInfo:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在保存" andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
}

- (void)requestSaveInfo:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!json) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                     message:request.responseString
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    User *user = [Tool readJsonStrToUser:request.responseString];
    int errorCode = [user.status intValue];
    NSString *errorMessage = user.info;
    switch (errorCode) {
        case 1:
        {
            UserModel *userModel = [UserModel Instance];
            if (![selectCommunityId isEqualToString:@""] && ![selectBuildId isEqualToString:@""] && ![selectHouseStr isEqualToString:@""]) {
                [userModel saveValue:selectCommunityId ForKey:@"cid"];
                [userModel saveValue:selectBuildId ForKey:@"build_id"];
                [userModel saveValue:selectHouseStr ForKey:@"house_number"];
                [userModel saveValue:selectCommunityStr ForKey:@"comm_name"];
                [userModel saveValue:selectBuildStr ForKey:@"build_name"];
                [userModel saveValue:[NSString stringWithFormat:@"%@%@%@", selectCommunityStr, selectBuildStr, selectHouseStr] ForKey:@"address"];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
            self.finishBtn.enabled = YES;
        }
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchWord = searchBar.text;
    if ([searchWord length] > 0) {
        [self.searchBar resignFirstResponder];// 放弃第一响应者
        [self.searchBar setShowsCancelButton:NO animated:YES];
        [self getCommunity];
    }
    else
    {
        [Tool showCustomHUD:@"请输入要搜索的关键字" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
    }
}

//编辑代理(完成编辑触发)
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];// 放弃第一响应者
    searchWord = @"";
}

@end
