//
//  NOSUploader.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/16.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NOSRecorderDelegate.h"
#import "NOSConfig.h"

@class NOSResponseInfo;
@class NOSUploadOption;


@protocol NOSUploadRequestDelegate <NSObject>
/**
 *  开发者平台分配的AppKey
 */
-(NSString *)NOSUploadAppKey;
/**
 服务器认证需要，视频云用户创建的其子用户id
 */
-(NSString *)NOSVcloudAppAccid;
/**
 视频云用户子用户的token
 */
-(NSString *)NOSVcloudAppToken;
@end

/**
 *  请求成功回调
 *
 *  @param responseObject 返回结果
 */
typedef void (^NOSUploadRequestSuccess)(id responseObject);
/**
 *  请求失败回调
 *
 *  @param error  错误信息
 */
typedef void (^NOSUploadRequestFail)(NSError *error);

/**
 *    上传完成后的回调函数
 *
 *    @param info 上下文信息，包括状态码，错误值
 *    @param key  上传时指定的key，原样返回
 *    @param resp 上传成功会返回文件信息，失败为nil; 可以通过此值是否为nil 判断上传结果
 */
typedef void (^NOSUpCompletionHandler)(NOSResponseInfo *info, NSString *key, NSDictionary *resp);

/**
 *    为持久化上传记录，根据上传的key以及文件名 生成持久化的记录key
 *
 *    @param uploadKey 上传的key
 *    @param filePath  文件名
 *
 *    @return 根据uploadKey, filepath 算出的记录key
 */
typedef NSString *(^NOSRecorderKeyGenerator)(NSString *uploadKey, NSString *filePath);

/**
   管理上传的类，可以生成一次，持续使用，不必反复创建。
 */
@interface NOSUploadManager : NSObject
@property(nonatomic, weak) id<NOSUploadRequestDelegate> delegate;
/**
 *  上传凭证
 */
@property(nonatomic,strong,readonly) NSString *xNosToken;
/**
 *  存储上传文件的桶名
 */
@property(nonatomic,strong,readonly) NSString *bucketName;
/**
 *  存储上传文件的对象名
 */
@property(nonatomic,strong,readonly) NSString *objectName;

/**
 *    默认构造方法，没有持久化记录
 *
 *    @return 上传管理类实例
 */
- (instancetype)init;

/**
 *    使用一个持久化的记录接口进行记录的构造方法
 *
 *    @param recorder 持久化记录接口实现
 *
 *    @return 上传管理类实例
 */
- (instancetype)initWithRecorder:(id <NOSRecorderDelegate> )recorder;

/**
 *    使用持久化记录接口以及持久化key生成函数的构造方法，默认情况下使用上传存储的key, 如果key为nil或者有特殊字符比如/，建议使用自己的生成函数
 *
 *    @param recorder             持久化记录接口实现
 *    @param recorderKeyGenerator 持久化记录key生成函数
 *
 *    @return 上传管理类实例
 */
- (instancetype)initWithRecorder:(id <NOSRecorderDelegate> )recorder
            recorderKeyGenerator:(NOSRecorderKeyGenerator)recorderKeyGenerator;

/**
 *    方便使用的单例方法
 *
 *    @param recorder             持久化记录接口实现
 *    @param recorderKeyGenerator 持久化记录key生成函数
 *
 *    @return 上传管理类实例
 */
+ (instancetype)sharedInstanceWithRecorder:(id <NOSRecorderDelegate> )recorder
                      recorderKeyGenerator:(NOSRecorderKeyGenerator)recorderKeyGenerator;

/**
 *    用http上传文件
 *
 *    @param filePath          文件路径
 *    @param bucket            上传到云存储的bucket
 *    @param key               上传到云存储的key
 *    @param token             上传需要的token, 由服务器生成
 *    @param completionHandler 上传完成后的回调函数
 *    @param option            上传时传入的可选参数
 */
- (void)putFileByHttp:(NSString *)filePath
         bucket:(NSString*)bucket
            key:(NSString *)key
          token:(NSString *)token
       complete:(NOSUpCompletionHandler)completionHandler
         option:(NOSUploadOption *)option;

/**
 *    用https上传文件
 *
 *    @param filePath          文件路径
 *    @param bucket            上传到云存储的bucket
 *    @param key               上传到云存储的key
 *    @param token             上传需要的token, 由服务器生成
 *    @param completionHandler 上传完成后的回调函数
 *    @param option            上传时传入的可选参数
 */
- (void)putFileByHttps:(NSString *)filePath
               bucket:(NSString*)bucket
                  key:(NSString *)key
                token:(NSString *)token
             complete:(NOSUpCompletionHandler)completionHandler
               option:(NOSUploadOption *)option;

/**
 *    configuration is global
 */
+ (void)setGlobalConf:(NOSConfig*) conf;

/**
 *  文件上传初始化接口:用于获取xNosToken（上传凭证）、bucket（存储对象的桶名）、object（生成的唯一对象名）
 *
 *  @param originFileName    上传文件的原始名称（包含后缀名）
 *  @param userFileName      用户命名的上传文件名称
 *  @param typeId            视频所属的类别Id（不填写为默认分类）
 *  @param presetId          视频所需转码模板Id（不填写为默认模板，默认模板不进行转码）
 *  @param uploadCallbackUrl 上传成功后回调客户端的URL地址（需标准http格式）
 *  @param callbackUrl       转码成功后回调客户端的URL地址（需标准http格式）
 *  @param description       上传视频的描述信息
 *  @param watermarkId       视频水印Id（不填写为不添加水印，如果选择，
 请务必在水印管理中提前完成水印图片的上传和参数的配置；
 且必需设置prestId字段，且presetId字段不为默认模板）
 *  @param userDefInfo       用户自定义信息，回调会返回此信息
 */
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
                 fail:(NOSUploadRequestFail)fail;
/**
 *  上传完成根据对象名查询视频或水印图片主Id
 *
 *  @param list 上传文件的对象名列表
 */
-(void)videoQuery:(NSArray *)list success:(NOSUploadRequestSuccess)success fail:(NOSUploadRequestFail)fail;
///**
// *  设置上传回调地址接口
// *
// *  @param callbackUrl 上传成功后回调客户端的URL地址
// */
//-(void)uploadSetCallBack:(NSString *)callbackUrl success:(NOSUploadRequestSuccess)success fail:(NOSUploadRequestFail)fail;

@end
