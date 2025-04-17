//
//  OSSManager.m
//  AliyunOSSSDK-iOS-Example
//
//  Created by huaixu on 2018/10/23.
//  Copyright © 2018 aliyun. All rights reserved.
//

#import "OSSManager.h"
#import "NOSUploadManager.h"

@implementation OSSManager

+ (instancetype)sharedManager {
    static OSSManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[OSSManager alloc] init];
    });
    
    return _manager;
}

- (void)resetDefaultImageClient:(NOSUploadManager *)nosUploadManager {
    
    
    //id<OSSCredentialProvider> credentialProvider = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:@"<StsToken.AccessKeyId>" secretKeyId:@"<StsToken.SecretKeyId>" securityToken:@"<StsToken.SecurityToken>"];
    
    id<OSSCredentialProvider> credentialProvider = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:nosUploadManager.accessKeyId
                                                                                                  secretKeyId:nosUploadManager.accessKeySecret
                                                                                                securityToken:nosUploadManager.securityToken];

    OSSClientConfiguration *cfg = [[OSSClientConfiguration alloc] init];
    cfg.maxRetryCount = 3;
    cfg.timeoutIntervalForRequest = 15;
    cfg.isHttpdnsEnable = NO;
    cfg.crc64Verifiable = YES;
    
    //OSSClient *defaultClient = [[OSSClient alloc] initWithEndpoint:OSS_ENDPOINT credentialProvider:credentialProvider clientConfiguration:cfg];
    //OSSClient *defaultClient = [[OSSClient alloc] initWithEndpoint:nosUploadManager.host credentialProvider:credentialProvider clientConfiguration:cfg];
    OSSClient *defaultClient = [[OSSClient alloc] initWithEndpoint:@"oss-ap-southeast-1.aliyuncs.com" credentialProvider:credentialProvider clientConfiguration:cfg];
    [OSSManager sharedManager].defaultClient = defaultClient;
    
    //OSSClient *defaultImgClient = [[OSSClient alloc] initWithEndpoint:OSS_IMG_ENDPOINT credentialProvider:credentialProvider clientConfiguration:cfg]; // TODO
    OSSClient *defaultImgClient = [[OSSClient alloc] initWithEndpoint:@"oss-ap-southeast-1.aliyuncs.com" credentialProvider:credentialProvider clientConfiguration:cfg];
    [OSSManager sharedManager].imageClient = defaultImgClient;
}

@end
