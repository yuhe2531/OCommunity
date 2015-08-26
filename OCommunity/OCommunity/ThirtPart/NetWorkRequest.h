//
//  NetWorkRequest.h
//  网络封装
//
//  Created by lanou3g on 14-4-23.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NetWorkRequest;

typedef void(^SuccessData)(NSDictionary *);
typedef void(^FailureData)(NSError *);

//设置代理
@protocol NetWorkRequestDelegate <NSObject>

@optional

//netWork请求成功
-(void)netWorkRequest:(NetWorkRequest *)request didSuccessfuReceiveData:(NSData *)data;
//netWork请求失败
-(void)netWorkRequest:(NetWorkRequest *)request didFaild:(NSError *)error;
//获取netWork下载进度
-(void)netWorkRequest:(NetWorkRequest *)request withProgress:(CGFloat)progress;

@end

@interface NetWorkRequest : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic,assign) id<NetWorkRequestDelegate> delegate;
@property (nonatomic, copy) SuccessData successRequest;
@property (nonatomic, copy) FailureData failureRequest;

//声明两个方法,对外提供接口,分别实现GET请求方式和POST请求方式

//实现GET请求
-(void)requestForGETWithUrl:(NSString *)urlString;

//实现POST请求
-(void)requestForPOSTWithUrl:(NSString *)urlString postData:(NSString *)data;


//取消网络请求
-(void)cancelRequest;
@end
