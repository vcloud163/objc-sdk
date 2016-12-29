//
//  NOSBucketLBSMap+Private.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2016.3.7.
//  Copyright (c) 2016年 NetEase. All rights reserved.
//


#import "NOSBucketLBSMap.h"

@interface NOSBucketLBSMap (Private)
//lbsInfo对象转字典
+ (NSDictionary *) dicWithLbsInfo:(NOSLbsInfo*)lbsInfo;
//在持久化中的桶名
+ (NSString *) bucketStrInPersistent:(NSString *) bucketName;
@end