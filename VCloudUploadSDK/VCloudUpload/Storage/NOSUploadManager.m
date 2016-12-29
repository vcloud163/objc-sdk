//
//  NOSUploader.h
//  NOSSDK
//
//  Modified by hzzhenghuabin on 2015/1/18.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NOSConfig.h"
#import "NOSHttpManager.h"
#import "NOSResponseInfo.h"
#import "NOSUploadManager.h"
#import "NOSResumeUpload.h"
#import "NOSUploadOption+Private.h"
#import "NOSAsyncRun.h"
#import "NOSLbsNetMonitorTask.h"
#import "NOSBucketLBSMap.h"
#import "NOSStatTimeTask.h"
#import "NOSTimeUtils.h"
#import "NOSLbsTask.h"
#import "NOSVcloudHttpManager.h"

@interface NOSUploadManager ()<NOSVcloudRequestDelegate>
@property (nonatomic) NOSHttpManager *httpManager;
@property (nonatomic) id <NOSRecorderDelegate> recorder;
@property (nonatomic, strong) NOSRecorderKeyGenerator recorderKeyGen;
@end

/**
 * static, NOSUploadManager may be multiple instances, 
 * though we recommend user use NOSUploadManager as a singleton
 */
static NOSConfig* globalConf;
static NOSBucketLBSMap* bucketLbsMap;
static NOSLbsTask* lbsTask;
static NOSLbsNetMonitorTask* lbsNetMonitorTask;
static NOSStatTimeTask* statTimeTask;

@implementation NOSUploadManager
//=========================================================================
-(void)setDelegate:(id<NOSUploadRequestDelegate>)delegate{
    _delegate = delegate;
    [NOSVcloudHttpManager sharedInstance].delegate = self;
}

-(NSString *)NOSVcloudAppKey{
    if (_delegate && [_delegate respondsToSelector:@selector(NOSUploadAppKey)]) {
        return [_delegate NOSUploadAppKey];
    }
    return @"";
}

-(NSString *)NOSVcloudAppAccid{
    if (_delegate && [_delegate respondsToSelector:@selector(NOSVcloudAppAccid)]) {
        return [_delegate NOSVcloudAppAccid];
    }
    return @"";
}

-(NSString *)NOSVcloudAppToken{
    if (_delegate && [_delegate respondsToSelector:@selector(NOSVcloudAppToken)]) {
        return [_delegate NOSVcloudAppToken];
    }
    return @"";
}

-(NSString *)xNosToken{
    return [NOSVcloudHttpManager sharedInstance].xNosToken;
}

-(NSString *)bucketName{
    return [NOSVcloudHttpManager sharedInstance].bucketName;
}

-(NSString *)objectName{
    return [NOSVcloudHttpManager sharedInstance].objectName;
}

-(void)fileUploadInit:(NSString *)originFileName
         userFileName:(NSString *)userFileName
               typeId:(NSString *)typeId
             presetId:(NSString *)presetId
    uploadCallbackUrl:(NSString *)uploadCallbackUrl
          callbackUrl:(NSString *)callbackUrl
          description:(NSString *)description
          watermarkId:(NSString *)watermarkId
          userDefInfo:(NSString *)userDefInfo
              success:(NOSUploadRequestSuccess)success
                 fail:(NOSUploadRequestFail)fail
{
    [[NOSVcloudHttpManager sharedInstance] fileUploadInit:originFileName userFileName:userFileName typeId:typeId presetId:presetId uploadCallbackUrl:uploadCallbackUrl callbackUrl:callbackUrl description:description watermarkId:watermarkId userDefInfo:userDefInfo success:^(NOSAFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } fail:^(NOSAFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

-(void)videoQuery:(NSArray *)list success:(NOSUploadRequestSuccess)success fail:(NOSUploadRequestFail)fail
{
    [[NOSVcloudHttpManager sharedInstance] videoQuery:list success:^(NOSAFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } fail:^(NOSAFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

-(void)uploadSetCallBack:(NSString *)callbackUrl success:(NOSUploadRequestSuccess)success fail:(NOSUploadRequestFail)fail{
    [[NOSVcloudHttpManager sharedInstance] uploadSetCallBack:callbackUrl success:^(NOSAFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } fail:^(NOSAFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}
//=========================================================================
+ (void)initialize {
    globalConf = [[NOSConfig alloc] init];
    bucketLbsMap = [[NOSBucketLBSMap alloc] init];
}

+ (void)setGlobalConf:(NOSConfig*) conf {
    globalConf = conf;
}

+ (NOSConfig*) globalConf {
    return globalConf;
}

+ (NOSStatTimeTask*) statTimeTask {
    return statTimeTask;
}

+ (NOSLbsTask*) lbsTask {
    return lbsTask;
}

+ (NOSBucketLBSMap*) bucketLbsMap; {
    return bucketLbsMap;
}
//=========================================================================
- (instancetype)init {
    return [self initWithRecorder:nil recorderKeyGenerator:nil];
}

- (instancetype)initWithRecorder:(id <NOSRecorderDelegate> )recorder {
    return [self initWithRecorder:recorder recorderKeyGenerator:nil];
}

- (instancetype)initWithRecorder:(id <NOSRecorderDelegate> )recorder
            recorderKeyGenerator:(NOSRecorderKeyGenerator)recorderKeyGenerator {
	if (self = [super init]) {
		_httpManager = [[NOSHttpManager alloc] init];
		_recorder = recorder;
		_recorderKeyGen = recorderKeyGenerator;
        
        NOSLbsCompletionHandler lbsCompletionHandler = ^(NSDictionary *resp, long long lbsUseTime,
                                                         NSInteger lbsHttpCode, NSInteger lbsSucc, NSString *bucketname) {
            NSString *lbsIP = nil;
            NSArray *uploaderHosts = nil;
            NOSLbsInfo *lbsInfo = [bucketLbsMap lbsInfoSnapshot:bucketname];
            
            if (!lbsInfo) {
                lbsInfo = [[NOSLbsInfo alloc] init];
            }
            
            if (resp) {
                lbsIP = [resp valueForKey:@"lbs"];
                uploaderHosts = [resp valueForKey:@"upload"];
                lbsInfo.lbsIP = lbsIP;
                lbsInfo.uploaderHosts = uploaderHosts;
                lbsInfo.lastModified = [NOSTimeUtils currentMil];
            }
            
            lbsInfo.lbsUseTime = lbsUseTime;
            lbsInfo.lbsSucc = lbsSucc;
            lbsInfo.lbsHttpCode = lbsHttpCode;
            lbsInfo.hasPushed = YES;
            //if (net) lbsInfo.net = net;
            
            [bucketLbsMap addLbsInfo:lbsInfo forBucket:bucketname];
            
        };
        
        // start lbs 初始化回调
        lbsTask = [[NOSLbsTask alloc] initWithCompleteHandler:lbsCompletionHandler];
        
        //start 监听网络
        lbsNetMonitorTask = [NOSLbsNetMonitorTask
                             sharedInstanceAndRunWithCompleteHandler:lbsCompletionHandler];
        
        // start 统计
        statTimeTask = [NOSStatTimeTask sharedInstanceAndRun];
	}
	return self;
}

+ (instancetype)sharedInstanceWithRecorder:(id <NOSRecorderDelegate> )recorder
                      recorderKeyGenerator:(NOSRecorderKeyGenerator)recorderKeyGenerator {
	static NOSUploadManager *sharedInstance = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    sharedInstance = [[self alloc] initWithRecorder:recorder
                                   recorderKeyGenerator:recorderKeyGenerator
                                             ];
	});

	return sharedInstance;
}

+ (BOOL)checkAndNotifyError:(NSString *)bucket
                        key:(NSString *)key
                      token:(NSString *)token
                       data:(NSData *)data
                       file:(NSString *)file
                   complete:(NOSUpCompletionHandler)completionHandler {
	NSString *desc = nil;
	if (completionHandler == nil) {
		@throw [NSException exceptionWithName:NSInvalidArgumentException
		                               reason:@"no completionHandler" userInfo:nil];
		return YES;
	}
    if (!bucket || [bucket length] < 1 || !key || [key length] < 1) {
        desc = @"bucket or key is empty";
    }
	if (data == nil && file == nil) {
		desc = @"no input data";
	}
	else if (token == nil || [token isEqualToString:@""]) {
		desc = @"no token";
	}
	if (desc != nil) {
		NOSAsyncRun ( ^{
		    completionHandler([NOSResponseInfo responseInfoWithInvalidArgument:desc], key, nil);
		});
		return YES;
	}
	return NO;
}

- (void)putFileByHttp:(NSString *)filePath
               bucket:(NSString*)bucket
                  key:(NSString *)key
                token:(NSString *)token
             complete:(NOSUpCompletionHandler)completionHandler
               option:(NOSUploadOption *)option {
    [self putFile:filePath
         protocal:@"http"
           bucket:bucket
              key:key
            token:token
         complete:completionHandler
           option:option];
}

- (void)putFileByHttps:(NSString *)filePath
                bucket:(NSString*)bucket
                   key:(NSString *)key
                 token:(NSString *)token
              complete:(NOSUpCompletionHandler)completionHandler
                option:(NOSUploadOption *)option {
    [self putFile:filePath
         protocal:@"https"
           bucket:bucket
              key:key
            token:token
         complete:completionHandler
           option:option];
    
}

- (void)putFile:(NSString *)filePath
       protocal:(NSString *)protocal
         bucket:(NSString *)bucket
            key:(NSString *)key
          token:(NSString *)token
       complete:(NOSUpCompletionHandler)completionHandler
         option:(NOSUploadOption *)option {
             if ([NOSUploadManager checkAndNotifyError:bucket key:key token:token data:nil file:filePath complete:completionHandler]) {
		return;
	}

	@autoreleasepool {
		NSError *error = nil;
		NSDictionary *fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];

		if (error) {
			NOSAsyncRun ( ^{
			    NOSResponseInfo *info = [NOSResponseInfo responseInfoWithFileError:error];
			    completionHandler(info, key, nil);
			});
			return;
		}

		NSNumber *fileSizeNumber = fileAttr[NSFileSize];
		UInt32 fileSize = [fileSizeNumber intValue];
		NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
		if (error) {
			NOSAsyncRun ( ^{
			    NOSResponseInfo *info = [NOSResponseInfo responseInfoWithFileError:error];
			    completionHandler(info, key, nil);
			});
			return;
		}

		NOSUpCompletionHandler complete = ^(NOSResponseInfo *info, NSString *key, NSDictionary *resp)
		{
			completionHandler(info, key, resp);
		};

		NSDate *modifyTime = fileAttr[NSFileModificationDate];
		NSString *recorderKey = key;
		if (_recorder != nil && _recorderKeyGen != nil) {
			recorderKey = _recorderKeyGen(key, filePath);
		}

		NOSResumeUpload *up = [[NOSResumeUpload alloc]
                               initWithData:data
                               withSize:fileSize
                               withProtocal:protocal
                               withBucket:bucket
                               withKey:key
                               withToken:token
                               withCompletionHandler:complete
                               withOption:option
                               withModifyTime:modifyTime
                               withRecorder:_recorder
                               withRecorderKey:recorderKey
                               withHttpManager:_httpManager];
		NOSAsyncRun ( ^{
		    [up run];
		});
	}
}

@end
