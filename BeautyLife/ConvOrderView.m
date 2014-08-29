//
//  ConvOrder.m
//  BeautyLife
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ConvOrderView.h"

@interface ConvOrderView ()

@end

@implementation ConvOrderView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"便民服务";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 58, 26)];
        [rBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setImage:[UIImage imageNamed:@"conv_order_share"] forState:UIControlStateNormal];
        UIBarButtonItem *btnShare = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnShare;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction:(id)sender
{
    NSDictionary *contentDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@地址:%@ ,电话:%@", self.shop.title, self.shop.address, self.shop.tel], @"title",
                                [NSString stringWithFormat:@"%@地址:%@ ,电话:%@", self.shop.title, self.shop.address, self.shop.tel], @"summary",
                                nil, @"thumb",
                                nil];
    [Tool shareAction:sender andShowView:self.view andContent:contentDic];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    _titleLb.text = _shop.title;
    _addressLb.text = [NSString stringWithFormat:@"地址:%@", _shop.address];
    _telLb.text = [NSString stringWithFormat:@"电话:%@", _shop.tel];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    NSString *detailUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_lifeinfo, appkey, self.shop.id];
    NSURL *url = [ NSURL URLWithString : detailUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSError *error = [request error ];
    assert (!error);
    shopDetail = [Tool readJsonStrToShopInfo:[request responseString]];
    
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    self.webView.delegate = self;
    NSString *html = [NSString stringWithFormat:@"<body>%@<div id='web_body'>%@</div></body>", HTML_Style, shopDetail.content];
    NSString *result = [Tool getHTMLString:html];
    [self.webView loadHTMLString:result baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewP
{
    if (hud != nil) {
        [hud hide:YES];
    }
    NSArray *arr = [webViewP subviews];
    UIScrollView *webViewScroll = [arr objectAtIndex:0];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, webViewP.frame.origin.y + [webViewScroll contentSize].height);
    [webViewP setFrame:CGRectMake(webViewP.frame.origin.x, webViewP.frame.origin.y, webViewP.frame.size.width, [webViewScroll contentSize].height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.webView stopLoading];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
