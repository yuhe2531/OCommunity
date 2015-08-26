//
//  GoodsDetailViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "MineListTableViewCell.h"
#import "DetailFirstTableViewCell.h"
#import "MineCommenTableViewCell.h"
#import "SelectCountView.h"
#import "CartViewController.h"
#import "PayRightNowViewController.h"
#import "CreditAndSendView.h"
#import "WarnView.h"
#import "MatchView.h"
#import "HomeGoodsItem.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "CommentsModel.h"
#import "GoodsCommentsTableViewCell.h"
#import "GoodsCommentsViewController.h"
#import "JSBadgeView.h"

#define kNameLabel_left 15
#define kBetween_margin 10

#define kPresentPL_width 65
#define kPresentPL_height 20

#define kAddCartBtn_width 90

#define kCart_width 30

#define kMatchView_height 200

#define kCreditView_height 30


@interface GoodsDetailViewController ()<UIGestureRecognizerDelegate>

{
    NSInteger goodsCount;
    UIScrollView *scrollView;
    NSMutableArray *likegoodsArr;
    UIButton *detailCartBtn;
    UIImage *topImage;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *goodsNameL;
@property (nonatomic, strong) UILabel *presentPriceL;
@property (nonatomic, strong) UILabel *originPriceL;
@property (nonatomic, strong) SelectCountView *selectCountView;
@property (nonatomic, strong) UIImageView *topImgV;
@property (nonatomic, strong) MatchView *matchView;
@property (nonatomic, copy) NSString *market_name;
@property (nonatomic, strong) CommentsModel *commentItem;
@property (nonatomic, assign) float tjPrice;
@property(nonatomic,assign)BOOL marketIsLogin;
@property (nonatomic, strong) JSBadgeView *badgeView;

@end

@implementation GoodsDetailViewController

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //    if ([self isRootViewController]) {
    //        return NO;
    //    } else {
    //        return YES;
    //    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    goodsCount = 1;
    [self goodsDetailSubviews];
    [self goodDetailRequest];
    // Do any additional setup after loading the view.
}

-(void)goodDetailRequest{
    
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    NSString *para = [NSString stringWithFormat:@"goods_id=%d",_goods_id];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=goodsdetail"] postData:para];
    __weak GoodsDetailViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *dataDic){
        NSLog(@"========== detail dic = %@",dataDic);
        //收藏按钮动画执行
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton *collectionBtn = (UIButton *)[self.view viewWithTag:333];
            [UIView animateWithDuration:1.5 animations:^{
                collectionBtn.transform = CGAffineTransformRotate(collectionBtn.transform, M_PI);
            }];
        });
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSNumber *code = [dataDic objectForKey:@"code"];
        int loginCode = [code intValue];
        if (loginCode==200){
            NSDictionary *dataDictory = [dataDic objectForKey:@"datas"];
            NSNumber *tjNum = [dataDictory objectForKey:@"tjprice"];
            _tjPrice = tjNum.floatValue;
            _market_name = [dataDictory objectForKey:@"store_name"];
            _goods_id = ((NSNumber *)[dataDictory objectForKey:@"goods_id"]).intValue;
            _goods_name = [dataDictory objectForKey:@"goods_name"];
            _goods_pic = [dataDictory objectForKey:@"goods_pic"];
            _goods_price = [NSString stringWithFormat:@"%@",[dataDictory objectForKey:@"goods_price"]];
            _store_id = ((NSNumber *)[dataDictory objectForKey:@"store_id"]).intValue;
            _goodsDetailModel = [[GoodsDetailModel alloc]initWithDic:dataDictory];
            
            _presentPriceL.text = [NSString stringWithFormat:@"￥%.2f",_goodsDetailModel.goods_price];
            
            [_topImgV sd_setImageWithURL:[NSURL URLWithString:_goodsDetailModel.goods_pic] placeholderImage:kHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                topImage = _topImgV.image;
            }];
            
            //评论
            NSArray *goodsComment = [dataDictory objectForKey:@"goodscomment"];
            if (goodsComment.count > 0) {
                NSDictionary *commentDic = goodsComment[0];
                _commentItem = [[CommentsModel alloc] initWithDic:commentDic];
            }
            
            //推荐商品
            NSArray *datasArr = [ dataDictory objectForKey:@"likegoods"];
            //NSLog(@"%@",datasArr)
            likegoodsArr = [NSMutableArray array];
            for (int i = 0; i < datasArr.count; i++) {
                NSDictionary *itemDic = datasArr[i];
                HomeGoodsItem *item = [[HomeGoodsItem alloc] initWithDic:itemDic];
                //NSLog(@"----- item id = %d  == name = %@",item.goods_id, item.goods_name);
                _presentPriceL.text = [NSString stringWithFormat:@"￥%.2f",_goodsDetailModel.goods_price];
                [likegoodsArr addObject:item];
            }
            
            [weakSelf addDetailContentSubviewsWithTitle:_goodsDetailModel.goods_name];
        }
    };
    
    request.failureRequest = ^(NSError *error){
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        //    [self.view makeToast:@"网络异常,请检查网络连接" duration:1.5 position:@"center"];
    };
}

-(void)detailPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#define kTopImgV_height 300

#define kDetailCell_height 40
#define kBottomView_height 49

#define kSelectCountV_Btn_Margin 50
#define kSelectCountV_width 120
#define kBuyRightNowBtn_width 130
#define kBottomSubView_height 30

#define kPopBtn_width 29

#define kCartBtn_width 50

-(void)goodsDetailSubviews
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kScreen_width, kScreen_height-49-20)];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = kBackgroundColor;
    
    //添加购物车实时显示购物车中的商品数量
    UIView *bottomCartView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollView.bottom, kScreen_width, 49)];
    bottomCartView.backgroundColor = kColorWithRGB(57, 56, 62);
    [self.view addSubview:bottomCartView];
    
    UIView *tempCartView = [[UIView alloc] initWithFrame:CGRectMake(35, bottomCartView.top-10, kCartBtn_width, 50)];
    [self.view addSubview:tempCartView];
    
    UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cartBtn.frame = tempCartView.bounds;
    [cartBtn setBackgroundImage:[UIImage imageNamed:@"minecart"] forState:UIControlStateNormal];
    cartBtn.layer.cornerRadius = kCartBtn_width/2;
    cartBtn.clipsToBounds = YES;
    [cartBtn addTarget:self action:@selector(titleBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
    [tempCartView addSubview:cartBtn];
    
    _badgeView = [[JSBadgeView alloc] initWithParentView:tempCartView alignment:JSBadgeViewAlignmentTopRight];
    NSString *badgeCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_cartGoodsCount"];
    if (badgeCount.integerValue > 0) {
        _badgeView.badgeText = badgeCount;
    }
    
    //////////////
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kTopImgV_height)];
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:topView.bounds];
    [topView addSubview:topScrollView];
    _topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kTopImgV_height)];
    _topImgV.backgroundColor = [UIColor whiteColor];
    _topImgV.contentMode = UIViewContentModeScaleAspectFit;
    _topImgV.image = kHolderImage;
    [topScrollView addSubview:_topImgV];
    [scrollView addSubview:topView];
    
    UIView *redLine = [[UIView alloc] initWithFrame:CGRectMake(0, topView.height, kScreen_width, 0.5)];
    redLine.backgroundColor = kRedColor;
    [topView addSubview:redLine];
    
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    popBtn.frame = CGRectMake(20, 35, kPopBtn_width, kPopBtn_width);
//    popBtn.backgroundColor = KRandomColor;
    [popBtn setBackgroundImage:[UIImage imageNamed:@"detail_pop"] forState:UIControlStateNormal];
    popBtn.layer.cornerRadius = kPopBtn_width/2;
    [popBtn addTarget:self action:@selector(detailPop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
    
    //收藏按钮
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    collectionBtn.tag = 333;
    collectionBtn.frame = CGRectMake(kScreen_width-15-29, topView.height-20-29, 29, 29);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0 animations:^{
            collectionBtn.transform = CGAffineTransformRotate(collectionBtn.transform, M_PI);
        }];
    });
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"detail_collection"] forState:UIControlStateNormal];
    collectionBtn.layer.cornerRadius = kPopBtn_width/2;
    collectionBtn.clipsToBounds = YES;
    [collectionBtn addTarget:self action:@selector(collectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:collectionBtn];
    
//    detailCartBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    detailCartBtn.frame = CGRectMake(collectionBtn.right+10, collectionBtn.top, kCart_width, kCart_width);
//    detailCartBtn.tag = 596;
//    [detailCartBtn setBackgroundImage:[UIImage imageNamed:@"list_cart"] forState:UIControlStateNormal];
//    [detailCartBtn addTarget:self action:@selector(titleBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:detailCartBtn];
    
}

-(void)collectionBtnAction:(UIButton *)button
{
    __weak GoodsDetailViewController *weakSelf = self;
   [self isLoginHandle:^{
       [weakSelf didCollectionGoods];
   } hasLogin:^{
       [weakSelf didCollectionGoods];
   }];
 
}

-(void)didCollectionGoods
{
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSNumber *memberID =[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"member_id=%d&goods_id=%d&goods_name=%@&goods_price=%@&goods_pic=%@",[memberID intValue],_goods_id,_goods_name,_goods_price,_goods_pic];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=favorite_goods"] postData:para];
    __weak GoodsDetailViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *dataDic){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"____收藏%@",dataDic);
        NSNumber *code = [dataDic objectForKeyedSubscript:@"code"];
        int collectionCode = [code intValue];
        if (collectionCode==202){
            [weakSelf.view makeToast:@"您已收藏过此产品" duration:1 position:@"center"];
        }else if (collectionCode==203){
            [weakSelf.view makeToast:@"商品收藏已满,请删除部分商品后重新收藏" duration:1 position:@"center"];
        }else if(collectionCode==200){
            [weakSelf.view makeToast:@"收藏成功~" duration:1 position:@"center"];
        }else{
        
            [weakSelf.view makeToast:@"收藏失败~" duration:1 position:@"center"];

        }
    };
    request.failureRequest = ^(NSError *error){
        [weakSelf.view makeToast:@"收藏失败" duration:1.5 position:@"center"];
    };
}

//将商品放入购物车动画效果
-(void)addGoodsIntoCartWithGesture:(UIView *)view
{
    CGPoint tapPoint = CGPointMake(kScreen_width/2, kTopImgV_height/2);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.center = tapPoint;
    imageView.image = topImage;
    [self.view addSubview:imageView];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, tapPoint.x, tapPoint.y-scrollView.contentOffset.y);
    CGPathAddLineToPoint(path, NULL, 35, kScreen_height-50);
    pathAnimation.path = path;
    [imageView.layer addAnimation:pathAnimation forKey:@"position"];
    
    CABasicAnimation *basiAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basiAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    basiAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [imageView.layer addAnimation:basiAnimation forKey:@"transform.scale"];
    
    //    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    //    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    //    [imageView.layer addAnimation:opacityAnimation forKey:@"透明度"];
    
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

-(void)addDetailContentSubviewsWithTitle:(NSString *)title
{
    CGFloat titleWidth = kScreen_width-2*kNameLabel_left;
    CGFloat titleHeight = [[YanMethodManager defaultManager] titleLabelHeightByText:title width:titleWidth font:kFontSize_2];
    UIView *describView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopImgV_height+1, kScreen_width, titleHeight+100)];
    describView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:describView];
    _goodsNameL = [[UILabel alloc] initWithFrame:CGRectMake(kNameLabel_left, kBetween_margin, titleWidth, titleHeight)];
    _goodsNameL.text = title;
    _goodsNameL.font = [UIFont systemFontOfSize:kFontSize_2];
    _goodsNameL.textColor = kBlack_Color_2;
    _goodsNameL.numberOfLines = 0;
    [describView addSubview:_goodsNameL];
    
    _presentPriceL = [[UILabel alloc] initWithFrame:CGRectMake(_goodsNameL.left, _goodsNameL.bottom+kBetween_margin, kPresentPL_width, kPresentPL_height)];
    if (_tjPrice > 0) {
        _presentPriceL.text = [NSString stringWithFormat:@"¥%.1f",_tjPrice];
    } else {
        _presentPriceL.text = [NSString stringWithFormat:@"¥%.2f",_goodsDetailModel.goods_price];
    }
    _presentPriceL.font = [UIFont systemFontOfSize:kFontSize_2];
    _presentPriceL.textColor = kRed_PriceColor;
    [describView addSubview:_presentPriceL];
    
    _originPriceL = [[UILabel alloc] initWithFrame:CGRectMake(_presentPriceL.right, _presentPriceL.top, _presentPriceL.width, _presentPriceL.height)];
    _originPriceL.text =@"";
    _originPriceL.textColor = kDividColor;
    _originPriceL.font = [UIFont systemFontOfSize:kFontSize_3];
    [[YanMethodManager defaultManager] addMiddleLineOnString:_originPriceL];
    [describView addSubview:_originPriceL];
    
    _selectCountView = [[SelectCountView alloc] initWithFrame:CGRectMake((kScreen_width-2*kAddCartBtn_width)-60, _presentPriceL.top, kSelectCountV_width-10, _presentPriceL.height+10)];
    _selectCountView.centerY = _presentPriceL.centerY;
    _selectCountView.minusBtn.tag = 540;
    _selectCountView.plusBtn.tag = 541;
    [_selectCountView.minusBtn addTarget:self action:@selector(detailSelectCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectCountView.plusBtn addTarget:self action:@selector(detailSelectCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [describView addSubview:_selectCountView];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(_selectCountView.right+10, _selectCountView.top, kAddCartBtn_width, _presentPriceL.height+10);
    buyBtn.centerY = _selectCountView.centerY;
    buyBtn.backgroundColor = kColorWithRGB(57, 172, 105);
    buyBtn.layer.cornerRadius = 5;
    buyBtn.tag = 595;
    [buyBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [buyBtn addTarget:self action:@selector(titleBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
    [describView addSubview:buyBtn];
    

//    UIButton * addCartBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    addCartBtn.frame = CGRectMake(buyBtn.left, buyBtn.bottom+10, kAddCartBtn_width, buyBtn.height);;
//    addCartBtn.layer.cornerRadius = 5;
//    addCartBtn.tag = 595;
//    addCartBtn.backgroundColor = kColorWithRGB(255, 187, 56);
//    [addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
//    [addCartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    addCartBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
//    [addCartBtn addTarget:self action:@selector(titleBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
//    [describView addSubview:addCartBtn];
    UIView *footView1 = [[UIView alloc] initWithFrame:CGRectMake(0, buyBtn.bottom + 10, kScreen_width, 0.5)];
    [footView1 setBackgroundColor:kDividColor];
    [describView addSubview:footView1];
    NSArray *titles = @[@"20分钟送货到门",@"积分抵现金"];
    NSArray *imagesArr = @[[UIImage imageNamed:@"detail_send"],[UIImage imageNamed:@"detail_send"]];
    for (int i = 0; i < titles.count; i++) {
        CGFloat creditWidth = 130;
        CGFloat markMargin = (kScreen_width-2*creditWidth)/3;
        CreditAndSendView *creditV = [[CreditAndSendView alloc] initWithFrame:CGRectMake(markMargin+(creditWidth+markMargin)*i, buyBtn.bottom+2*kBetween_margin, creditWidth, kCreditView_height) title:titles[i] image:imagesArr[i] fontSize:kFontSize_3];
        [describView addSubview:creditV];
    }
    
    //评论
    UITableView *commentTableV = nil;
    UILabel *noCommentLabel;
    if (_commentItem) {
        CGFloat commentHeight = [[YanMethodManager defaultManager] titleLabelHeightByText:_commentItem.comment width:kScreen_width-40 font:kFontSize_3];
        commentTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, describView.bottom+3, kScreen_width, commentHeight+177) style:UITableViewStylePlain];
        commentTableV.dataSource = self;
        commentTableV.delegate = self;
        [scrollView addSubview:commentTableV];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 40)];
        headerLabel.text = @"    商品评论";
        headerLabel.textColor = kBlack_Color_1;
        headerLabel.font = [UIFont systemFontOfSize:kFontSize_2];
        commentTableV.tableHeaderView = headerLabel;
        [YanMethodManager lineViewWithFrame:CGRectMake(15, headerLabel.height, headerLabel.width, 0.5) superView:headerLabel];
        
        UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        footerBtn.frame = CGRectMake(0, 0, kScreen_width, 40);
        [footerBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];
        [footerBtn setTitleColor:kBlack_Color_2 forState:UIControlStateNormal];
        footerBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
        [footerBtn addTarget:self action:@selector(checkMoreComments) forControlEvents:UIControlEventTouchUpInside];
        commentTableV.tableFooterView = footerBtn;
        [YanMethodManager lineViewWithFrame:CGRectMake(15, 0, footerBtn.width, 0.5) superView:footerBtn];
        
    } else {
        noCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, describView.bottom+3, kScreen_width, 44)];
        noCommentLabel.text = @"暂无评论";
        noCommentLabel.backgroundColor = [UIColor whiteColor];
        noCommentLabel.textAlignment = NSTextAlignmentCenter;
        noCommentLabel.font = [UIFont systemFontOfSize:kFontSize_2];
        noCommentLabel.textColor = kBlack_Color_2;
        [scrollView addSubview:noCommentLabel];
    }
    
    _matchView = [[MatchView alloc] initWithFrame:CGRectMake(0, commentTableV.bottom+kBetween_margin, kScreen_width, kMatchView_height) title:@"您可能还需要" matchGoods:likegoodsArr];
    if (_commentItem) {
        _matchView.frame = CGRectMake(0, commentTableV.bottom+3, kScreen_width, kMatchView_height);
    } else {
        _matchView.frame = CGRectMake(0, noCommentLabel.bottom+3, kScreen_width, kMatchView_height);
    }
    [scrollView addSubview:_matchView];
    
    CGFloat tempHeight = _commentItem ? commentTableV.height : noCommentLabel.height;
    scrollView.contentSize = CGSizeMake(kScreen_width, kTopImgV_height+20+_goodsNameL.height+_presentPriceL.height+_matchView.height+70+buyBtn.height+tempHeight-34);
    [self tapMatchView:_matchView];
}

-(void)tapMatchView:(MatchView *)matchView
{
    __weak GoodsDetailViewController *weakSelf = self;
    matchView.matchTapBlock = ^(UITapGestureRecognizer *tap){
        if (tap.view.tag-600 < 20) {//进入商品详情
            HomeGoodsItem *item = likegoodsArr[tap.view.tag - 600];
            GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
            detailVC.goods_id = item.goods_id;
            detailVC.goods_name = item.goods_name;
            detailVC.goods_price = [NSString stringWithFormat:@"%.1f",item.goods_price];
            detailVC.goods_pic = item.goods_pic;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        } else {//加入购物车
            HomeGoodsItem *item = likegoodsArr[tap.view.tag - 650];

                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
                
                NetWorkRequest *request = [[NetWorkRequest alloc]init];
                NSString *para = [NSString stringWithFormat:@"goods_id=%d&quantity=%d&member_id=%@",item.goods_id,1,userName];
                [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:para];
                request.successRequest = ^(NSDictionary *dataDic){
                    NSString *codeNum = [dataDic objectForKey:@"code"];
                    int code = [codeNum intValue];
                    if (code == 200) {
                        NSNumber *count = [dataDic objectForKey:@"count"];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)count.integerValue] forKey:@"local_cartGoodsCount"];
                        for (UINavigationController *navi in self.tabBarController.viewControllers) {
                            if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                                navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count.integerValue];
                            }
                        }
                        [weakSelf.view makeToast:@"加入购物车成功" duration:1 position:@"center"];

                    }else if(code == 203){
                        
                        [weakSelf.view makeToast:@"购物车已满，请删除部分商品后重新加入" duration:1 position:@"center"];
                        
                    }else
                    {
                        [weakSelf.view makeToast:@"加入购物车失败" duration:1 position:@"center"];
                    }
                };
            }
//        [self.view makeToast:@"已加入购物车" duration:1.5 position:@"center"];
        
    };
}

-(void)titleBtnsAction:(UIButton *)button
{
    __weak GoodsDetailViewController *weakSelf = self;
    if (button.tag == 595) {//加入购物车
        
        [self isLoginHandle:^{
            [weakSelf putIntoCart];
        } hasLogin:^{
            [weakSelf putIntoCart];
        }];
    }
    else {//进入购物车
        [self isLoginHandle:^{
            CartViewController *cartVC = [[CartViewController alloc] init];
            cartVC.isPush = YES;
            [weakSelf.navigationController pushViewController:cartVC animated:YES];
        } hasLogin:^{
            CartViewController *cartVC = [[CartViewController alloc] init];
            cartVC.isPush = YES;
            [weakSelf.navigationController pushViewController:cartVC animated:YES];
        }];
    }
}

-(void)putIntoCart
{
    if (_selectCountView.countLabel.text.integerValue > 0)
    {
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        
        NetWorkRequest *request = [[NetWorkRequest alloc]init];
        NSString *para = [NSString stringWithFormat:@"goods_id=%d&quantity=%ld&member_id=%@",_goods_id,(long)goodsCount,userName];
        [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:para];
        __weak GoodsDetailViewController *weakSelf = self;
        request.successRequest = ^(NSDictionary *dataDic){
            NSLog(@"============= cart add = %@",dataDic);
            NSNumber *code = [dataDic objectForKey:@"code"];
            if (code.integerValue == 200) {
//                [self.view makeToast:@"加入购物车成功" duration:1.0 position:@"center"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf addGoodsIntoCartWithGesture:_topImgV];
                    NSNumber *count = [dataDic objectForKey:@"count"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)count.integerValue] forKey:@"local_cartGoodsCount"];
                    _badgeView.badgeText = [NSString stringWithFormat:@"%ld",count.integerValue];
                    for (UINavigationController *navi in self.tabBarController.viewControllers) {
                        if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                            navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count.integerValue];
                        }
                    }
                });
            } else if (code.integerValue == 203) {
                [weakSelf.view makeToast:@"您的购物车已满,请先结算购物车商品" duration:1.0 position:@"center"];
            } else {
                [weakSelf.view makeToast:@"加入购物车失败" duration:1.0 position:@"center"];
            }
        };
        request.failureRequest = ^(NSError *error){
            [weakSelf.view makeToast:@"加入购物车失败" duration:1.5 position:@"center"];
        };
        
    } else {
        [self.view makeToast:@"请选择购买数量" duration:1.5 position:@"center"];
    }
}

//没有登录先登录//(void(^)(NSMutableArray *items))successHandle
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

//立即购买
-(void)buyRightNowAction
{
    if (!_marketIsLogin) {
        _marketIsLogin = YES;
        [self systemIsOpenHandle];

    }
}

//立即购买前先判断超市系统状态
-(void)systemIsOpenHandle
{
    [YanMethodManager showIndicatorOnView:self.view];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=isopenstore"] postData:[NSString stringWithFormat:@"store_id=%d",_store_id]];
    __weak GoodsDetailViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *packageDic){
        _marketIsLogin = NO;
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
        NSLog(@"===== package dic = %@",packageDic);
        NSNumber *code = [packageDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSNumber *isOpen = [packageDic objectForKey:@"isopen"];
            if (isOpen.integerValue == 1) {
                [weakSelf isLoginHandle:^{
                    [weakSelf loginPayRightNow];
                } hasLogin:^{
                    [weakSelf loginPayRightNow];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
        NSString *telephone = [storeDic objectForKey:@"telephone"];
        
        [[YanMethodManager defaultManager] callPhoneActionWithNum:telephone viewController:self];
    }
}

-(void)loginPayRightNow
{
    if (_selectCountView.countLabel.text.integerValue > 0) {
        PayRightNowViewController *payVC = [[PayRightNowViewController alloc] init];
        payVC.goods_name = _goodsDetailModel.goods_name;
        payVC.market_name = _goodsDetailModel.store_name;
        if (_tjPrice > 0) {
            payVC.price = [NSString stringWithFormat:@"%.2f",_tjPrice];
        } else {
            payVC.price = [NSString stringWithFormat:@"%.2f",_goodsDetailModel.goods_price];
        }
        payVC.count = _selectCountView.countLabel.text;
        payVC.goods_id = _goodsDetailModel.goods_id;
        payVC.store_id = _goodsDetailModel.store_id;
        [self.navigationController pushViewController:payVC animated:YES];
    } else {
        [self.view makeToast:@"请选择购买数量" duration:1.5 position:@"center"];
    }
}

//选择产品个数
-(void)detailSelectCountAction:(UIButton *)button
{
    NSInteger count = _selectCountView.countLabel.text.integerValue;
    if (button.tag == 540) {//minus
        if (count > 1) {
            --count;
        }
    } else {//plus
        ++count;
    }
    goodsCount = count;
    _selectCountView.countLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
}

#pragma mark UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCommentsTableViewCell *cell = [[GoodsCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentsData = _commentItem;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [[YanMethodManager defaultManager] titleLabelHeightByText:_commentItem.comment width:kScreen_width-40 font:kFontSize_3];
    return height + 90;
}

-(void)checkMoreComments
{
    GoodsCommentsViewController *commentVC = [[GoodsCommentsViewController alloc] init];
    commentVC.goods_id = _goods_id;
    commentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentVC animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    if (_badgeView) {
        NSString *badgeCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_cartGoodsCount"];
        if (badgeCount.integerValue > 0) {
            _badgeView.badgeText = badgeCount;
        } else {
            _badgeView.badgeText = @"";
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

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
