//
//  NOSResumeUpload.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/11.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOSUploadManager.h"

@class NOSHttpManager;
@interface NOSResumeUpload : NSObject
/**
 *  初始化上传数据
 *
 *  @param data        上传数据
 *  @param size        数据大小
 *  @param protocal    上传协议http/https
 *  @param bucket      桶名
 *  @param key         唯一key
 *  @param token       上传凭证token
 *  @param block       上传完成后的回调函数
 *  @param option      可选参数集合
 *  @param time        最后修改时间
 *  @param recorder    持久化记录
 *  @param recorderKey 持久化记录key
 *  @param http        上传实例
 *
 *  @return NOSResumeUpload
 */
- (instancetype)initWithData:(NSData *)data
                    withSize:(UInt32)size
                withProtocal:(NSString *)protocal
                  withBucket:(NSString *)bucket
                     withKey:(NSString *)key
                   withToken:(NSString *)token
       withCompletionHandler:(NOSUpCompletionHandler)block
                  withOption:(NOSUploadOption *)option
              withModifyTime:(NSDate *)time
                withRecorder:(id <NOSRecorderDelegate> )recorder
             withRecorderKey:(NSString *)recorderKey
             withHttpManager:(NOSHttpManager *)http;
/**
 *  运行上传
 */
- (void)run;

@end
