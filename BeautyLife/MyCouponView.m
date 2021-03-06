//
//  MyCouponView.m
//  LuoYang
//
//  Created by Seven on 14-10-15.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "MyCouponView.h"
#import "TQImageCache.h"
#import "MyCouponCell.h"
#import "Coupons.h"

@interface MyCouponView ()

@end

@implementation MyCouponView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"我的优惠券";
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
    //适配iOS7uinavigationbar遮挡问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self loadData];
}

//获取我的优惠券数据集合
- (void)loadData
{
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&userid=%@", api_base_url, api_mycoupons, appkey, [[UserModel Instance] getUserValueForKey:@"id"]];
    
    [[AFOSCClient sharedClient] getPath:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try
        {
            [couponArray removeAllObjects];
            couponArray = [Tool readJsonStrToMyCouponArray:operation.responseString];
            [self.tableView reloadData];
            [self doneLoadingTableViewData];
        }
        @catch (NSException *exception)
        {
            [NdUncaughtExceptionHandler TakeException:exception];
        }
        @finally
        {
            [self doneLoadingTableViewData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"获取出错");
         [self doneLoadingTableViewData];
         //刷新错误
         if([UserModel Instance].isNetworkRunning == NO)
         {
             return;
         }
         if([UserModel Instance].isNetworkRunning)
         {
             [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
         }
     }];
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}

#pragma 下提刷新
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
    [self refresh];
}

// tableView添加拉更新
- (void)egoRefreshTableHeaderDidTriggerToBottom
{
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
- (void)refresh
{
    if ([UserModel Instance].isNetworkRunning) {
        [self loadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([couponArray count] > 0)
    {
        if (indexPath.row < [couponArray count])
        {
            MyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCouponCellIdentifier];
            if (!cell)
            {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyCouponCell" owner:self options:nil];
                for (NSObject *o in objects)
                {
                    if ([o isKindOfClass:[MyCouponCell class]])
                    {
                        cell = (MyCouponCell *)o;
                        break;
                    }
                }
            }
            Coupons *coupon = [couponArray objectAtIndex:[indexPath row]];
            cell.storenameLb.text = coupon.store_name;
            cell.titleLb.text = coupon.coupons_title;
            cell.validityLb.text = [NSString stringWithFormat:@"%@前有效", coupon.validityStr];
            
            if (coupon.imgData) {
                cell.thumbIv.image = coupon.imgData;
            }
            else
            {
                if ([coupon.thumb isEqualToString:@""]) {
                    coupon.imgData = [UIImage imageNamed:@"nopic2"];
                }
                else
                {
                    NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:coupon.thumb]];
                    if (imageData)
                    {
                        coupon.imgData = [UIImage imageWithData:imageData];
                        cell.thumbIv.image = coupon.imgData;
                    }
                    else
                    {
                        IconDownloader *downloader = [_imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                        if (downloader == nil) {
                            ImgRecord *record = [ImgRecord new];
                            record.url = coupon.thumb;
                            [self startIconDownload:record forIndexPath:indexPath];
                        }
                    }
                }
            }
            
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Coupons *coupon = [couponArray objectAtIndex:[indexPath row]];
    if (coupon) {
        CouponDetailView *couponDetail = [[CouponDetailView alloc] init];
        couponDetail.couponsId = coupon.coupons_id;
        [self.navigationController pushViewController:couponDetail animated:YES];
    }
    
}

#pragma 下载图片
- (void)startIconDownload:(ImgRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%d",[indexPath row]];
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:key];
    if (iconDownloader == nil) {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imgRecord = imgRecord;
        iconDownloader.index = key;
        iconDownloader.delegate = self;
        [_imageDownloadsInProgress setObject:iconDownloader forKey:key];
        [iconDownloader startDownload];
    }
}

- (void)appImageDidLoad:(NSString *)index
{
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:index];
    if (iconDownloader)
    {
        int _index = [index intValue];
        if (_index >= [couponArray count])
        {
            return;
        }
        Coupons *coupon = [couponArray objectAtIndex:[index intValue]];
        if (coupon) {
            coupon.imgData = iconDownloader.imgRecord.img;
            // cache it
            NSData * imageData = UIImagePNGRepresentation(coupon.imgData);
            [_iconCache putImage:imageData withName:[TQImageCache parseUrlForCacheName:coupon.thumb]];
            [self.tableView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
