//
//  NOSUploadManager+Private.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/16.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NOSUploadManager.h"
#import "NOSStatTimeTask.h"
#import "NOSBucketLBSMap.h"
#import "NOSLbsTask.h"

@interface NOSUploadManager (Private)
//全局配置
+ (NOSConfig*) globalConf;
//桶lbsMap
+ (NOSBucketLBSMap*) bucketLbsMap;
//统计时间任务
+ (NOSStatTimeTask*) statTimeTask;
//lbs任务
+ (NOSLbsTask*) lbsTask;
@end
