//
//  GoodsCommentsViewController.m
//  OCommunity
//
//  Created by runkun2 on 15/6/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "GoodsCommentsViewController.h"
#import "GoodsCommentsTableViewCell.h"
#import "CommentsModel.h"
#define kPagesize 10
@interface GoodsCommentsViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation GoodsCommentsViewController{
    UITableView *_tableView;
    NSMutableArray *dataCommentsArray;

    int _currentPage;
    int _totalPage;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:kBackgroundColor];
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"评价"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(goodsDetail)];
    dataCommentsArray = [[NSMutableArray alloc] init];
    _currentPage = 1;
    [self loadSubViews];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadCommentsRequest];

}
-(void)loadSubViews{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 40)];
    _tableView.tableFooterView = _bottomView;
    [self.view addSubview:_tableView];

}
-(void)loadCommentsRequest{
    
  
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *para =[NSString stringWithFormat:@"goods_id=%d&pagenumber=%d&pagesize=%d",_goods_id,_currentPage,kPagesize];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=commentlist"] postData:para];
    __weak GoodsCommentsViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *requestDic)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSNumber *code = [requestDic objectForKey:@"code"];
            if (code.intValue == 200) {
                NSNumber *totalCount = [requestDic objectForKey:@"count"];
                int remainder = totalCount.intValue % kPagesize;
                if (remainder > 0) {
                    _totalPage = totalCount.intValue/kPagesize + 1;
                } else {
                    _totalPage = totalCount.intValue/kPagesize;
                }
                NSArray *datasArr = [requestDic objectForKey:@"datas"];
                for (int i = 0; i < datasArr.count; i++) {
                    NSDictionary *itemDic = datasArr[i];
                    CommentsModel *item = [[CommentsModel alloc] initWithDic:itemDic];
                    [dataCommentsArray addObject:item];
            }
                
                NSString *haveMore = [requestDic objectForKey:@"haveMore"];
                if ([haveMore isEqualToString:@"true"]) {
                    [weakSelf loadMoreHandleInView:_bottomView];
                } else {
                    [weakSelf loadMoreHasDoneHandleInView:_bottomView];
                }
                if (_isLoading) {
                    
                _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y+30);
                }
                _isLoading = NO;

                [_tableView reloadData];
            }
//
    
    };
    request.failureRequest = ^(NSError *error){
        _isLoading = NO;
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        

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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return dataCommentsArray.count;


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *goodsComment = @"GoodsComment";
    GoodsCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsComment];
    if (!cell) {
        
        cell = [[GoodsCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:goodsComment];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CommentsModel *dataComments = [dataCommentsArray objectAtIndex:indexPath.row];
    cell.commentsData = dataComments;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsModel *commentModel = [dataCommentsArray objectAtIndex:indexPath.row];
    if (!commentModel.rowHeight) {
     CGFloat rowHeight = [[YanMethodManager defaultManager] titleLabelHeightByText:commentModel.comment width:kScreen_width -40 font:kFontSize_3];
        commentModel.rowHeight = rowHeight;
    }
    return commentModel.rowHeight + 85;

}
//滚动到最后一行自动刷新数据
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_tableView.contentSize.height-_tableView.contentOffset.y <= _tableView.height) {
        if (_currentPage < _totalPage) {
            if (!_isLoading) {
                _isLoading = YES;
                ++_currentPage;
                [self loadCommentsRequest];
               
            }
        }
    }
}


-(void)goodsDetail{

    [self.navigationController popViewControllerAnimated:YES];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = YES;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
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
