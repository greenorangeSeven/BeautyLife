//
//  ShoppingCartView.m
//  BeautyLife
//
//  Created by Seven on 14-8-25.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ShoppingCartView.h"
#import "PayOrder.h"
#import "AlipayUtils.h"

@interface ShoppingCartView ()

@end

@implementation ShoppingCartView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"我的购物车";
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
    goodData = [[NSMutableArray alloc] init];
    self.goodTableView.dataSource = self;
    self.goodTableView.delegate = self;
    self.goodTableView.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];
    [self reloadData];
}

//取数方法
- (void)reloadData
{
    [goodData removeAllObjects];
    total = 0.00;
    FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
    if (![database open]) {
        NSLog(@"Open database failed");
        return;
    }
    if (![database tableExists:@"shoppingcart"]) {
        [database executeUpdate:createshoppingcart];
    }
    FMResultSet* resultSet=[database executeQuery:@"select * from shoppingcart order by business_id"];
    while ([resultSet next]) {
        Goods *good = [[Goods alloc] init];
        good.id = [resultSet stringForColumn:@"goodid"];
        good.title = [resultSet stringForColumn:@"title"];
        good.thumb = [resultSet stringForColumn:@"thumb"];
        good.price = [resultSet stringForColumn:@"price"];
        good.store_name = [resultSet stringForColumn:@"store_name"];
        good.business_id = [resultSet stringForColumn:@"business_id"];
        good.number = [NSNumber numberWithInteger:[resultSet intForColumn:@"number"]];
        
        total += [good.price doubleValue] * [good.number intValue];
        [goodData addObject:good];
    }
    if ([goodData count] > 0) {
        self.totalLb.text = [NSString stringWithFormat:@"%.2f", total];
        [self.goodTableView reloadData];
    }
    [database close];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [goodData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ShoppingCartCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ShoppingCartCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[ShoppingCartCell class]]) {
                cell = (ShoppingCartCell *)o;
                break;
            }
        }
    }
    int indexRow = [indexPath row];
    
    Goods *good = (Goods *)[goodData objectAtIndex:indexRow];
    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"loadingpic4.png"]];
    imageView.imageURL = [NSURL URLWithString:good.thumb];
    imageView.frame = CGRectMake(0.0f, 0.0f, 80.0f, 80.0f);
    [cell.picIv addSubview:imageView];
    
    cell.storeNameLb.text = good.store_name;
    cell.titleLb.text = good.title;
    cell.priceLb.text = good.price;
    cell.numberTv.text = [good.number stringValue];
    
    if ([good.number intValue] <= 1) {
        cell.minusBtn.enabled = NO;
    }
    
    [cell.minusBtn addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.minusBtn.tag = indexRow;
    
    [cell.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.addBtn.tag = indexRow;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = indexRow;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (IBAction)minusAction:(id)sender {
    UIButton *tap = (UIButton *)sender;
    if (tap) {
        Goods *good = (Goods *)[goodData objectAtIndex:tap.tag];

        FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
        if (![database open]) {
            NSLog(@"Open database failed");
            return;
        }
        if (![database tableExists:@"shoppingcart"]) {
            [database executeUpdate:createshoppingcart];
        }
        BOOL updateGood = [database executeUpdate:@"update shoppingcart set number = number - 1 where goodid= ?", good.id];
        [database close];
        if (updateGood) {
            [self reloadData];
        }
    }
}

- (IBAction)addAction:(id)sender {
    UIButton *tap = (UIButton *)sender;
    if (tap) {
        Goods *good = (Goods *)[goodData objectAtIndex:tap.tag];
        
        FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
        if (![database open]) {
            NSLog(@"Open database failed");
            return;
        }
        if (![database tableExists:@"shoppingcart"]) {
            [database executeUpdate:createshoppingcart];
        }
        BOOL updateGood = [database executeUpdate:@"update shoppingcart set number = number + 1 where goodid= ?", good.id];
        [database close];
        if (updateGood) {
            [self reloadData];
        }
    }
}

- (IBAction)deleteAction:(id)sender {
    UIButton *tap = (UIButton *)sender;
    if (tap) {
        Goods *good = (Goods *)[goodData objectAtIndex:tap.tag];
        
        FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
        if (![database open]) {
            NSLog(@"Open database failed");
            return;
        }
        if (![database tableExists:@"shoppingcart"]) {
            [database executeUpdate:createshoppingcart];
        }
        BOOL detele = [database executeUpdate:@"delete from shoppingcart where goodid = ?", good.id];
        [database close];
        if (detele) {
            [self reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)balanceAction:(id)sender {
    UserModel *user = [UserModel Instance];
    
    OrderInfo *orderInfo = [[OrderInfo alloc] init];
    orderInfo.userid = [NSNumber numberWithInt:[[user getUserValueForKey:@"id"] intValue]];
    orderInfo.mobile = [user getUserValueForKey:@"tel"];
    orderInfo.address = [user getUserValueForKey:@"address"];
    orderInfo.receiver = [user getUserValueForKey:@"name"];
    //    orderInfo.amount = [NSNumber numberWithFloat:total];
    
    FMDatabase* database=[FMDatabase databaseWithPath:[Tool databasePath]];
    if (![database open]) {
        NSLog(@"Open database failed");
        return;
    }
    if (![database tableExists:@"shoppingcart"]) {
        [database executeUpdate:createshoppingcart];
    }
    FMResultSet* businessSet=[database executeQuery:@"SELECT DISTINCT business_id FROM shoppingcart"];
    NSMutableArray *orderBusinessArray = [[NSMutableArray alloc] init];
    while ([businessSet next]) {
        OrderBusiness *business = [[OrderBusiness alloc] init];
        business.store_id = [NSNumber numberWithInt:[[businessSet stringForColumn:@"business_id"] intValue]];
        
        FMResultSet* goodSet=[database executeQuery:@"SELECT * FROM shoppingcart where business_id = ?", [businessSet stringForColumn:@"business_id"]];
        NSMutableArray *goodArray = [[NSMutableArray alloc] init];
        float businessAmount = 0.0;
        while ([goodSet next]) {
            OrderGood *good = [[OrderGood alloc] init];
            good.goods_id = [NSNumber numberWithInt:[[goodSet stringForColumn:@"goodid"] intValue]];
            good.title = [goodSet stringForColumn:@"title"];
            good.price = [goodSet stringForColumn:@"price"];
            good.quantity = [NSNumber numberWithInteger:[goodSet intForColumn:@"number"]];
            businessAmount += [good.price floatValue] * [goodSet intForColumn:@"number"];
            [goodArray addObject:good];
        }
        business.goodlist = goodArray;
        business.amount = [NSNumber numberWithFloat:businessAmount];
        [orderBusinessArray addObject:business];
    }
    orderInfo.businessOrderList = orderBusinessArray;
    
    NSData *jsonData = [PrintObject getJSON:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonText);
    
    [self payFeeAction:jsonText];
}

#pragma mark 付费事件处理
- (void)payFeeAction:(NSString *)content
{
    NSString *regUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_send_order];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    
    //商品订单json数据
    [request setPostValue:content  forKey:@"content"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestBuy:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"缴费中..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
}
- (void)requestBuy:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!json)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                     message:request.responseString
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    
    OrdersNum *num = [Tool readJsonStrToOrdersNum:request.responseString];
    int errorCode = [num.status intValue];
    NSString *errorMessage = num.info;
    switch (errorCode) {
        case 1:
        {
            UserModel *usermodel = [UserModel Instance];
            PayOrder *pro = [[PayOrder alloc] init];
            pro.out_no = num.serial_no;
            pro.subject = @"美世界订单付款";
            pro.body = @"美世界订单在线付款";
            pro.price = 0.01;
            pro.partnerID = [usermodel getUserValueForKey:@"DEFAULT_PARTNER"];
            pro.partnerPrivKey = [usermodel getUserValueForKey:@"PRIVATE"];
            pro.sellerID = [usermodel getUserValueForKey:@"DEFAULT_SELLER"];
            
            [AlipayUtils doPay:pro NotifyURL:api_goods_notify AndScheme:@"BeautyLifeAlipay" seletor:nil target:nil];
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
        }
            break;
    }
}

@end
