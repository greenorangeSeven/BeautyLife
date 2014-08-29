//
//  RechargeView.m
//  BeautyLife
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "RechargeView.h"

@interface RechargeView ()

@end

@implementation RechargeView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"票务充值";
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
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)huocheAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"火车票";
    detailView.urlStr = @"http://touch.qunar.com/h5/train/?from=touchindex";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)jipiaoAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"机票";
    detailView.urlStr = @"http://touch.qunar.com/h5/flight/";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)yidongAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"移动充值";
    detailView.urlStr = @"http://wap.10086.cn/czjf/czjf.jsp";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)liantongAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"联通充值";
    detailView.urlStr = @"http://wap.10010.com/t/home.htm";
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)dianxinAction:(id)sender {
    RechargeDetailView *detailView = [[RechargeDetailView alloc] init];
    detailView.titleStr = @"电信充值";
    detailView.urlStr = @"http://wapzt.189.cn";
    [self.navigationController pushViewController:detailView animated:YES];
}
@end
