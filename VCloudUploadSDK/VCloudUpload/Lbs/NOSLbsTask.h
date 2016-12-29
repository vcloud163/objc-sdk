//
//  NOSLbsTask.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/17.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOSHttpManager.h"

/**
 *  lbs获取上传加速节点地址回调
 *
 *  @param resp        回调结果
 *  @param lbsUseTime  请求时间
 *  @param lbsHttpCode http状态码
 *  @param lbsSucc     0为成功，1为失败
 *  @param net         桶名
 */
typedef void (^NOSLbsCompletionHandler)(NSDictionary *resp, long long lbsUseTime, NSInteger lbsHttpCode, NSInteger lbsSucc, NSString *net);

/**
 *    内部使用类：lbs任务
 */
@interface NOSLbsTask : NSObject
// 初始化回调
- (instancetype) initWithCompleteHandler:(NOSLbsCompletionHandler) completeHandler;
//根据桶名获取上传主机ip
- (void) fetchUploaderHosts:(NSString *)bucketName;
@end
