//
//  NOSTestConf.m
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/18.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NOSTestConf.h"

//NSString *const kNOSTestBucket = @"doc";
//NSString *const kNOSTestAccessKey = @"testAccessKey"; //
//NSString *const kNOSTestSecretKey = @"testSecretKey"; //
NSString *const kNOSTestBucket = @"vodk32ywxdf";
NSString *const kNOSTestAccessKey = @"ab1856bb39044591939d7b94e1b8e5ee"; //
NSString *const kNOSTestSecretKey = @"ed1573cd7de34086a0ba5c3c521c6df1"; //

//所有接口均需要放置以下公共参数在请求头中，用于标识用户和接口鉴权
NSString *const kNOSTestAppKey = @"027338bf05cc4a65b5d98bc9d6af80b3";
NSString *const kNOSTestNonce = @"1"; //
NSString *const kNOSTestCurTime = @"1465723418"; //
NSString *const kNOSTestCheckSum = @"038f586f690359adf75012337ea367e2b5fca6fb"; //

NSString *const kNOSTestAccid = @"abcdefgh";
NSString *const kNOSTestToken = @"4c1d5942ff0040588931bb244d9761c6d687d526";


const UInt32 kNOSTestSoTimeout = 30;

const UInt32 kNOSTestConnectionTimeout = 30;

const UInt32 kNOSTestChunkSize = 128 * 1024;

const UInt32 kNOSTestMoniterInterval = 5;

const UInt32 kNOSTestRetryCount = 3;

const UInt32 kNOSTestRefreshInterval = 5; // for test, so the interval set to small

NSString *const kNOSTestLbsHost = @"http://wanproxy.127.net";


@implementation NOSTestConf

+ (NOSConfig *) testNOSConf {
    return [[NOSConfig alloc] initWithLbsHost:kNOSTestLbsHost
                           withSoTimeout:kNOSTestSoTimeout
                   //withConnectionTimeout:kNOSTestConnectionTimeout
                     withRefreshInterval:kNOSTestRefreshInterval
                           withChunkSize:kNOSTestChunkSize
                     withMoniterInterval:kNOSTestMoniterInterval
                          withRetryCount:kNOSTestRetryCount];
}

@end
