//
//  MyCommentViewController.h
//  OCommunity
//
//  Created by runkun2 on 15/5/20.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGoodsItem.h"
#import "OrderDetailModel.h"
typedef void(^AddMyCommentSuccess)(void);

@interface MyCommentViewController : UIViewController<UITextViewDelegate>
@property(nonatomic,copy)HomeGoodsItem *dataModel;
@property(nonatomic,copy)OrderDetailModel *orderDetail;
@property(nonatomic,copy)NSString *marketPicName;
@property(nonatomic,copy)AddMyCommentSuccess addMycommentSuccess;

@end
