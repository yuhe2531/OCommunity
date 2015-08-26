//
//  GoodsCommentsTableViewCell.m
//  OCommunity
//
//  Created by runkun2 on 15/6/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "GoodsCommentsTableViewCell.h"
#import "CommentStar.h"
#define kNameLabelWidth 200
#import "UIImageView+WebCache.h"
@implementation GoodsCommentsTableViewCell{

    UIImageView *_memberImageView;
    UILabel *_nameLabel;
    CommentStar *_scoreView;
    UILabel *_commentLabel;
    UILabel *_dateLabel;
    



}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}
-(void)createSubviews{

    _memberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    int iconNum = arc4random()%5 + 1;
    _memberImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"comment_icon%d",iconNum]];
    [self.contentView addSubview:_memberImageView];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_memberImageView.right + 10, _memberImageView.top +10, kNameLabelWidth, 25)];
    _nameLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    _nameLabel.textColor = kBlack_Color_2;
    [self.contentView addSubview:_nameLabel];
    _nameLabel.text = @"17686011782";
    _scoreView = [[CommentStar alloc] initWithFrame:CGRectMake(kScreen_width-95, _nameLabel.top +5, 75, 15)];
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_memberImageView.left, _memberImageView.bottom +5, kScreen_width - 40, 50)];
    _commentLabel.numberOfLines = 0;
    _commentLabel.text = @"";
//    _commentLabel.height = [[YanMethodManager defaultManager] titleLabelHeightByText:@"快递很给力，不错，赞一个！快递很给力，不错，赞一个！快递很给力，不错，赞一个！快递很给力，不错，赞一个！快递很给力，不错，赞一个！快递很给力，不错，赞一个！快递很给力，不错，赞一个！快递很给力，不错，赞一个！快递很给力，不错，赞一个！快递很给力，不错，赞一个！快递很给力，不错，赞一个！快递很给力，不错，赞一个！" width:kScreen_width - 40 font:kFontSize_3];
    _commentLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    _commentLabel.textColor = kBlack_Color_2;
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_scoreView.left, _commentLabel.bottom +5, 100, 15)];
    _dateLabel.text = @"2015-01-26";
    _dateLabel.font = [UIFont systemFontOfSize:kFontSize_4];
    _dateLabel.textColor = kBlack_Color_3;
    [self.contentView addSubview:_scoreView];
    [self.contentView addSubview:_dateLabel];
    [self.contentView addSubview:_commentLabel];

}
-(void)setCommentsData:(CommentsModel *)commentsData{

    _commentsData = commentsData;
    _nameLabel.text = commentsData.member_name;
    if (_commentsData.member_name.length==11) {
        NSRange range = {3,5};
        NSString *member_name = [commentsData.member_name stringByReplacingCharactersInRange:range withString:@"*****"];
        _nameLabel.text = member_name;

    }
    _commentLabel.text = _commentsData.comment;
    _commentLabel.height = [[YanMethodManager defaultManager] titleLabelHeightByText:_commentsData.comment width:kScreen_width - 40 font:kFontSize_3];
    _dateLabel.top = _commentLabel.bottom +5;
    _scoreView.rating = (CGFloat)_commentsData.flower_num;
    _dateLabel.text = _commentsData.add_time;


}
-(void)setMyComments:(CommentsModel *)myComments{

    _myComments = myComments;
    if (_myComments.order_sn.length>=24) {
        NSRange range = {7,11};
        NSString *order_sn = [_myComments.order_sn stringByReplacingCharactersInRange:range withString:@"*****"];
        _nameLabel.text = order_sn;
    }else{
        _nameLabel.text = _myComments.order_sn;
    }
    _commentLabel.text = _myComments.comment;
    _commentLabel.height = [[YanMethodManager defaultManager] titleLabelHeightByText:_myComments.comment width:kScreen_width - 40 font:kFontSize_3];
    _dateLabel.top = _commentLabel.bottom +5;
    _scoreView.rating = (CGFloat)_myComments.flower_num;
    _dateLabel.text = _myComments.add_time;
    [_memberImageView sd_setImageWithURL:[NSURL URLWithString:_myComments.store_pic] placeholderImage:kHolderImage];
    
}
@end
