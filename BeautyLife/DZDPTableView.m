//
//  DZDPTableView.m
//  BeautyLife
//
//  Created by Seven on 14-11-22.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "DZDPTableView.h"
#import "MobClick.h"

@interface DZDPTableView ()

@end

@implementation DZDPTableView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"大众点评";
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配iOS7uinavigationbar遮挡的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.thumbDownloadsInProgress = [NSMutableDictionary dictionary];
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }else {
        //提示用户无法进行定位操作
    }
    
    // 开始定位
    [self.locationManager startUpdatingLocation];

    
    self.shopsTable.frame = CGRectMake(self.shopsTable.frame.origin.x, self.shopsTable.frame.origin.y, self.shopsTable.frame.size.width, self.shopsTable.frame.size.height-33);
    
    self.shopsTable.dataSource = self;
    self.shopsTable.delegate = self;
    //    设置无分割线
//    self.shopsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    allCount = 0;
    //添加的代码
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.shopsTable addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    shops = [[NSMutableArray alloc] initWithCapacity:20];
//    [self reload:YES];
}

- (NSString *)generateDZDPUrl
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
    [param setValue:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
    [param setValue:@"1" forKey:@"offset_type"];
    [param setValue:@"5000" forKey:@"radius"];
    [param setValue:@"2" forKey:@"platform"];
    [param setValue:@"20" forKey:@"limit"];
    [param setValue:@"1" forKey:@"page"];
    
    NSString *dzurl = [Tool serializeURL:@"http://api.dianping.com/v1/business/find_businesses" params:param];
    return dzurl;
}

- (void)refreshed:(NSNotification *)notification
{
    if (notification.object) {
        if ([(NSString *)notification.object isEqualToString:@"0"]) {
            [self.shopsTable setContentOffset:CGPointMake(0, -75) animated:YES];
            [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
        }
    }
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.shopsTable];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.shopsTable];
}

- (void)viewDidUnload
{
    [self setShopsTable:nil];
    _refreshHeaderView = nil;
    [shops removeAllObjects];
    shops = nil;
    
    [_imageDownloadsInProgress removeAllObjects];
    [_thumbDownloadsInProgress removeAllObjects];
    
    [super viewDidUnload];
}

//重新载入类型
- (void)reloadType:(int)ncatalog
{
    [self clear];
    [self.shopsTable reloadData];
    [self reload:NO];
}

- (void)clear
{
    allCount = 0;
    [shops removeAllObjects];
    [_imageDownloadsInProgress removeAllObjects];
    [_thumbDownloadsInProgress removeAllObjects];
    isLoadOver = NO;
}

- (void)reload:(BOOL)noRefresh
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoading || isLoadOver) {
            return;
        }
        if (!noRefresh) {
            allCount = 0;
        }
        int pageIndex = allCount/20 + 1;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        if (latitude > 0 && longitude > 0) {
            [param setValue:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
            [param setValue:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
            [param setValue:@"5000" forKey:@"radius"];
//            [param setValue:@"1" forKey:@"offset_type"];
        }
        if ([city isEqualToString:@""] == NO) {
            [param setValue:city forKey:@"city"];
        }
        [param setValue:@"2" forKey:@"platform"];
        [param setValue:@"20" forKey:@"limit"];
        [param setValue:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"page"];
        NSString *dzurl = [Tool serializeURL:@"http://api.dianping.com/v1/business/find_businesses" params:param];
        [[AFOSCClient sharedClient]getPath:dzurl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       NSMutableArray *newNews = [Tool readJsonStrToDZDPShop:operation.responseString];
                                       isLoading = NO;
                                       if (!noRefresh) {
                                           [self clear];
                                       }
                                       
                                       @try {
                                           int count = [newNews count];
                                           allCount += count;
                                           if (count < 20)
                                           {
                                               isLoadOver = YES;
                                           }
                                           [shops addObjectsFromArray:newNews];
                                           [self.shopsTable reloadData];
                                           [self doneLoadingTableViewData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           [self doneLoadingTableViewData];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"列表获取出错");
                                       //如果是刷新
                                       [self doneLoadingTableViewData];
                                       
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       isLoading = NO;
                                       if ([UserModel Instance].isNetworkRunning) {
                                           //                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
        isLoading = YES;
        //        [self.newsTable reloadData];
    }
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoadOver) {
            return shops.count == 0 ? 1 : shops.count;
        }
        else
            return shops.count + 1;
    }
    else
        return shops.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([shops count] > 0) {
        if ([indexPath row] < [shops count])
        {
            DZDPTableCell *cell = [tableView dequeueReusableCellWithIdentifier:DZDPTableCellIdentifier];
            if (!cell) {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"DZDPTableCell" owner:self options:nil];
                for (NSObject *o in objects) {
                    if ([o isKindOfClass:[DZDPTableCell class]]) {
                        cell = (DZDPTableCell *)o;
                        break;
                    }
                }
            }
            DZbusinesses *shop = [shops objectAtIndex:[indexPath row]];
            cell.nameLb.text = shop.name;
            
            if (shop.distance > 0 && shop.distance < 1000) {
                cell.distanceLb.text = [NSString stringWithFormat:@"%dm", shop.distance];
            }
            else if (shop.distance > 1000)
            {
                cell.distanceLb.text = [NSString stringWithFormat:@"%.1fkm", ((float)shop.distance)/1000];
            }
            
//            cell.distanceLb.text = [NSString stringWithFormat:@"%d", shop.distance];
            cell.addressLb.text = shop.address;
            cell.telLb.text = shop.telephone;
            
            //店铺图片
            if (shop.photoImgData) {
                cell.sphotoIV.image = shop.photoImgData;
            }
            else
            {
                if ([shop.s_photo_url isEqualToString:@""]) {
                    shop.photoImgData = [UIImage imageNamed:@"loadingpic2"];
                }
                else
                {
                    NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:shop.s_photo_url]];
                    if (imageData)
                    {
                        shop.photoImgData = [UIImage imageWithData:imageData];
                        cell.sphotoIV.image = shop.photoImgData;
                    }
                    else
                    {
                        IconDownloader *downloader = [_imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                        if (downloader == nil) {
                            ImgRecord *record = [ImgRecord new];
                            record.url = shop.s_photo_url;
                            [self startIconDownload:record forIndexPath:indexPath];
                        }
                    }
                }
            }
            
            //加载星级图片
            if (shop.ratingImgData == nil)
            {
                IconDownloader *d = [_thumbDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                if (d == nil) {
                    ImgRecord *r = [ImgRecord new];
                    r.url = shop.rating_s_img_url;
                    [self startIconDownload2:r forIndexPath:indexPath];
                }
            }
            else
            {
                cell.ratingimgIV.image = shop.ratingImgData;
            }
            
            return cell;
        }
        else
        {
            return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"已经加载全部" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
        }
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"暂无数据" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
    }
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    //点击“下面20条”
    if (row >= [shops count]) {
        //启动刷新
        if (!isLoading) {
            [self performSelector:@selector(reload:)];
        }
    }
    else
    {
        DZbusinesses *n = [shops objectAtIndex:[indexPath row]];
        if (n) {
            DZDPDetailView *detail = [[DZDPDetailView alloc] init];
            detail.urlStr = n.business_url;
            [self.navigationController pushViewController:detail animated:YES];
        }
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

- (void)startIconDownload2:(ImgRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%d",[indexPath row]];
    IconDownloader *iconDownloader = [_thumbDownloadsInProgress objectForKey:key];
    if (iconDownloader == nil) {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imgRecord = imgRecord;
        iconDownloader.index = key;
        iconDownloader.delegate = self;
        [_thumbDownloadsInProgress setObject:iconDownloader forKey:key];
        [iconDownloader startDownload];
    }
}

- (void)appImageDidLoad:(NSString *)index
{
    int _index = [index intValue];
    if (_index >= [shops count]) {
        return;
    }
    DZbusinesses *t = [shops objectAtIndex:[index intValue]];
    if (t) {
        IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:index];
        if (iconDownloader) {
            t.photoImgData = iconDownloader.imgRecord.img;
        }
        
        IconDownloader *iconTweet = [_thumbDownloadsInProgress objectForKey:index];
        if (iconTweet) {
            t.ratingImgData = iconTweet.imgRecord.img;
        }
        // cache it
        NSData * imageData = UIImagePNGRepresentation(t.photoImgData);
        [_iconCache putImage:imageData withName:[TQImageCache parseUrlForCacheName:t.s_photo_url]];
        [self.shopsTable reloadData];
        
    }
}

#pragma 下提刷新
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.shopsTable];
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

// tableView添加上拉更新
- (void)egoRefreshTableHeaderDidTriggerToBottom
{
    if (!isLoading) {
        NSLog(@"lp;");
        [self performSelector:@selector(reload:)];
    }
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
        isLoadOver = NO;
        [self reload:NO];
    }
}

- (void)dealloc
{
    [self.shopsTable setDelegate:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    latitude =  coor.latitude;
    longitude = coor.longitude;
    city = @"";
    
    [self.locationManager stopUpdatingLocation];
    [self reload:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    latitude = 0;
    longitude = 0;
    city = @"长沙";
    [self reload:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick beginLogPageView:@"DZDPTableView"];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DZDPTableView"];
    
    if (self.imageDownloadsInProgress != nil) {
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
        
        NSArray *thumbAllDownloads = [self.thumbDownloadsInProgress allValues];
        [thumbAllDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    }
}

- (void)didReceiveMemoryWarning {
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    NSArray *thumbAllDownloads = [self.thumbDownloadsInProgress allValues];
    [thumbAllDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    //清空
    for (DZbusinesses *c in shops) {
        c.photoImgData = nil;
        c.ratingImgData = nil;
    }
    
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

@end
