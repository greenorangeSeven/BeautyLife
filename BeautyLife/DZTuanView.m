//
//  DZTuanView.m
//  BeautyLife
//
//  Created by Seven on 14-12-5.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "DZTuanView.h"
#import "MobClick.h"

@interface DZTuanView ()

@end

@implementation DZTuanView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"周边团购";
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
    
    self.tuanTable.frame = CGRectMake(self.tuanTable.frame.origin.x, self.tuanTable.frame.origin.y, self.tuanTable.frame.size.width, self.tuanTable.frame.size.height-33);
    
    self.tuanTable.dataSource = self;
    self.tuanTable.delegate = self;
    
    allCount = 0;
    //添加的代码
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tuanTable addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    tuans = [[NSMutableArray alloc] initWithCapacity:20];
    
    [self getTuanIdList];
}

- (NSString *)generateDZTuanIdUrl
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@"长沙" forKey:@"city"];
    [param setValue:timestamp forKey:@"date"];
    
    NSString *dzurl = [Tool serializeURL:@"http://api.dianping.com/v1/deal/get_daily_new_id_list" params:param];
    return dzurl;
}


//获取大众点评团购id数据
- (void)getTuanIdList
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *dzurl = [self generateDZTuanIdUrl];
        [[AFOSCClient sharedClient]getPath:dzurl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           tuanIdList = [Tool readJsonStrToDZDPTuanIDList:operation.responseString];
                                           [self reload:YES];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"列表获取出错");
                                       
                                       
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           //                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
        
    }
}

//刷新通知事件
- (void)refreshed:(NSNotification *)notification
{
    if (notification.object) {
        if ([(NSString *)notification.object isEqualToString:@"0"]) {
            [self.tuanTable setContentOffset:CGPointMake(0, -75) animated:YES];
            [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
        }
    }
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tuanTable];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tuanTable];
}

- (void)viewDidUnload
{
    [self setTuanTable:nil];
    _refreshHeaderView = nil;
    [tuans removeAllObjects];
    tuans = nil;
    
    [_imageDownloadsInProgress removeAllObjects];
    
    [super viewDidUnload];
}

//重新载入类型
- (void)reloadType:(int)ncatalog
{
    [self clear];
    [self.tuanTable reloadData];
    [self reload:NO];
}

- (void)clear
{
    allCount = 0;
    [tuans removeAllObjects];
    [_imageDownloadsInProgress removeAllObjects];
    isLoadOver = NO;
}

//获取大众点评团购数据模型数组
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
        int pageIndex = allCount/20;
        
        NSRange range = NSMakeRange(pageIndex * 20, 20);
        NSArray *newarrays = [tuanIdList subarrayWithRange:range];
        NSString *idStrings = [newarrays componentsJoinedByString:@","];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:idStrings forKey:@"deal_ids"];
        
        NSString *dzurl = [Tool serializeURL:@"http://api.dianping.com/v1/deal/get_batch_deals_by_id" params:param];
        [[AFOSCClient sharedClient]getPath:dzurl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       NSMutableArray *newNews = [Tool readJsonStrToDZDPTuanList:operation.responseString];
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
                                           [tuans addObjectsFromArray:newNews];
                                           [self.tuanTable reloadData];
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
            return tuans.count == 0 ? 1 : tuans.count;
        }
        else
            return tuans.count + 1;
    }
    else
        return tuans.count;
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
    if ([tuans count] > 0) {
        if ([indexPath row] < [tuans count])
        {
            DZTuanCell *cell = [tableView dequeueReusableCellWithIdentifier:DZTuanCellIdentifier];
            if (!cell) {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"DZTuanCell" owner:self options:nil];
                for (NSObject *o in objects) {
                    if ([o isKindOfClass:[DZTuanCell class]]) {
                        cell = (DZTuanCell *)o;
                        break;
                    }
                }
            }
            DZTuan *shop = [tuans objectAtIndex:[indexPath row]];
            cell.titleLb.text = shop.title;
            
            cell.descLb.text = shop.desc;
            cell.tuanPriLb.text = [NSString stringWithFormat:@"￥%.2f", shop.current_price];
            
            //去除所以子视图
            for(UIView *view in [cell.yuanPriLb subviews])
            {
                [view removeFromSuperview];
            }
            
            StrikeThroughLabel *slabel = [[StrikeThroughLabel alloc] initWithFrame:CGRectMake(0, 0, 56, 21)];
            slabel.text = [NSString stringWithFormat:@"￥%.2f", shop.list_price];
            slabel.font = [UIFont italicSystemFontOfSize:12.0f];
            slabel.strikeThroughEnabled = YES;
            [cell.yuanPriLb addSubview:slabel];
            
            //店铺图片
            if (shop.photoImgData) {
                cell.picIv.image = shop.photoImgData;
            }
            else
            {
                if ([shop.s_image_url isEqualToString:@""]) {
                    shop.photoImgData = [UIImage imageNamed:@"loadingpic2"];
                }
                else
                {
                    NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:shop.s_image_url]];
                    if (imageData)
                    {
                        shop.photoImgData = [UIImage imageWithData:imageData];
                        cell.picIv.image = shop.photoImgData;
                    }
                    else
                    {
                        IconDownloader *downloader = [_imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                        if (downloader == nil) {
                            ImgRecord *record = [ImgRecord new];
                            record.url = shop.s_image_url;
                            [self startIconDownload:record forIndexPath:indexPath];
                        }
                    }
                }
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
    if (row >= [tuans count]) {
        //启动刷新
        if (!isLoading) {
            [self performSelector:@selector(reload:)];
        }
    }
    else
    {
        DZTuan *n = [tuans objectAtIndex:[indexPath row]];
        if (n) {
            DZDPDetailView *detail = [[DZDPDetailView alloc] init];
            detail.urlStr = n.deal_h5_url;
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

- (void)appImageDidLoad:(NSString *)index
{
    int _index = [index intValue];
    if (_index >= [tuans count]) {
        return;
    }
    DZTuan *t = [tuans objectAtIndex:[index intValue]];
    if (t) {
        IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:index];
        if (iconDownloader) {
            t.photoImgData = iconDownloader.imgRecord.img;
        }
        // cache it
        NSData * imageData = UIImagePNGRepresentation(t.photoImgData);
        [_iconCache putImage:imageData withName:[TQImageCache parseUrlForCacheName:t.s_image_url]];
        [self.tuanTable reloadData];
        
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
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tuanTable];
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
    [self.tuanTable setDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick beginLogPageView:@"DZDPTuanView"];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DZDPTuanView"];
    
    if (self.imageDownloadsInProgress != nil) {
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    }
}

- (void)didReceiveMemoryWarning {
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    //清空
    for (DZTuan *c in tuans) {
        c.photoImgData = nil;
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
