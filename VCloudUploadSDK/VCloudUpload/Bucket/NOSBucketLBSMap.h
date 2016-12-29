//
//  NOSBucketLBSMap.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2016/2/29.
//  Copyright (c) 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOSLbsInfo.h"

@interface NOSBucketLBSMap : NSObject
//网络环境
@property (nonatomic) NSString *net;
//桶lbsMap
@property NSMutableDictionary *bucketLbsMap;
//持久Map
@property NSUserDefaults *persistentMap;

//根据桶名设置lbsInfo信息
- (void) addLbsInfo:(NOSLbsInfo*)lbsInfo
          forBucket:(NSString *)bucketName;
//根据桶名制作lbsInfo快照并返回
- (NOSLbsInfo*) lbsInfoSnapshot:(NSString *)bucketName;
//根据桶名寻找最新的lbsInfo
- (NOSLbsInfo*) lbsInfoNewest:(NSString*)bucketName;
//根据桶名修改lbsInfo的最后修改时间戳，并重新持久化
- (void) invalidLBSInfoForBucket:(NSString *)bucketName;
//将所有缓存中的lbsInfo都无效化
- (void) invalidLBSInfo;
@end
