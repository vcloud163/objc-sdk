//
//  NOSLbsNetMonitorTask.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/17.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NOSLbsTask.h"

/**
 *    内部使用类：lbs网络监听任务
 */
@interface NOSLbsNetMonitorTask : NOSLbsTask
//开启网络监听服务
+ (instancetype)sharedInstanceAndRunWithCompleteHandler:(NOSLbsCompletionHandler) completeHandler;
@end
