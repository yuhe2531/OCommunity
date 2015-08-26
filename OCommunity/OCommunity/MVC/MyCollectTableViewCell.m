//
//  MyCollectTableViewCell.m
//  OCommunity
//
//  Created by runkun2 on 15/5/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MyCollectTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation MyCollectTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createGoodsListCellSubviews];
    }
    return self;
}

#define kImageV_left 15
#define kImageV_top 10
#define kImageV_width 90
#define kImageV_height 80
#define kShopCartWidth 25

-(void)createGoodsListCellSubviews
{
    _listImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kImageV_left, kImageV_top, kImageV_width, kImageV_height)];
    _listImgV.image = kHolderImage;
    [self.contentView addSubview:_listImgV];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(kImageV_left+_listImgV.right, _listImgV.top, kScreen_width-kImageV_left*2-_listImgV.width-50, 20)];
    _titleL.text = @"汇源果肉饮料 2.5L";
    _titleL.font = [UIFont systemFontOfSize:kFontSize_2];
    [self.contentView addSubview:_titleL];
    
    _priceL = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _titleL.bottom+(_listImgV.height-_titleL.height-_titleL.height), 80, _titleL.height)];
    _priceL.text = @"¥25.0";
    _priceL.textColor = kRedColor;
    _priceL.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_priceL];
    
     _cartBtn = [UIButton buttonWithType:UIButtonTypeSystem];
     _cartBtn.frame = CGRectMake(kScreen_width-55
                                 , _priceL.top-20, 45, 45);
    [_cartBtn setBackgroundImage:[UIImage imageNamed:@"home_smallCart"] forState:UIControlStateNormal];
//     _cartBtn.backgroundColor = [UIColor redColor];
    [_cartBtn addTarget:self action:@selector(carBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.contentView addSubview:_cartBtn];
     UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_cartBtn.left -10, _cartBtn.top, 1, 50)];
     view.backgroundColor = kDividColor;
     [self.contentView addSubview:view];
     
    
}
-(void)carBtnClickAction:(UIButton *)btn{
    
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (member_id!=NULL) {
        NetWorkRequest *request = [[NetWorkRequest alloc]init];
        
        NSString *para = [NSString stringWithFormat:@"goods_id=%d&quantity=%d&member_id=%@",_goodsCollection.goods_id,1,member_id];
        [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:para];
        request.successRequest = ^(NSDictionary *dataDic)
        {
            NSNumber *codeNum = [dataDic objectForKey:@"code"];
            int code = [codeNum intValue];
            if (code == 200) {
                [self makeToast:@"已加入购物车" duration:.8 position:@"center"];
            }else if (code == 203){
                [self makeToast:@"您的购物车已满,请先结算购物车" duration:.8 position:@"center"];
            } else {
                [self makeToast:@"加入购物车失败" duration:.8 position:@"center"];
            }
        };
        request.failureRequest = ^(NSError *error){
            [self makeToast:@"加入购物车失败" duration:.8 position:@"center"];
        };
    }

}
-(void)setMarkStr:(NSString *)markStr
{
    _markStr = markStr;
    CGFloat markWidth = [[YanMethodManager defaultManager] LabelWidthByText:_markStr height:20 font:kFontSize_3]+10;
    UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _titleL.bottom+10, markWidth, 20)];
    markLabel.backgroundColor = KRandomColor;
    markLabel.text = _markStr;
    markLabel.textColor = [UIColor whiteColor];
    markLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    markLabel.centerY = _listImgV.centerY;
    markLabel.textAlignment = NSTextAlignmentCenter;
    markLabel.layer.cornerRadius = 3;
    markLabel.clipsToBounds = YES;
    [self.contentView addSubview:markLabel];
}
-(void)setGoodsCollection:(goodsClassify *)goodsCollection{
    
    _goodsCollection = goodsCollection;
    [_listImgV sd_setImageWithURL:[NSURL URLWithString:_goodsCollection.goods_pic] placeholderImage:kHolderImage];
    _titleL.text = _goodsCollection.goods_name;
    _priceL.text = [NSString stringWithFormat:@"￥%.2f",_goodsCollection.goods_price];
}

-(void)setHasPurchased:(BOOL)hasPurchased
{
    _hasPurchased = hasPurchased;
    if (_hasPurchased) {
        [_cartBtn setTitle:@"再次购买" forState:UIControlStateNormal];
    }
}

-(void)cartBtnAction:(UIButton *)button
{
    if (self.cartBlock) {
        self.cartBlock();
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the
}
@end
