//
//  CommentsModel.h
//  OCommunity
//
//  Created by runkun2 on 15/6/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//
/*
 
 "add_time" = 0;
 comment = "\U96f6\U70b9\U597d\U597d\U4e86\U597d\U4e86\U597d\U8fd9\U4e2a\U5546\U54c1\U662f\U771f\U7684\U5f88\U597d\U5f3a\U70c8\U63a8\U5df1\U53ca\U4eba\U53ca\U8eab\U8fb9\U7684\U6240\U6709\U548c\U670b\U53cb\U597d\U597d\U4e86\U597d\U4e86\U597d\U8fd9\U4e2a\U5546\U54c1\U662f\U771f\U7684\U5f88\U597d\U5f3a\U70c8\U63a8\U5df1\U53ca\U4eba\U53ca\U8eab\U8fb9\U7684\U6240\U6709\U548c\U670b\U53cb\U597d\U597d\U4e86\U597d\U4e86\U597d\U8fd9\U4e2a\U5546\U54c1\U662f\U771f\U7684\U5f88\U597d\U5f3a\U70c8\U63a8\U5df1\U53ca\U4eba\U53ca\U8eab\U8fb9\U7684\U6240\U6709\U548c\U670b\U53cb\U597d\U597d\U4e86\U597d\U4e86\U597d\U8fd9\U4e2a\U5546\U54c1\U662f\U771f\U7684\U5f88\U597d\U5f3a\U70c8\U63a8\U5df1\U53ca\U4eba\U53ca\U8eab\U8fb9\U7684\U6240\U6709\U548c\U670b\U53cb\U597d\U597d\U4e86\U597d\U4e86\U597d\U8fd9\U4e2a\U5546\U54c1\U662f\U771f\U7684\U5f88\U597d\U5f3a\U70c8\U63a8\U5df1\U53ca\U4eba\U53ca\U8eab\U8fb9\U7684\U6240\U6709\U548c\U670b\U53cb\U597d\U597d\U4e86\U597d\U4e86\U597d\U8fd9\U4e2a\U5546\U54c1\U662f\U771f\U7684\U5f88\U597d\U5f3a\U70c8\U63a8\U5df1\U53ca\U4eba\U53ca\U8eab\U8fb9\U7684\U6240\U6709\U548c\U670b\U53cb\U597d\U597d\U4e86\U597d\U4e86\U597d\U8fd9\U4e2a\U5546\U54c1\U662f\U771f\U7684\U5f88\U597d\U5f3a\U70c8\U63a8\U5df1\U53ca\U4eba\U53ca\U8eab\U8fb9\U7684\U6240\U6709\U548c\U670b\U53cb";
 "comment_id" = 5;
 "flower_num" = 0;
 "goods_id" = 7693;
 "goods_name" = "\U8ba1\U7b97\U5668";
 "goods_pic" = "http://app.lingbushequ.com/data/upload/shop/goods/aec5c3e4667a00c4903eedb96bc35fcd.jpg";
 "member_name" = 0;
 "store_id" = 56;
 
 */

#import <Foundation/Foundation.h>

@interface CommentsModel : NSObject
@property (nonatomic, assign) int comment_id;
@property (nonatomic, copy) NSString *member_name;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, assign) int flower_num;
@property (nonatomic, assign) int store_id;
@property(nonatomic,copy)NSString *add_time;
@property (nonatomic, assign) int goods_id;
@property(nonatomic,copy)NSString *goods_name;
@property(nonatomic,copy)NSString *goods_pic;
@property(nonatomic,copy)NSString *order_sn;
@property(nonatomic,copy)NSString *store_pic;
@property(nonatomic,assign)CGFloat rowHeight;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(id)initWithDic:(NSDictionary *)dic;
@end
