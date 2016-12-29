//
//  HttpManager.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/12.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NOSResponseInfo;
/**
 *  上传进度回调
 *
 *  @param totalBytesWritten         已经上传的字节
 *  @param totalBytesExpectedToWrite 总共要上传的字节
 */
typedef void (^NOSInternalProgressBlock)(long long totalBytesWritten, long long totalBytesExpectedToWrite);
/**
 *  上传完成回调
 *
 *  @param info 请求完成后返回的状态信息
 *  @param resp 回调结果
 */
typedef void (^NOSCompleteBlock)(NOSResponseInfo *info, NSDictionary *resp);
/**
 *  上传取消回调
 *
 *  @return 
 */
typedef BOOL (^NOSCancelBlock)(void);

@interface NOSHttpManager : NSObject

/**
 *  post请求
 *
 *  @param url           请求地址
 *  @param data          请求体
 *  @param params        请求参数
 *  @param headers       请求头部
 *  @param completeBlock 上传成功回调
 *  @param progressBlock 上传进度回调
 *  @param cancelBlock   上传取消回调
 */
- (void)         post:(NSString *)url
             withData:(NSData *)data
           withParams:(NSDictionary *)params
          withHeaders:(NSDictionary *)headers
    withCompleteBlock:(NOSCompleteBlock)completeBlock
    withProgressBlock:(NOSInternalProgressBlock)progressBlock
      withCancelBlock:(NOSCancelBlock)cancelBlock;

/**
 *  get请求
 *
 *  @param url           请求地址
 *  @param params        请求参数
 *  @param headers       请求头部
 *  @param completeBlock 上传成功回调
 */
- (void)          get:(NSString *)url
           withParams:(NSDictionary *)params
          withHeaders:(NSDictionary *)headers
    withCompleteBlock:(NOSCompleteBlock)completeBlock;

@end
