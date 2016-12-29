//
//  VCloudUploadSDKTestTests.m
//  VCloudUploadSDKTestTests
//
//  Created by taojinliang on 16/8/24.
//  Copyright © 2016年 taojinliang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NOSUploadManager.h"
#import "NOSTestConf.h"
#import "NOSFileRecorder.h"
#import "AGAsyncTestHelper.h"

@interface VCloudUploadSDKTestTests : XCTestCase<NOSUploadRequestDelegate>

@end

@implementation VCloudUploadSDKTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSError *error = nil;
    NSString *dir = [NSTemporaryDirectory() stringByAppendingString:@"nos-ios-sdk-test"];
    NSLog(@"%@", dir);
    NOSFileRecorder *file = [NOSFileRecorder fileRecorderWithFolder:dir error:&error];
    
    NOSConfig *conf = [NOSTestConf testNOSConf];
    [NOSUploadManager setGlobalConf:conf];
    
    if (error) {
        NSLog(@"%@", error);
    }
    NOSUploadManager * upManager = [NOSUploadManager sharedInstanceWithRecorder: file
                                        recorderKeyGenerator: nil];
    upManager.delegate = self;
    [upManager fileUploadInit:@"a.mp4" userFileName:nil typeId:nil presetId:nil uploadCallbackUrl:nil callbackUrl:nil description:nil watermarkId:nil userDefInfo:nil  success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    AGWW_WAIT_WHILE(1, 60 * 30);

}

-(NSString *)NOSUploadAppKey{
    return kNOSTestAppKey;
}

-(NSString *)NOSUploadCheckSum{
    return kNOSTestCheckSum;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
