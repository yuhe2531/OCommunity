//
//  MyGoodsCommentsViewController.m
//  OCommunity
//
//  Created by runkun2 on 15/6/22.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MyGoodsCommentsViewController.h"
#import "GoodsCommentsTableViewCell.h"
#import "CommentsModel.h"
#define kPagesize 10
@interface MyGoodsCommentsViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIView *bottomView;
@property(nonatomic,assign)BOOL isDelete;
@end

@implementation MyGoodsCommentsViewController{
    UITableView *_tableView;
    NSMutableArray *dataCommentsArray;
    
    int _currentPage;
    int _totalPage;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"我的评价"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(mineVC)];
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0, 0, 20, 20);
    [clearButton setBackgroundImage:[UIImage imageNamed:@"del_garbage"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    self.navigationItem.rightBarButtonItem = clearItem;
    dataCommentsArray = [[NSMutableArray alloc] init];
    _currentPage = 1;
    [self loadSubViews];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadCommentsRequest];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBarHidden = NO;
}

-(void)clearAction{
    
    if (dataCommentsArray.count == 0) {
        [self.view makeToast:@"评价列表为空" duration:.5 position:@"center"];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否全部删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        
        NetWorkRequest *request = [[NetWorkRequest alloc]init];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        NSString *para = [NSString stringWithFormat:@"member_id=%@",memberId];
            NSLog(@"删除全部商品评价");
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=alldelmycomment"] postData:para];
            request.successRequest = ^(NSDictionary *dataDic){
                NSLog(@"+++++++++=======%@",dataDic);
                NSNumber *code = [dataDic objectForKey:@"code"];
                int numCode = [code intValue];//请求数据成功代码号
                if (numCode==200) {
                    
                    [dataCommentsArray removeAllObjects];
                    [_tableView reloadData];
                    if (dataCommentsArray.count == 0) {
                        [YanMethodManager emptyDataInView:_tableView title:@"评价列表为空"];
                    }
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
            };
            request.failureRequest = ^(NSError *error){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            };
            
            
    }
    
    
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
    
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *para =[NSString stringWithFormat:@"member_id=%@&pagenumber=%d&pagesize=%d",member_id,_currentPage,kPagesize];
    [request requestForPOSTWithUrl:[kHostHttp
    stringByAppendingString:@"mobile/api.php?commend=mycommentlist"] postData:para];
    request.successRequest = ^(NSDictionary *requestDic)
    {
        NSLog(@"pinglun%@",requestDic);
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
            if (datasArr.count ==0) {
                
                [YanMethodManager emptyDataInView:_tableView title:@"评价列表为空"];

            }else{
            
                for (int i = 0; i < datasArr.count; i++) {
                    NSDictionary *itemDic = datasArr[i];
                    CommentsModel *item = [[CommentsModel alloc] initWithDic:itemDic];
                    [dataCommentsArray addObject:item];
                }

                NSString *haveMore = [requestDic objectForKey:@"haveMore"];
                if ([haveMore isEqualToString:@"true"]) {
                    [self loadMoreHandleInView:_bottomView];
                } else {
                    [self loadMoreHasDoneHandleInView:_bottomView];
                }
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
    cell.myComments = dataComments;
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
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除评价列表
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_isDelete == NO) {
            [YanMethodManager showIndicatorOnView:self.view];
            _isDelete = YES;
            NetWorkRequest *request = [[NetWorkRequest alloc]init];
            CommentsModel *model = [dataCommentsArray objectAtIndex:indexPath.row];
            NSString *para = [NSString stringWithFormat:@"order_sn=%@",model.order_sn];
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=delmycomment"] postData:para];
            request.successRequest = ^(NSDictionary *dataDic)
            {
                [YanMethodManager hideIndicatorFromView:self.view];
                NSString *code = [dataDic objectForKey:@"code"];
                if (code.intValue==200) {
                    [dataCommentsArray removeObjectAtIndex:indexPath.row];
                    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                    [_tableView reloadData];
                    _isDelete = NO;
                    if (dataCommentsArray.count == 0) {
                        [YanMethodManager emptyDataInView:self.view title:@"评论列表为空"];
                    }
                    
                }else{
                    _isDelete = NO;
                
                }
            };
            request.failureRequest = ^(NSError *error){
                _isDelete = NO;
                [YanMethodManager hideIndicatorFromView:self.view];

            
            };
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"删除";
}

//滚动到最后一行自动刷新数据
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if (_tableView.contentSize.height-_tableView.contentOffset.y-10 <= _tableView.height) {
        if (_currentPage < _totalPage) {
            NSLog(@"asddjadjhajhgd%d",_totalPage);
            if (!_isLoading) {
                _isLoading = YES;
                ++_currentPage;
                [self loadCommentsRequest];
                
            }
        }
    }
}


-(void)mineVC{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
