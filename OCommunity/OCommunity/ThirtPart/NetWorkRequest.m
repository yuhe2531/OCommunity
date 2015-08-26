//
//  NetWorkRequest.m
//  网络封装
//
//  Created by lanou3g on 14-4-23.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "NetWorkRequest.h"
#import "AppDelegate.h"

@interface NetWorkRequest ()
{
    CGFloat _totalLenth;
}
@property (nonatomic,retain) NSMutableData *receiveData;
@property (nonatomic,retain) NSURLConnection *connection;

@end

@implementation NetWorkRequest

- (void)dealloc
{
    [_connection release];
    [_receiveData release];
    _receiveData = nil;
    [super dealloc];
}

#pragma mark --------网络请求设置----------

//取消网络请求
-(void)cancelRequest
{
    [_connection cancel];
    self.connection = nil;
    self.delegate = nil;
}

//实现GET请求
-(void)requestForGETWithUrl:(NSString *)urlString
{
    //封装url对象
    NSURL *url = [NSURL URLWithString:urlString];
    //设置GET请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    //建立异步连接,使用设置的delegate方式实现
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

//实现POST请求
-(void)requestForPOSTWithUrl:(NSString *)urlString postData:(NSString *)data
{
    //封装url对象
    NSURL *url = [NSURL URLWithString:urlString];
    //设置POST请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSData *paraData = [data dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:paraData];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}


#pragma mark ----------网络连接完成-------------

//代理方法
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receiveData = [NSMutableData data];
    //记录总长度
    _totalLenth = response.expectedContentLength;
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
    //计算当前的下载进度
    
    CGFloat progress = [_receiveData length]/_totalLenth;
    
    //通知代理,执行代理方法,获取当前的下载进度
    if ([_delegate respondsToSelector:@selector(netWorkRequest:withProgress:)]) {
        [_delegate netWorkRequest:self withProgress:progress];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //通知代理,执行代理方法,获取下载得到的数据
    if ([_delegate respondsToSelector:@selector(netWorkRequest:didSuccessfuReceiveData:)]) {
        [_delegate netWorkRequest:self didSuccessfuReceiveData:_receiveData];
    }
//    NSString *string = [[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding];
//    NSLog(@"=========== request ********* str = %@",string);
    NSDictionary *requestDic = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableContainers error:nil];
    if (self.successRequest) {
        self.successRequest(requestDic);
    }
    
    //清空
    self.receiveData = nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.window makeToast:@"网络异常,请检查网络连接" duration:0.3 position:@"center"];
    NSLog(@" ===  error = %@",[error description]);
    //通知代理,执行代理方法,此时网络请求失败,获取error信息
    if ([_delegate respondsToSelector:@selector(netWorkRequest:didFaild:)]) {
        [_delegate netWorkRequest:self didFaild:error];
    }
    
    if (self.failureRequest) {
        self.failureRequest(error);
    }
    
    //清空
    self.receiveData = nil;
    
}


@end
