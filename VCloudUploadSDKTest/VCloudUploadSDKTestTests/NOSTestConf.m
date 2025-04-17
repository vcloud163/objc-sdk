//
//  NOSTestConf.m
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/18.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NOSTestConf.h"

//ENABLE_OSS： YES 使用海外 aliyun上传
#define ENABLE_OSS 0

NSString *const kNOSTestBucket = @"testBucket";
NSString *const kNOSTestAccessKey = @"testAccessKey";
NSString *const kNOSTestSecretKey = @"testSecretKey";

//所有接口均需要放置以下公共参数在请求头中，用于标识用户和接口鉴权
NSString *const kNOSTestNonce = @"1"; //
NSString *const kNOSTestCurTime = @"1465723418"; //
NSString *const kNOSTestCheckSum = @"038f586f690359adf75012337ea367e2b5fca6fb"; //

NSString *const kNOSTestAppKey = @"<#请输入appkey#>";
NSString *const kNOSTestAccid = @"<#Accid#>";
NSString *const kNOSTestToken = @"<#Token#>";


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
