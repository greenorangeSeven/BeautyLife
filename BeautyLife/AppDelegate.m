//
//  AppDelegate.m
//  BeautyLife
//
//  Created by Seven on 14-7-28.
//  Copyright (c) 2014年 Seven. All rights reserved.
//
#import "AppDelegate.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "MobClick.h"
#import "XGPush.h"
#import "XGSetting.h"

#define _IPHONE80_ 80000

BMKMapManager* _mapManager;

@implementation AppDelegate
@synthesize mainPage;
@synthesize stewardPage;
@synthesize lifePage;
@synthesize shopCarPage;
@synthesize settingPage;
@synthesize tabBarController;

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //检查网络是否存在 如果不存在 则弹出提示
    [UserModel Instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
    //显示系统托盘
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //初始化ShareSDK
    [ShareSDK registerApp:@"2cc31fa9badc"];
    [self initializePlat];
    
    //初始化友盟统计
    [self initUmeng];
    
    //获取并保存用户信息
    [self saveUserInfo];
    [self saveAlipayKeyInfo];
    //首页
    self.mainPage = [[MainPageView alloc] initWithNibName:@"MainPageView" bundle:nil];
    mainPage.tabBarItem.image = [UIImage imageNamed:@"tab_main"];
    mainPage.tabBarItem.title = @"首页";
    UINavigationController *mainPageNav = [[UINavigationController alloc] initWithRootViewController:self.mainPage];
    //精管家
    self.stewardPage = [[StewardPageView alloc] initWithNibName:@"StewardPageView" bundle:nil];
    stewardPage.tabBarItem.image = [UIImage imageNamed:@"tab_steward"];
    stewardPage.tabBarItem.title = @"金管家";
    UINavigationController *stewardPageNav = [[UINavigationController alloc] initWithRootViewController:self.stewardPage];
    //精管家
    self.lifePage = [[LifePageView alloc] initWithNibName:@"LifePageView" bundle:nil];
    lifePage.tabBarItem.image = [UIImage imageNamed:@"tab_life"];
    lifePage.tabBarItem.title = @"美生活";
    UINavigationController *lifePageNav = [[UINavigationController alloc] initWithRootViewController:self.lifePage];
    
    //购物车
    self.shopCarPage = [[ShoppingCartView alloc] initWithNibName:@"ShoppingCartView" bundle:nil];
    shopCarPage.tabBarItem.image = [UIImage imageNamed:@"tab_shopcar"];
    shopCarPage.tabBarItem.title = @"购物车";
    UINavigationController *shopcarPageNav = [[UINavigationController alloc] initWithRootViewController:self.shopCarPage];
    
    //我
    self.settingPage = [[SettingView alloc] initWithNibName:@"SettingView" bundle:nil];
    settingPage.tabBarItem.image = [UIImage imageNamed:@"tab_my"];
    settingPage.tabBarItem.title = @"我";
    UINavigationController *settingPageNav = [[UINavigationController alloc] initWithRootViewController:self.settingPage];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             mainPageNav,
                                             stewardPageNav,
                                             lifePageNav,
                                             shopcarPageNav,
                                             settingPageNav,
                                             nil];
    [[self.tabBarController tabBar] setSelectedImageTintColor:[UIColor colorWithRed:246.0/255 green:129.0/255 blue:33.0/255 alpha:1.0]];
    //设置UINavigationController背景
    if (IS_IOS7) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_bg7"]  forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_bg"]  forBarMetrics:UIBarMetricsDefault];
        [[self.tabBarController tabBar] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    }
    
    
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"cBj05GkdddmsGNrG853UXGnO" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //设置目录不进行IOS自动同步！否则审核不能通过
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [NSString stringWithFormat:@"%@/cfg", [paths objectAtIndex:0]];
    NSURL *dbURLPath = [NSURL fileURLWithPath:directory];
    [self addSkipBackupAttributeToItemAtURL:dbURLPath];
    [self addSkipBackupAttributeToPath:directory];
    
    
    //集成信鸽start
    [XGPush startApp:2200063826 appKey:@"INP8724BA8DB"];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //[XGPush setAccount:@"testAccount1"];
    
    //推送反馈(app不在前台运行时，点击推送激活时)
    [XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
        //角标清0
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        //清除所有通知(包含本地通知)
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NoticeFrameView *noticeView = [[NoticeFrameView alloc] initWithNibName:@"NoticeFrameView" bundle:nil];
        noticeView.presentType = @"present";
        UINavigationController *noticeViewNav = [[UINavigationController alloc] initWithRootViewController:noticeView];
        
        [self.window.rootViewController presentViewController:noticeViewNav animated:YES completion:^{
            _isForeground = NO;
        }];
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    //清除所有通知(包含本地通知)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    //信鸽END
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.tabBarController ];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

//信鸽
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock ,deviceToken: %@",deviceTokenStr);
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    //注册设备
    [[XGSetting getInstance] setChannel:@"appstore"];
    //    [[XGSetting getInstance] setGameServer:@"巨神峰"];
    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    [XGPush setTag:@"0"];
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"%@",str);
    
}

//点击通知出发事件
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    
    
    //回调版本示例
    /**/
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleReceiveNotification successBlock");
        if (_isForeground == YES) {
            //角标清0
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            //清除所有通知(包含本地通知)
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            NoticeFrameView *noticeView = [[NoticeFrameView alloc] initWithNibName:@"NoticeFrameView" bundle:nil];
            noticeView.presentType = @"present";
            UINavigationController *noticeViewNav = [[UINavigationController alloc] initWithRootViewController:noticeView];
            
            [self.window.rootViewController presentViewController:noticeViewNav animated:YES completion:^{
            _isForeground = NO;
            }];
        }
        else
        {
            NSString *alertStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:@"推送消息" message:alertStr delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
            [notificationAlert show];
        }
        
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleReceiveNotification errorBlock");
    };
    
    void (^completion)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[xg push completion]userInfo is %@",userInfo);
    };
    
    [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //角标清0
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        //清除所有通知(包含本地通知)
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NoticeFrameView *noticeView = [[NoticeFrameView alloc] initWithNibName:@"NoticeFrameView" bundle:nil];
        noticeView.presentType = @"present";
        UINavigationController *noticeViewNav = [[UINavigationController alloc] initWithRootViewController:noticeView];
        
        [self.window.rootViewController presentViewController:noticeViewNav animated:YES completion:^{
            
        }];
    }
}

//信鸽

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //清除所有通知(包含本地通知)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    _isForeground = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveUserInfo
{
    UserModel *usermodel = [UserModel Instance];
    if ([usermodel isLogin]) {
        NSString *userinfoUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&tel=%@", api_base_url, api_getuserinfo, appkey, [usermodel getUserValueForKey:@"tel"]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:userinfoUrl]];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestUserinfo:)];
        [request startAsynchronous];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)requestUserinfo:(ASIHTTPRequest *)request
{
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!json) {
        return;
    }
    User *user = [Tool readJsonStrToUser:request.responseString];
    int userid = [user.id intValue];
    if (userid > 0) {
        //设置登录并保存用户信息
        UserModel *userModel = [UserModel Instance];
        [userModel saveIsLogin:YES];
        [userModel saveValue:user.id ForKey:@"id"];
        [userModel saveValue:user.cid ForKey:@"cid"];
        [userModel saveValue:user.build_id ForKey:@"build_id"];
        [userModel saveValue:user.house_number ForKey:@"house_number"];
        [userModel saveValue:user.carport_number ForKey:@"carport_number"];
        [userModel saveValue:user.name ForKey:@"name"];
        [userModel saveValue:user.nickname ForKey:@"nickname"];
        [userModel saveValue:user.address ForKey:@"address"];
        [userModel saveValue:user.tel ForKey:@"tel"];
        [userModel saveValue:user.pwd ForKey:@"pwd"];
        [userModel saveValue:user.avatar ForKey:@"avatar"];
        [userModel saveValue:user.email ForKey:@"email"];
        [userModel saveValue:user.card_id ForKey:@"card_id"];
        [userModel saveValue:user.property ForKey:@"property"];
        [userModel saveValue:user.plate_number ForKey:@"plate_number"];
        [userModel saveValue:user.credits ForKey:@"credits"];
        [userModel saveValue:user.remark ForKey:@"remark"];
        [userModel saveValue:user.checkin ForKey:@"checkin"];
    }
}

- (void)saveAlipayKeyInfo
{
    NSString *userinfoUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_getAlipay, appkey];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:userinfoUrl]];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestAlipayInfo:)];
    [request startAsynchronous];
}

- (void)requestAlipayInfo:(ASIHTTPRequest *)request
{
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!json) {
        return;
    }
    AlipayInfo *alipay = [Tool readJsonStrToAliPay:request.responseString];
    if (alipay) {
        //保存支付宝信息
        UserModel *userModel = [UserModel Instance];
        [userModel saveValue:alipay.DEFAULT_PARTNER ForKey:@"DEFAULT_PARTNER"];
        [userModel saveValue:alipay.DEFAULT_SELLER ForKey:@"DEFAULT_SELLER"];
        [userModel saveValue:alipay.PRIVATE ForKey:@"PRIVATE"];
        [userModel saveValue:alipay.PUBLIC ForKey:@"PUBLIC"];
    }
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

- (void)addSkipBackupAttributeToPath:(NSString*)path {
    u_int8_t b = 1;
    setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}


//支付宝独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"uoe:%@",query);
    [self parse:url application:application];
    return YES;
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
    if (result)
    {
        
        if (result.statusCode == 9000)
        {
            /*
             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
             */
            
            //交易成功
            //UserModel *userModel = [UserModel Instance];
            NSString* key = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"buyOK" object:nil];
            }
            
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
    NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
    return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
    AlixPayResult * result = nil;
    
    if (url != nil && [[url host] compare:@"safepay"] == 0) {
        result = [self resultFromURL:url];
    }
    
    return result;
}

//初始化分享
- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
//    [ShareSDK connectSinaWeiboWithAppKey:@"1434319718"
//                               appSecret:@"c1affea9508aa4d0f8ac8d580d092592"
//                             redirectUri:@"http://house.nwclhn.com"];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801548378"
                                  appSecret:@"dba9e9e768ceb064074774e2ac517806"
                                redirectUri:@"http://a.app.qq.com/o/simple.jsp?pkgname=com.greenorange.blife"
                                   wbApiCls:[WeiboApi class]];
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wxd8f6b7ac215ffe1d" wechatCls:[WXApi class]];
}

- (void)initUmeng
{
    [MobClick startWithAppkey:@"5437335ffd98c554ef017612" reportPolicy:BATCH channelId:@""];
}
@end
