//
//  MainPageView.m
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "MainPageView.h"
#import "ConvView.h"
#import "RechargeView.h"
#import "SubtleView.h"
#import "BusinessView.h"

@interface MainPageView ()

@end

@implementation MainPageView

@synthesize scrollView;
@synthesize menuBg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    [Tool roundView:self.menuBg andCornerRadius:3.0];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self initMainADV];
    [self getInBoxRemind];
}

- (void)initMainADV
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
//        [Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&spaceid=2", api_base_url, api_getadv, appkey];
        NSString *cid = [[UserModel Instance] getUserValueForKey:@"cid"];
        if (cid != nil && [cid length] > 0) {
            [tempUrl appendString:[NSString stringWithFormat:@"&cid=%@", cid]];
        }
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           advDatas = [Tool readJsonStrToADV:operation.responseString];
                                           
                                           int length = [advDatas count];
                                           //点赞按钮初始化
                                           Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
                                           [self.pointsBtn setTitle:[NSString stringWithFormat:@"点赞(%@)", adv.points] forState:UIControlStateNormal];
                                           
                                           NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                           if (length > 1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:length-1];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           for (int i = 0; i < length; i++)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:i];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                               
                                           }
                                           //添加第一张图 用于循环
                                           if (length >1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:0];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 200) delegate:self imageItems:itemArray isAuto:NO];
                                           [bannerView scrollToIndex:0];
                                           [self.advIv addSubview:bannerView];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
//                                           if (hud != nil) {
//                                               [hud hide:YES];
//                                           }
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

//顶部图片滑动点击委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title);
    Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    ADVDetailView *advDetail = [[ADVDetailView alloc] init];
    advDetail.hidesBottomBarWhenPushed = YES;
    advDetail.adv = adv;
    [self.navigationController pushViewController:advDetail animated:YES];
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
    advIndex = index;
    Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    [self.pointsBtn setTitle:[NSString stringWithFormat:@"点赞( %@ )", adv.points] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bannerView.delegate = nil;
}

- (void)getInBoxRemind
{
    if ([[UserModel Instance] isLogin]) {
        //如果有网络连接
        if ([UserModel Instance].isNetworkRunning) {
            NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_getinboxremindy, appkey, [[UserModel Instance] getUserValueForKey:@"id"]];
            NSString *cid = [[UserModel Instance] getUserValueForKey:@"cid"];
            if (cid != nil && [cid length] > 0) {
                [tempUrl appendString:[NSString stringWithFormat:@"&cid=%@", cid]];
            }
            NSString *url = [NSString stringWithString:tempUrl];
            [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           @try {
                                               if (operation.responseString) {
                                                   [[UserModel Instance] saveValue:operation.responseString ForKey:@"inboxnum"];
                                                   [self.inboxBtn setTitle:operation.responseString forState:UIControlStateNormal];
                                               }
                                               
                                           }
                                           @catch (NSException *exception) {
                                               [NdUncaughtExceptionHandler TakeException:exception];
                                           }
                                           @finally {

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    bannerView.delegate = self;
}

- (IBAction)clickService:(UIButton *)sender
{
    ConvView *convView = [[ConvView alloc] init];
    convView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:convView animated:YES];
}

- (IBAction)clickRecharge:(UIButton *)sender
{
    RechargeView *rechargeView = [[RechargeView alloc] init];
    rechargeView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:rechargeView animated:YES];
}

- (IBAction)stewardFeeAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    StewardFeeFrameView *feeFrame = [[StewardFeeFrameView alloc] init];
    feeFrame.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feeFrame animated:YES];
}

- (IBAction)clickSubtle:(UIButton *)sender
{
    SubtleView *subtleView = [[SubtleView alloc] init];
    subtleView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:subtleView animated:YES];
}

- (IBAction)repairsAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    RepairsFrameView *repairsFrame = [[RepairsFrameView alloc] init];
    repairsFrame.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:repairsFrame animated:YES];
}

- (IBAction)clickBusiness:(UIButton *)sender
{
    BusinessView *businessView = [[BusinessView alloc] init];
    businessView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:businessView animated:YES];
}

- (IBAction)noticeAction:(id)sender {
    NoticeFrameView *noticeFrame = [[NoticeFrameView alloc] init];
    noticeFrame.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noticeFrame animated:YES];
}

- (IBAction)expressAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    ExpressView *expressView = [[ExpressView alloc] init];
    expressView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:expressView animated:YES];
}

- (IBAction)advDetailAction:(id)sender {
    Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    ADVDetailView *advDetail = [[ADVDetailView alloc] init];
    advDetail.hidesBottomBarWhenPushed = YES;
    advDetail.adv = adv;
    [self.navigationController pushViewController:advDetail animated:YES];
}

- (IBAction)pointsAction:(id)sender {
    Advertisement *adv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    NSString *pointslUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&model=poster&id=%@", api_base_url, api_points, appkey, adv.id];
    NSURL *url = [ NSURL URLWithString : pointslUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSError *error = [request error ];
    assert (!error);
    // 如果请求成功，返回 Response
    NSString *response = [request responseString ];
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSString *status = @"0";
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    if (json) {
        status = [json objectForKey:@"status"];
        if ([status isEqualToString:@"1"]) {
            adv.points = [NSString stringWithFormat:@"%d", [adv.points intValue] + 1];
            [self.pointsBtn setTitle:[NSString stringWithFormat:@"点赞( %@ )", adv.points] forState:UIControlStateNormal];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

- (IBAction)inBoxAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    MyInBoxView *inboxView = [[MyInBoxView alloc] init];
    inboxView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inboxView animated:YES];
}

- (IBAction)shareAction:(id)sender {
    Advertisement *adv = [advDatas objectAtIndex:advIndex];
    NSDictionary *contentDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                adv.title , @"title",
                                adv.content, @"summary",
                                adv.pic, @"thumb",
                                nil];
    [Tool shareAction:sender andShowView:self.view andContent:contentDic];
}
@end
