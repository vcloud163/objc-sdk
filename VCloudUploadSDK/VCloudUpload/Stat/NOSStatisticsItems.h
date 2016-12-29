//
//  NOSStatisticsItems.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/22.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

//统计项
@interface NOSStatisticsItems : NSObject
//客户端ip地址
@property NSString *clientIP;
//上传主机数组
@property NSArray* uploaderHosts;
//上传主机索引
@property NSInteger uploaderIndex;
//数据大小
@property long long dataSize;
//上传开始时间戳
@property long long uploaderStartTime;
//上传结束时间戳
@property long long uploaderEndTime;

@property NSInteger uploaderSucc;
//上传http状态码
@property NSInteger uploaderHttpCode;
//lbs ip 地址
@property NSString *lbsIP;
//网络环境
@property NSString *netEnv;
//获取上传加速节点地址：lbs请求时间
@property long long lbsUseTime;
//获取上传加速节点地址：0为成功，1为失败
@property NSInteger lbsSucc;
//lbs http状态码
@property NSInteger lbsHttpCode;

//分片重试次数
@property NSInteger chunkRetryCount;

// query offset重试次数
@property NSInteger queryRetryCount;

// 本次上传共试了多少个upload hosts
//@property NSInteger uploadRetryCount; 使用uploadIndex

//桶名
@property NSString *bucketName;

@property BOOL hasLbsPushed;


- (NSString*) toJson;

@end
