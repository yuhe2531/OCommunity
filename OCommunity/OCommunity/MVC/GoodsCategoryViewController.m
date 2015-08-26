//
//  GoodsCategoryViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/28.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "GoodsCategoryViewController.h"
#import "CategoryContentTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "CartViewController.h"
#import "GoodsTotalCategoryTableViewCell.h"
#import "ContentCollectionViewCell.h"
#import "HomeGoodsItem.h"
#import "SearchResultViewController.h"
#import "TableHeadView.h"
#import "goodsClassify.h"
#import "NoLoginViewController.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "GoodsCommentsViewController.h"
#import "UIImageView+WebCache.h"
#import "GoodsSecondClassifyTableViewCell.h"
#import "FruitHomeTableViewCell.h"
#define kBottomView_height 40
#define kPageSize 10
#import "PayRightNowViewController.h"
@interface GoodsCategoryViewController ()<UIGestureRecognizerDelegate>

{
    NSInteger _categorySelectRow;
}

@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, assign) BOOL isLoadAll;
@property (nonatomic, assign) BOOL hasLoad;
@property (nonatomic, assign) BOOL isOtherType;//标记进入的店铺类型
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGPoint tapPoint;
@property (nonatomic,assign) BOOL marketIsLogin;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation GoodsCategoryViewController{
    NSMutableArray *tableHeadArray;
    NSMutableArray *tableRowData;
    NSMutableArray *dicArray;
    NSMutableArray *collectionData;
    NSIndexPath *_indexPath;
    NSIndexPath *_oldIndexPath;
    NSMutableArray *subviewDataArray;
    UIView *_bottomView;
    int _currentPage;
    int _totalPage;

    
}
static int pageNum =1;
static int totalNum =1;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    if (!_marketHomeMore) {
        [self categoryNaviItemHandle];

    }else{
    
        self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"更多商品"];
        [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(marketHomePop)];
    }
    if(!_marketHomeMore){
        _categorySelectRow = 0;
    }else{
    _categorySelectRow = _indexPath.section;
    }
    _collection_First = YES;
    NSDictionary *marketDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [marketDic objectForKey:@"store_id"];
    NSLog(@"============= home store id = %@",store_id);
    NSString *store_Classid = [marketDic objectForKey:@"class_id"];
    if (store_Classid.intValue == 18) {
        _isOtherType = NO;
        [self addTableViewsOnGoodsCategoryView];

    } else {
        _isOtherType = YES;
        _currentPage = 1;
        [self createTableViewSubview];
        subviewDataArray = [[NSMutableArray alloc] init];
      
    }

//    [self loadData];

    // Do any additional setup after loading the view.
}
-(void)createTableViewSubview{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height - 64-49)style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kBottomView_height)];
    _tableView.tableFooterView = _bottomView;
    
    [self.view addSubview:_tableView];
}
-(void)loadSubviewData{
    
    NSDictionary *marketDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [marketDic objectForKey:@"store_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *para = [NSString stringWithFormat:@"pagenumber=%d&pagesize=%d&store_id=%@",_currentPage,kPageSize,store_id];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=fruitlistmore"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic){
        NSLog(@"akckakadkahk%@",dataDic);
        _isLoading = NO;
        NSNumber *code = [dataDic objectForKey:@"code"];
        int numCode = [code intValue];//请求数据成功代码号
        if (numCode==200) {
            
            NSNumber *totalCount = [dataDic objectForKey:@"count"];
            
            int remainder = totalCount.intValue % kPageSize;
            if (remainder > 0) {
                _totalPage = totalCount.intValue/kPageSize + 1;
            } else {
                _totalPage = totalCount.intValue/kPageSize;
            }
            for (NSDictionary *dic in [dataDic objectForKey:@"datas"]) {
                
                HomeGoodsItem *item = [[HomeGoodsItem alloc] initWithDic:dic];
                [subviewDataArray addObject:item];
            }
            NSString *haveMore = [dataDic objectForKey:@"haveMore"];
            if ([haveMore isEqualToString:@"true"]) {
                [self loadMoreHandleInView:_bottomView];
            } else{
                [self loadMoreHasDoneHandleInView:_bottomView];
            }
            
            [_tableView reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    };
    
    request.failureRequest = ^(NSError *error){
        _isLoading = NO;
        _hasLoad = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    };
    
    
    
}
-(void)loadMoreHandleInView:(UIView *)view
{
    if (_totalPage > 1) {
        [view removeAllSubviews];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 1, kScreen_width, 0.5)];
        line.backgroundColor = kDividColor;
        [_bottomView addSubview:line];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(0, 0, 25, 25);
        activityView.center = CGPointMake(view.width/2, view.height/2);
        [view addSubview:activityView];
        [activityView startAnimating];
        _tableView.tableFooterView = _bottomView;
    }
}

-(void)loadMoreHasDoneHandleInView:(UIView *)view
{
    [view removeAllSubviews];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = @"暂无更多数据";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:kFontSize_3];
    label.textColor = kDividColor;
    [view addSubview:label];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 1, kScreen_width, 0.5)];
    line.backgroundColor = kDividColor;
    [_bottomView addSubview:line];
    _tableView.tableFooterView = _bottomView;
    
}

#define kLeftImageV_width 20
-(void)loadData{
   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"加载中...";
    tableHeadArray = [[NSMutableArray alloc] init];
    tableRowData = [[NSMutableArray alloc] init];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSDictionary *storeID_Dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeID_Dic objectForKey:@"store_id"];
    NSString *para = [NSString stringWithFormat:@"store_id=%@",store_id];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=maincategory"] postData:para];
    __weak GoodsCategoryViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *dataDic){
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSNumber *codeNum = [dataDic objectForKey:@"code"];

        int code = [codeNum intValue];
        if (code==200) {
            
            for (NSDictionary *tableDic in [dataDic objectForKey:@"datas"]) {
                NSArray *subClassArr = [tableDic objectForKey:@"subclass"];
                if (subClassArr.count>0) {
                    goodsClassify *model = [[goodsClassify alloc] initWithDic:tableDic];
                        [tableHeadArray addObject:model];
                        dicArray = [[NSMutableArray alloc] init];
                        for (NSDictionary *rowData in [tableDic objectForKey:@"subclass"]) {
                            goodsClassify *rowModel = [[goodsClassify alloc] initWithDic:rowData];
                            [dicArray addObject:rowModel];
                        }
                        [tableRowData addObject:dicArray];
                }
            }
                collectionData = [[NSMutableArray alloc] init];
                [_categoryTableView reloadData];
            if (tableRowData.count>0) {
                
                NSMutableArray *data = [tableRowData firstObject];
                if (data.count>0) {
                    if (!_marketHomeMore) {
                        NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
                        [_categoryTableView selectRowAtIndexPath:first
                                                        animated:YES
                                                  scrollPosition:UITableViewScrollPositionTop];
                        _indexPath = first;
                        
                    }else{
                        [_categoryTableView selectRowAtIndexPath:_indexPath
                                                        animated:YES
                                                  scrollPosition:UITableViewScrollPositionTop];
                    [_categoryTableView scrollToRowAtIndexPath:_indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    }
                   
                    [weakSelf loadCollectionData];

                }

            }
            
        }else{
            _hasLoad = NO;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        }
    };
    request.failureRequest = ^(NSError *error){
        _hasLoad = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    };


    
}
-(void)loadCollectionData{

    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSDictionary *storeID_Dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeID_Dic objectForKey:@"store_id"];
    if (tableRowData.count>0&&_indexPath) {
        NSMutableArray *dataArray = [tableRowData objectAtIndex:_indexPath.section];
        if (dataArray.count>0) {
            goodsClassify *model = [dataArray objectAtIndex:_indexPath.row];
//            NSLog(@"store_id = %d",model.store_id);

            NSString *urlString = [kHostHttp stringByAppendingString:[NSString stringWithFormat:@"/mobile/api.php?commend=goodslistmore&store_id=%@&class_id=%d&pagenumber=%d&pagesize=%d",store_id,model.class_id,pageNum,10]];
            __weak GoodsCategoryViewController *weakSelf = self;
            [request requestForGETWithUrl:urlString];
            request.successRequest = ^(NSDictionary *dataDic){
//                NSLog(@"sajasdajg%@",dataDic);
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                [MBProgressHUD hideAllHUDsForView:_contentCollectionView animated:YES];
                _collection_First = NO;
                NSNumber *codeNum = [dataDic objectForKey:@"code"];
                int code = [codeNum intValue];
                if (code==200){
                    NSString *totalCount = [dataDic objectForKey:@"count"];
//                    totalNum = count.intValue/10 +1;
                    int remainder = totalCount.intValue % 10;
                    if (remainder > 0) {
                        totalNum = totalCount.intValue/10 + 1;
                    } else {
                        totalNum = totalCount.intValue/10;
                    }
                    NSLog(@"dakdadakas%d",totalNum);
                    if (_indexPath!=_oldIndexPath) {
                        if (collectionData.count>0) {
                            [collectionData removeAllObjects];
                        }
                        _oldIndexPath = _indexPath ;
                    }
                    if (!_table_Click) {
                        
                        if (collectionData.count>0) {
                            [collectionData removeAllObjects];
                        }
                    }
                    for (NSDictionary *tableDic in [dataDic objectForKey:@"datas"]) {
                        goodsClassify *model = [[goodsClassify alloc] initWithDic:tableDic];
                        [collectionData addObject:model];

                    }
                    if (collectionData.count<10) {
                        
                        _isLoadAll = YES;
                    }
                    if (collectionData.count==0) {
                        
                    [YanMethodManager emptyDataInView:_contentCollectionView title:@"暂无此分类商品"];

                    }else{
                    
                        [YanMethodManager removeEmptyViewOnView:_contentCollectionView];

                    }
                    [_contentCollectionView reloadData];
                    if (_footer_Refresh) {
                        _contentCollectionView.contentOffset = CGPointMake(0, _contentCollectionView.contentOffset.y+40);
                        _footer_Refresh = NO;
                    }
                }else{
                    _footer_Refresh=NO;
                }
//                [YanMethodManager hideIndicatorFromView:_contentCollectionView];


            };
            request.failureRequest = ^(NSError *error){
                NSLog(@"dakdkahkdhk%@",error);
                _footer_Refresh = NO;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD hideAllHUDsForView:_contentCollectionView animated:YES];

//                [YanMethodManager hideIndicatorFromView:_contentCollectionView];
            };
            
        }
    }
}

-(void)categoryNaviItemHandle
{
    self.navigationController.navigationBar.barTintColor = kRedColor;
    UILabel *searchL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_width-150, 30)];
    searchL.backgroundColor = kColorWithRGB(46, 156, 96);
    searchL.text = @"  请输入商品关键字";
    searchL.textColor = kDividColor;
    searchL.font = [UIFont systemFontOfSize:kFontSize_2];
//    searchL.layer.borderColor = kDividColor.CGColor;
//    searchL.layer.borderWidth = 1;
    searchL.layer.cornerRadius = 5;
    searchL.clipsToBounds = YES;
    searchL.userInteractionEnabled = YES;
    self.navigationItem.titleView = searchL;
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    searchBtn.frame = searchL.bounds;
    [searchBtn addTarget:self action:@selector(searchCategoryAction) forControlEvents:UIControlEventTouchUpInside];
    [searchL addSubview:searchBtn];
    
    CGFloat leftWidth = _isPush ? 100 : 80;
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, leftWidth, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    
    CGFloat leftImgVWidth = _isPush ? kLeftImageV_width : 0;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, leftImgVWidth, view.height)];
    imageV.backgroundColor = KRandomColor;
    imageV.userInteractionEnabled = YES;
    [view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageV.right, 0, view.width-imageV.width, view.height)];
    label.text = @"商品分类";
    label.font = [UIFont systemFontOfSize:kFontSize_1];
    label.textColor = [UIColor whiteColor];
    label.userInteractionEnabled = YES;
    [view addSubview:label];
    
    if (_isPush) {
        UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        popBtn.frame = view.bounds;
        [popBtn addTarget:self action:@selector(goodsCategoryPop) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:popBtn];
    }
}

-(void)searchCategoryAction
{
    SearchResultViewController *resultVC = [[SearchResultViewController alloc] init];
    [self.navigationController pushViewController:resultVC animated:YES];
}

-(void)loginPayRightNow:(HomeGoodsItem *)goodsModel withCount:(NSString *)count{
    NSDictionary *marketDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *marketName = [marketDic objectForKey:@"store_name"];
    PayRightNowViewController *payVC = [[PayRightNowViewController alloc] init];
    payVC.goods_name = goodsModel.goods_name;
    payVC.market_name = marketName;
    payVC.price = [NSString stringWithFormat:@"%.1f",goodsModel.goods_price];
    payVC.count = count;
    payVC.goods_id = goodsModel.goods_id;
    payVC.store_id = goodsModel.store_id;
    [self.navigationController pushViewController:payVC animated:YES];
}
-(void)isLoginHandle:(void(^)(void))loginSuccess hasLogin:(void(^)(void))hasLoginHandle
{
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (member_id == NULL) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.isPresent = YES;
        loginVC.loginSuccessBlock = ^{
            loginSuccess();
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.tabBarController presentViewController:nav animated:YES completion:nil];
    } else {
        hasLoginHandle();
    }
}




#define kShopCart_width 30

#define kBadgeView_width 25

-(void)login{

    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.isPresent = YES;
    __weak GoodsCategoryViewController *weakSelf = self;
    loginVC.dismissBlock = ^{
        weakSelf.tabBarController.selectedIndex = 1;
    };
    loginVC.loginSuccessBlock = ^{
//        [self loadData];
    };
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.tabBarController presentViewController:navi animated:NO completion:nil];
}
-(void)gotoCart
{
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (mobile!=NULL) {
        CartViewController *cartVC = [[CartViewController alloc] init];
        cartVC.isPush = YES;
        [self.navigationController pushViewController:cartVC animated:YES];
    }
    else
    {
        [self login];
    }
}


-(void)goodsCategoryPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#define kCategoryTV_width 90
#define kCollectionHeader_height 40

-(void)addTableViewsOnGoodsCategoryView
{
    if (!_marketHomeMore) {
        _categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kCategoryTV_width, kScreen_height-64-49) style:UITableViewStylePlain];

    }else{
        _categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kCategoryTV_width, kScreen_height-64) style:UITableViewStylePlain];
    
    }
    _categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _categoryTableView.dataSource = self;
    _categoryTableView.delegate = self;
    if (!_marketHomeMore) {
        close[0] = YES;

    }else{
        close[_indexPath.section] = YES;
    
    }
    [self.view addSubview:_categoryTableView];
    _categoryTableView.showsHorizontalScrollIndicator =NO;
    _categoryTableView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    if (!_marketHomeMore) {
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_categoryTableView.right, 64, kScreen_width-_categoryTableView.width, kScreen_height-64-49) collectionViewLayout:layout];
        
    }else{
    _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_categoryTableView.right, 64, kScreen_width-_categoryTableView.width, kScreen_height-64) collectionViewLayout:layout];
    }
    layout.headerReferenceSize = CGSizeMake(_contentCollectionView.width, kCollectionHeader_height);
    layout.footerReferenceSize = CGSizeMake(_contentCollectionView.width, 40);
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    [_contentCollectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:@"content"];
    [_contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    _contentCollectionView.dataSource = self;
    _contentCollectionView.delegate = self;
    
    [self.view addSubview:_contentCollectionView];

//    [YanMethodManager lineViewWithFrame:CGRectMake(90, 64, 0.5, _contentCollectionView.height) superView:self.view];
//    
}

#pragma mark UICollectionview
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    _contentCollectionView.footer.hidden = NO;
    return collectionData.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contentID = @"content";
    ContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contentID forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    goodsClassify *model = [collectionData objectAtIndex:indexPath.row];
    cell.goodsModel = model;
    __weak GoodsCategoryViewController *weakSelf = self;
    cell.tapCartBlock = ^(UITapGestureRecognizer *tap){
        ContentCollectionViewCell *newCell = (ContentCollectionViewCell *)[_contentCollectionView cellForItemAtIndexPath:indexPath];
        if (!_marketHomeMore) {
            [weakSelf addGoodsIntoCartWithGesture:tap indexPath:indexPath];
        }
    
        if (newCell.selectCountView.countLabel.text.integerValue > 0) {
            NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
            if (mobile!=NULL) {
                NetWorkRequest *request = [[NetWorkRequest alloc]init];
                //            NSString *mobile = [NSUserDefaults ]
                NSString *para = [NSString stringWithFormat:@"goods_id=%d&quantity=%d&member_id=%@",model.goods_id,newCell.selectCountView.countLabel.text.intValue,mobile];
                [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:para];
                request.successRequest = ^(NSDictionary *dataDic)
                {
                    NSNumber *codeNum = [dataDic objectForKey:@"code"];
                    int code = [codeNum intValue];
                    if (code == 200) {
                        NSNumber *count = [dataDic objectForKey:@"count"];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",count.integerValue] forKey:@"local_cartGoodsCount"];
                        for (UINavigationController *navi in self.tabBarController.viewControllers) {
                            if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                                navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",count.integerValue];
                            }
                        }
                        if (_marketHomeMore) {
                            [weakSelf.view makeToast:@"加入购物车成功" duration:1 position:@"center"];

                        }

                        
                    }else if(code == 203){
                    
                        [weakSelf.view makeToast:@"购物车已满，请删除部分商品后重新加入" duration:1 position:@"center"];
                    
                    }else
                    {
                        [weakSelf.view makeToast:@"加入购物车失败" duration:1 position:@"center"];
                    }
                };
                request.failureRequest = ^(NSError *error){
                    [weakSelf.view makeToast:@"加入购物车失败" duration:.8 position:@"center"];
                };
            }else{
                [self login];
            }
        }
        else {
            [self.view makeToast:@"请选择购买数量" duration:1 position:@"center"];
        }
    };
    return cell;

}

#define kLine_count 2

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreen_width-90)/kLine_count, (kScreen_width-90)/kLine_count+25);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        [self addHeaderOnCollectionView:view];
        return view;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        if (_collection_First) {
            return footView;
        }else{
        if (_isLoadAll) {
            [footView removeAllSubviews];
            CGFloat height = 40;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _contentCollectionView.width, height)];
            label.text = @"暂无更多数据";
            label.textColor = kDividColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:kFontSize_3];
            [footView addSubview:label];
        } else {
            [footView removeAllSubviews];
            UIActivityIndicatorView *activityV = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            activityV.center = CGPointMake(footView.width/2, footView.height/2);
            activityV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [activityV startAnimating];
            [footView addSubview:activityV];
        }
        
        return footView;
        }
    }
    return nil;
}

-(void)addHeaderOnCollectionView:(UICollectionReusableView *)view
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentCollectionView.width, kCollectionHeader_height)];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _contentCollectionView.width, kCollectionHeader_height-40)];
    [headerView addSubview:scrollView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height)];
    imageView.image = [UIImage imageNamed:@"test.jpg"];
    [scrollView addSubview:imageView];
    headerView.backgroundColor = [UIColor whiteColor];
    [view addSubview:headerView];
    _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, scrollView.bottom, 300, headerView.height)];
    _categoryLabel.text = @"";
    _categoryLabel.textColor =kBlack_Color_2;

    if (_indexPath!=nil&&tableRowData.count!=0) {
        NSMutableArray *modelArray = [tableRowData objectAtIndex:_indexPath.section];
        goodsClassify *model = [modelArray objectAtIndex:_indexPath.row];
        if (model.class_name) {
            _categoryLabel.text = model.class_name;
            [YanMethodManager lineViewWithFrame:CGRectMake(0, view.height, view.width, 0.5) superView:view];

        }

    }

    _categoryLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [headerView addSubview:_categoryLabel];
    
//    UIImageView *dotIamgeV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 10, 10)];
//    dotIamgeV.backgroundColor = kRed_PriceColor;
//    dotIamgeV.layer.cornerRadius = 10/2;
//    dotIamgeV.centerY = _categoryLabel.centerY;
//    [headerView addSubview:dotIamgeV];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    goodsClassify *model = [collectionData objectAtIndex:indexPath.row];
    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
    detailVC.goods_id = model.goods_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!_isOtherType) {
        if (self.contentCollectionView.contentSize.height-_contentCollectionView.contentOffset.y <= _contentCollectionView.height) {
            if (!_footer_Refresh) {
                if (pageNum<totalNum) {
                    _footer_Refresh = YES;
                    ++pageNum;
                    _table_Click = YES;
                    [self loadCollectionData];
                }else{
                    
                    _isLoadAll = YES;
                    [_contentCollectionView reloadData];
                }
            }
        }
    }else{
        if (_tableView.contentSize.height-_tableView.contentOffset.y <= _tableView.height){
            if (_currentPage < _totalPage) {
                if (!_isLoading) {
                    _isLoading = YES;
                    ++_currentPage;
                    [self loadSubviewData];
                }
            }
            
        }

    
    }
   
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isOtherType) {
        return 1;
    }else{
    return tableHeadArray.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (_isOtherType) {
        return subviewDataArray.count;
    }else{
        NSMutableArray *dataDic = [tableRowData objectAtIndex:section];
        BOOL cls = close[section];
        if (!cls) {
            
            return 0;
        }
        return dataDic.count;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isOtherType) {
        static NSString *cateid = @"category";
        GoodsSecondClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cateid];
        if (!cell) {
            
            cell = [[GoodsSecondClassifyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cateid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_indexPath == indexPath) {
            cell.isSelected = YES;
        }else{
            
            cell.isSelected = NO;
        }
        NSMutableArray *dataArray = [tableRowData objectAtIndex:indexPath.section];
        goodsClassify *goodsModel = [dataArray objectAtIndex:indexPath.row];
        cell.titleString = goodsModel.class_name;
        return cell;

    }else{
    
        static NSString *identify = @"fruitCell";
        FruitHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[FruitHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        HomeGoodsItem *model = [subviewDataArray objectAtIndex:indexPath.row];
        cell.goodsItem = model;
        __weak FruitHomeTableViewCell *newCell = cell;
        __weak GoodsCategoryViewController *weakSelf = self;
        cell.fruitActionBlock = ^(UITapGestureRecognizer *tap){
            [YanMethodManager showIndicatorOnView:weakSelf.view];
            _tapPoint = [tap locationInView:self.view];
            
            NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
            //加入购物车判断所选商品数量是否大于0
            if (newCell.selectCountView.countLabel.text.integerValue > 0) {
                //加入购物车判断是否登录状态
                if (member_id!=NULL) {
                    
                    [weakSelf fruitAddIntoCartWithItem:model cell:newCell tap:tap];
                }else{
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    loginVC.isPresent = YES;
                    __weak GoodsCategoryViewController *weakSelf = self;
                    loginVC.dismissBlock = ^{
                        [YanMethodManager hideIndicatorFromView:weakSelf.view];
                        weakSelf.tabBarController.selectedIndex = 1;
                    };
                    loginVC.loginSuccessBlock = ^{
                        [weakSelf fruitAddIntoCartWithItem:model cell:newCell tap:tap];
                    };
                    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    [self.tabBarController presentViewController:navi animated:NO completion:nil];            }
            }
            else {
                [self.view makeToast:@"请选择购买数量" duration:1 position:@"center"];
            }
        };
        return cell;
        
    }
}
-(void)fruitAddIntoCartWithItem:(HomeGoodsItem *)item cell:(FruitHomeTableViewCell *)cell tap:(UITapGestureRecognizer *)tap
{
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"goods_id=%d&quantity=%d&member_id=%@",item.goods_id,cell.selectCountView.countLabel.text.intValue,member_id];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:para];
    __weak GoodsCategoryViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *dataDic)
    {
        [YanMethodManager hideIndicatorFromView:self.view];
        NSNumber *codeNum = [dataDic objectForKey:@"code"];
        int code = [codeNum intValue];
        if (code == 200) {
            NSNumber *count = [dataDic objectForKey:@"count"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)count.integerValue] forKey:@"local_cartGoodsCount"];
            for (UINavigationController *navi in self.tabBarController.viewControllers) {
                if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                    navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count.integerValue];
                }
            }
            //            [weakSelf.view makeToast:@"已加入购物车" duration:1 position:@"center"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf addGoodsIntoCartWithGesture:tap];
            });
            
            
        }else if(code == 203){
            
            [weakSelf.view makeToast:@"购物车已满，请删除部分商品后重新加入" duration:1 position:@"center"];
            
        }else
        {
            [weakSelf.view makeToast:@"加入购物车失败" duration:1 position:@"center"];
        }
    };
    request.failureRequest = ^(NSError *error){
        [weakSelf.view makeToast:@"加入购物车失败" duration:.8 position:@"center"];
    };
}
//将商品放入购物车动画效果
-(void)addGoodsIntoCartWithGesture:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_tapPoint.x, _tapPoint.y, 25, 25)];
    imageView.image = [UIImage imageNamed:@"fruit_cart"];
    [self.view addSubview:imageView];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _tapPoint.x, _tapPoint.y);
    CGPathAddLineToPoint(path, NULL, kScreen_width/4*3-25, kScreen_height-20);
    pathAnimation.path = path;
    [imageView.layer addAnimation:pathAnimation forKey:@"position"];
    
    CABasicAnimation *basiAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basiAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    basiAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [imageView.layer addAnimation:basiAnimation forKey:@"transform.scale"];
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:0.5];
    group.animations = @[pathAnimation, basiAnimation];
    [imageView.layer addAnimation:group forKey:@"group"];
    CGPathRelease(path);
    [self performSelector:@selector(removeImageView:) withObject:imageView afterDelay:0.45];
}
-(void)removeImageView:(UIImageView *)imageView
{
    [imageView removeFromSuperview];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!_isOtherType) {
        goodsClassify *model = [tableHeadArray objectAtIndex:section];
        
        TableHeadView *view = [[TableHeadView alloc] initWithFrame:CGRectMake(0, 0, _categoryTableView.width, 50)withImageName:model.class_image];
        view.title = model.class_name;
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = section+500;
        [view addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (section ==_categorySelectRow) {
            
            view.isSelected = YES;
        }else{
            
            view.isSelected = NO;
            
        }
        
        if (section==tableHeadArray.count -1) {
            view.bottomLine.hidden = YES;
        }
        
        return view;
        
    }else{
    
        return nil;
    
    }
    
}
- (void)buttonAction:(UIButton *)btn
{
    //刷新tableVIew
    NSInteger section = btn.tag -500;
//    close[section] = !close[section];

    for (int i =0; i<tableHeadArray.count; i++) {
        
        if (i==section) {
            
            close[i] =!close[i];
        }else{
        
            close[i] = NO;
        }
    }
    _categorySelectRow = section;
    [_categoryTableView reloadData];
    NSArray *array =[tableRowData objectAtIndex:section];
    if (array.count>0&&close[section]==YES) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section];
        [_categoryTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    if (btn.tag-500 ==_indexPath.section && close[section] == YES) {
        [_categoryTableView selectRowAtIndexPath:_indexPath
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!_isOtherType) {
        return 50;
    }else{
       return 0;
    
    }
}
//将商品放入购物车动画效果
-(void)addGoodsIntoCartWithGesture:(UITapGestureRecognizer *)tap indexPath:(NSIndexPath *)indexPath
{
    ContentCollectionViewCell *cell = (ContentCollectionViewCell *)[_contentCollectionView cellForItemAtIndexPath:indexPath];
    if (cell.selectCountView.countLabel.text.integerValue > 0) {
        CGPoint tapPoint = [tap locationInView:self.view];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        imageView.center = CGPointMake(tapPoint.x-100, tapPoint.y+100);
        imageView.image = kHolderImage;
        [self.view addSubview:imageView];
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, tapPoint.x, tapPoint.y);
        CGPathAddLineToPoint(path, NULL, kScreen_width/4*3-25, kScreen_height-40);
        pathAnimation.path = path;
        [imageView.layer addAnimation:pathAnimation forKey:@"position"];
        
        CABasicAnimation *basiAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        basiAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        basiAnimation.toValue = [NSNumber numberWithFloat:0.0];
        [imageView.layer addAnimation:basiAnimation forKey:@"transform.scale"];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setDuration:0.5];
        group.animations = @[pathAnimation, basiAnimation];
        [imageView.layer addAnimation:group forKey:@"group"];
        CGPathRelease(path);
//        NSInteger cartCount = _badgeView.badgeText.integerValue;
//        cartCount += cell.selectCountView.countLabel.text.integerValue;
//        _badgeView.badgeText = [NSString stringWithFormat:@"%ld",(long)cartCount];
        
        [self performSelector:@selector(removeImageView:) withObject:imageView afterDelay:0.45];
    } else {
        [self.view makeToast:@"请选择购买数量" duration:1.5 position:@"center"];
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isOtherType) {
        pageNum = 1;
        _isLoadAll = NO;
        _indexPath = indexPath;
        _contentCollectionView.contentOffset = CGPointMake(0, 0);
        _categorySelectRow = indexPath.section;
        [_categoryTableView reloadData];
        [_categoryTableView selectRowAtIndexPath:_indexPath
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];
        _table_Click = NO;
        [MBProgressHUD showHUDAddedTo:_contentCollectionView animated:YES];
        
        [self loadCollectionData];

    }else{
        if (!_marketIsLogin) {
            _marketIsLogin  = YES;
            [self systemIsOpenHandleFruitIndext:indexPath tableView:tableView];
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

   }

//立即购买前先判断超市系统状态
-(void)systemIsOpenHandleFruitIndext:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    [YanMethodManager showIndicatorOnView:self.view];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeDic objectForKey:@"store_id"];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=isopenstore"] postData:[NSString stringWithFormat:@"store_id=%@",store_id]];
    __weak GoodsCategoryViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *packageDic){
        _marketIsLogin = NO;
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
        NSLog(@"===== package dic = %@",packageDic);
        NSNumber *code = [packageDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSNumber *isOpen = [packageDic objectForKey:@"isopen"];
            if (isOpen.integerValue == 1) {
                HomeGoodsItem *dataModel = [subviewDataArray objectAtIndex:indexPath.row];
                FruitHomeTableViewCell *cell = (FruitHomeTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
                NSString *count = cell.selectCountView.countLabel.text;
                [weakSelf isLoginHandle:^{
                    [weakSelf loginPayRightNow:dataModel withCount:count];
                } hasLogin:^{
                    [weakSelf loginPayRightNow:dataModel withCount:count];
                }];
                
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲!店家已打烊,若有急需请电联" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"打电话", nil];
                [alert show];
            }
        }
    };
    request.failureRequest = ^(NSError *error){
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
        _marketIsLogin = NO;
    };
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex ==1) {
        NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
        NSString *telNum = [storeDic objectForKey:@"telephone"];
        
        [[YanMethodManager defaultManager] callPhoneActionWithNum:telNum viewController:self];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isOtherType) {
        return 120;
    }else{
        return 44;
    }
}

//分割线顶到头
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBarHidden = NO;
    
    if (!_isOtherType) {
        if (_hasLoad == NO) {
            _hasLoad = YES;
            [self loadData];
            
        }

    }else{
    
        if (_hasLoad == NO) {
            _hasLoad = YES;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self loadSubviewData];
            
        }    
    }
    if (_marketHomeMore) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.tabBarController.tabBar.hidden = YES;
        self.navigationController.navigationBarHidden = NO;
    } else {
        self.tabBarController.tabBar.hidden = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [TalkingData trackPageBegin:@"商品分类页面"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    if (_marketHomeMore) {
        self.tabBarController.tabBar.hidden = NO;
    }
    [TalkingData trackPageEnd:@"商品分类页面"];

}

-(void)marketHomePop{

    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //    if ([self isRootViewController]) {
    //        return NO;
    //    } else {
    //        return YES;
    //    }
    if (_isPush) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearDisk];
}


@end
