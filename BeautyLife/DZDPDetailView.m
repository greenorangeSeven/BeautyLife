//
//  DZDPDetailView.m
//  BeautyLife
//
//  Created by Seven on 14-11-24.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "DZDPDetailView.h"

@interface DZDPDetailView ()

@end

@implementation DZDPDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    self.webView.delegate = self;
    [self.webView sizeToFit];
    NSURL *url =[NSURL URLWithString:self.urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
//    currentUrl = self.urlStr;
    
    //适配iOS7uinavigationbar遮挡的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewP
{
    if (hud != nil) {
        [hud hide:YES];
    }
    NSArray *arr = [webViewP subviews];
    UIScrollView *webViewScroll = [arr objectAtIndex:0];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, [webViewScroll contentSize].height);
//    [webViewP setFrame:CGRectMake(webViewP.frame.origin.x, webViewP.frame.origin.y, webViewP.frame.size.width, [webViewScroll contentSize].height)];
}

#pragma 浏览器链接处理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSLog(request.URL.absoluteString);
//    if(navigationType == UIWebViewNavigationTypeBackForward)
//    {
////        if ([currentUrl isEqualToString:self.urlStr]) {
//            [self.navigationController popViewControllerAnimated:YES];
////        }
//    }
//    
//    if ([[request.URL.absoluteString substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"]) {
//        currentUrl = request.URL.absoluteString;
//    }

//    DZDPDetailView *detail = [[DZDPDetailView alloc] init];
//    detail.urlStr = request.URL.absoluteString;
//    [self.navigationController pushViewController:detail animated:YES];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(id)sender {
    
    NSString *currentUrl = [[self.webView request].URL absoluteString];
    if ([currentUrl isEqualToString:self.urlStr] == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.webView goBack];
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
}
@end
