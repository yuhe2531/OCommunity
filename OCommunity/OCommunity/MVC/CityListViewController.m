//
//  CityListViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CityListViewController.h"
#import "CityData.h"
#import "AreaData.h"

@interface CityListViewController ()

//@property (nonatomic, strong) NSMutableArray *provinces;
//@property (nonatomic, strong) NSMutableArray *cities;

@property (nonatomic, strong) NSMutableArray *citiesArr;
@property (nonatomic, strong) NSMutableArray *areaArr;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"城市列表"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(cityListPop)];
//    NSString *provincePath = [[NSBundle mainBundle] pathForResource:@"ProvincesAndCities" ofType:@"plist"];
//    NSArray *plistArr = [NSArray arrayWithContentsOfFile:provincePath];
//    
//    _provinces = [NSMutableArray array];
//    _cities = [NSMutableArray array];
//    for (int i = 0; i < plistArr.count; i++) {
//        NSDictionary *provinceItem = [plistArr objectAtIndex:i];
//        NSString *province = [provinceItem objectForKey:@"State"];
//        [self.provinces addObject:province];
//        NSArray *cityArr = [provinceItem objectForKey:@"Cities"];
//        NSMutableArray *cities = [NSMutableArray array];
//        for (int j = 0; j < cityArr.count; j++) {
//            NSDictionary *cityItem = [cityArr objectAtIndex:j];
//            NSString *city = [cityItem objectForKey:@"city"];
//            [cities addObject:city];
//        }
//        [self.cities addObject:cities];
//    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _citiesArr = [NSMutableArray array];
    _areaArr = [NSMutableArray array];
    
    [self cityListRequest];
    
    // Do any additional setup after loading the view.
}

-(void)cityListRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=city"] postData:nil];
    __weak CityListViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *listDic){
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSNumber *code = [listDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSArray *datasArr = [listDic objectForKey:@"datas"];
            if ([[YanMethodManager defaultManager] isArrayEmptyWithArray:datasArr] == NO) {
                for (int i = 0; i < datasArr.count; i++) {
                    NSDictionary *cityDic = datasArr[i];
                    CityData *city = [[CityData alloc] initWithDic:cityDic];
                    NSArray *areaArr = city.subclass;
                    if (areaArr.count > 0) {
                        [weakSelf.citiesArr addObject:city];
                        NSMutableArray *array = [NSMutableArray array];
                        for (int j = 0; j < areaArr.count; j++) {
                            NSDictionary *areaDic = areaArr[j];
                            AreaData *area = [[AreaData alloc] initWithDic:areaDic];
                            [array addObject:area];
                        }
                        [weakSelf.areaArr addObject:array];
                    }
                }
            }
            [weakSelf.tableView reloadData];
        }
    };
}

-(void)cityListPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _citiesArr.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CityData *city = _citiesArr[section];
    return city.area_name;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = _areaArr[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *city = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:city];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:city];
        cell.textLabel.textColor = kBlack_Color_2;
    }
    NSMutableArray *areaArr = _areaArr[indexPath.section];
    AreaData *area = areaArr[indexPath.row];
    
    cell.textLabel.text = area.area_name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *areaArr = _areaArr[indexPath.section];
    AreaData *area = areaArr[indexPath.row];
    if (self.clickCellBlock) {
        self.clickCellBlock(area);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
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
