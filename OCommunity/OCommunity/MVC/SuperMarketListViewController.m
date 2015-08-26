//
//  SuperMarketListViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "SuperMarketListViewController.h"
#import "SuperMarketListTableViewCell.h"
#import "CityBtn.h"
#import "AppDelegate.h"
#import "CityListViewController.h"
#import "SearchResultViewController.h"
#import <AddressBook/AddressBook.h>
#import "CommunityTabBarViewController.h"
#import "Market.h"
#import "MJRefresh.h"
#import "AreaData.h"

@interface SuperMarketListViewController ()

{
    CGSize screenSize;
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) CityBtn *chooseCityBtn;
@property (nonatomic, strong) NSMutableArray *markets;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) BMKLocationService *locService;

@end

@implementation SuperMarketListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    screenSize = [UIScreen mainScreen].bounds.size;
    _markets = [NSMutableArray array];
    _isRefresh = NO;
    
    [self navBarHandle];
    [self createTableView];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [self refreshLocation];
    } else {
        [self performSelector:@selector(iPhone4Action) withObject:nil afterDelay:1.0];
    }
    
    // Do any additional setup after loading the view.
}

-(void)iPhone4Action
{
    [self refreshLocation];
}

#define kChooseCityBtn_width 70
#define kSearchImg_width 15

-(void)navBarHandle
{
    self.navigationController.navigationBar.barTintColor = kRedColor;
    _chooseCityBtn = [[CityBtn alloc] initWithFrame:CGRectMake(0, 0, kChooseCityBtn_width, 25)];
    
    //城市列表
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_chooseCityBtn];
    
    __weak SuperMarketListViewController *weakSelf = self;
    _chooseCityBtn.cityBlock = ^{
        //进入城市列表页面
        CityListViewController *cityVC = [[CityListViewController alloc] init];
        
        cityVC.clickCellBlock = ^(AreaData *area){
            weakSelf.chooseCityBtn.city.text = area.area_name;
            //根据地区id获取商户列表
            [weakSelf requestSuperListByArea:area];
        };
        [weakSelf.navigationController pushViewController:cityVC animated:YES];
    };
    
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"周边超市"];
    //重新定位
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    locationBtn.frame = CGRectMake(0, 0, 30, 30);
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationAndRefreshData:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locationBtn];
}

-(void)requestSuperListByArea:(AreaData *)area
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
    [YanMethodManager removeEmptyViewOnView:self.view];
    hud.labelText = @"加载中...";
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=storelist"] postData:[NSString stringWithFormat:@"lon=%f&lat=%f&mall_id=%d",_coordinate.longitude,_coordinate.latitude,area.area_id]];
    request.successRequest = ^(NSDictionary *areaDic){
        NSLog(@"============ market list by area = %@",areaDic);
        [_markets removeAllObjects];
        [MBProgressHUD hideHUDForView:_tableView animated:YES];
        [self marketListRequestDataHandleWithDic:areaDic];
    };
    request.failureRequest = ^(NSError *error){
        [MBProgressHUD hideHUDForView:_tableView animated:YES];
    };
    
}

//重新定位
-(void)locationAndRefreshData:(UIButton *)button
{
    [self searchAction];
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocation *newLocation = userLocation.location;
    _coordinate = newLocation.coordinate;
    [_locService stopUserLocationService];
    
    NSLog(@"======== lat: %f , lon: %f",_coordinate.latitude,_coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *place = placemarks.lastObject;
        NSString *localCity = place.addressDictionary[(NSString *)kABPersonAddressCityKey];
        
//        NSLog(@"=========== address = %@,%@,%@,%@,%@,%@,%@,%@",place.addressDictionary[@"city"],place.addressDictionary[@"Country"],place.addressDictionary[@"FormattedAddressLines"],place.addressDictionary[@"Name"],place.addressDictionary[@"State"],place.addressDictionary[@"Street"],place.addressDictionary[@"SubLocality"],place.addressDictionary[@"Thoroughfare"]);
        if (localCity) {
            if (!_isRefresh) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
                hud.labelText = @"定位中...";
            }
            _chooseCityBtn.city.font = [UIFont systemFontOfSize:kFontSize_3];
            _chooseCityBtn.city.text = localCity;
            //在这里请求超市列表
            NetWorkRequest *request = [[NetWorkRequest alloc] init];
            NSString *paraStr = [NSString stringWithFormat:@"lat=%f&lon=%f",_coordinate.latitude,_coordinate.longitude];
            //            NSLog(@"========= para Str = %@",paraStr);
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=storelist"] postData:paraStr];
            request.successRequest = ^(NSDictionary *dataDic){
                //                NSLog(@"=============== list = %@",dataDic);
                [_tableView.header endRefreshing];
                _isRefresh = NO;
                [MBProgressHUD hideAllHUDsForView:_tableView animated:YES];
                [self marketListRequestDataHandleWithDic:dataDic];
            };
            request.failureRequest = ^(NSError *error){
                [MBProgressHUD hideAllHUDsForView:_tableView animated:YES];
            };
        } else {
            [MBProgressHUD hideAllHUDsForView:_tableView animated:YES];
            _chooseCityBtn.city.font = [UIFont systemFontOfSize:kFontSize_4];
            _chooseCityBtn.city.text = @"定位失败";
            [self failForRequestMarketList];
        }
    }];
}

-(void)failForRequestMarketList
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法定位到周边超市,请手动选择地区" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        CityListViewController *cityVC = [[CityListViewController alloc] init];
        
        cityVC.clickCellBlock = ^(AreaData *area){
            self.chooseCityBtn.city.text = area.area_name;
            //根据地区id获取商户列表
            [self requestSuperListByArea:area];
        };
        [self.navigationController pushViewController:cityVC animated:YES];
    }
}

-(void)marketListRequestDataHandleWithDic:(NSDictionary *)dic
{
    [_markets removeAllObjects];
    NSNumber *code = [dic objectForKey:@"code"];
    if (code.intValue == 200) {
        
        NSArray *datasArr = [dic objectForKey:@"datas"];
        if ([[YanMethodManager defaultManager] isArrayEmptyWithArray:datasArr] == NO) {
            
            for (int i = 0; i < datasArr.count; i++) {
                NSDictionary *itemDic = datasArr[i];
                Market *market = [[Market alloc] initWithDic:itemDic];
                [_markets addObject:market];
            }
            if (_markets.count <= 0) {
                [self failForRequestMarketList];
            }
        }
        if (datasArr.count <= 0) {
            [YanMethodManager emptyDataInView:self.view title:@"没有搜索到周边超市,点击右上角搜索超市"];
        }
        [_tableView reloadData];
    }
}

-(void)searchAction
{
    NSLog(@"======= 搜索商品／商家");
    SearchResultViewController *searchVC = [[SearchResultViewController alloc] init];
    searchVC.searchStore_Push = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)createTableView
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenBounds.size.width, screenBounds.size.height-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 10)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreen_width, 0.5)];
    line.backgroundColor = kDividColor;
    [footer addSubview:line];
    _tableView.tableFooterView = footer;
    
    __weak SuperMarketListViewController *weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        _isRefresh = YES;
        [weakSelf refreshLocation];
    }];
}

-(void)refreshLocation
{
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    [BMKLocationService setLocationDistanceFilter:100.f];
    if (!_locService) {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
    }
    
    [_locService startUserLocationService];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _markets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *marketList = @"market";
    SuperMarketListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:marketList];
    if (!cell) {
        cell = [[SuperMarketListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:marketList];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Market *item = _markets[indexPath.row];
    cell.market = item;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuperMarketListTableViewCell *cell = (SuperMarketListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMarket_name];
    [[NSUserDefaults standardUserDefaults] setObject:cell.marketName.text forKey:kMarket_name];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CommunityTabBarViewController *bossTBV = mainStoryboard.instantiateInitialViewController;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"market_item_local"];
    
    Market *marketItem = _markets[indexPath.row];
    marketItem.fare = (marketItem.fare == nil ? [NSNumber numberWithInt:0] : marketItem.fare);
    marketItem.dis = (marketItem.dis == nil ? @"" : marketItem.dis);
    NSDictionary *itemDic = @{@"store_id":marketItem.store_id,@"store_name":marketItem.store_name,@"alisa":marketItem.alisa,@"pic":marketItem.pic,@"address":marketItem.address,@"lat":marketItem.lat,@"lon":marketItem.lon,@"dis":marketItem.dis,@"telephone":marketItem.telephone,@"daliver_description":marketItem.daliver_description,@"jfdk":[NSString stringWithFormat:@"%d",marketItem.jfdk],@"fare":marketItem.fare,@"class_id":[NSString stringWithFormat:@"%d",marketItem.class_id]};
    [[NSUserDefaults standardUserDefaults] setObject:itemDic forKey:@"market_item_local"];
    [self presentViewController:bossTBV animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
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

@end
