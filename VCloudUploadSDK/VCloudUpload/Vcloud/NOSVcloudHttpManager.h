//
//  NOSVcloudHttpManager.h
//  NOSSDK
//
//  Created by taojinliang on 16/8/22.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOSAFNetworking.h"


@protocol NOSVcloudRequestDelegate <NSObject>
//开发者平台分配的AppKey
-(NSString *)NOSVcloudAppKey;
//服务器认证需要，视频云用户创建的其子用户id
-(NSString *)NOSVcloudAppAccid;
//视频云用户子用户的token
-(NSString *)NOSVcloudAppToken;
@end

/**
 *  请求成功回调
 *
 *  @param operation
 *  @param responseObject 返回结果
 */
typedef void (^vcHttpSuccess)(NOSAFHTTPRequestOperation *operation, id responseObject);
/**
 *  请求失败回调
 *
 *  @param operation
 *  @param error  错误信息
 */
typedef void (^vcHttpFail)(NOSAFHTTPRequestOperation *operation, NSError *error);

@interface NOSVcloudHttpManager : NSObject
@property(nonatomic, weak) id<NOSVcloudRequestDelegate> delegate;
//上传凭证
@property(nonatomic,strong,readonly) NSString *xNosToken;
//存储上传文件的桶名
@property(nonatomic,strong,readonly) NSString *bucketName;
//存储上传文件的对象名
@property(nonatomic,strong,readonly) NSString *objectName;
/**
 *  视频云请求单例
 *
 *  @return
 */
+(instancetype)sharedInstance;
/**
 *  统一请求接口
 *
 *  @param url     请求地址
 *  @param body    输入参数
 *  @param success 成功回调
 *  @param fail    失败回调
 */
-(void)requestPost:(NSString *)url body:(NSString *)body success:(vcHttpSuccess)success fail:(vcHttpFail)fail;
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
              success:(vcHttpSuccess)success
                 fail:(vcHttpFail)fail;
/**
 *  上传完成根据对象名查询视频或水印图片主Id
 *
 *  @param list 上传文件的对象名列表
 */
-(void)videoQuery:(NSArray *)list success:(vcHttpSuccess)success fail:(vcHttpFail)fail;
/**
 *  设置上传回调地址接口
 *
 *  @param callbackUrl 上传成功后回调客户端的URL地址
 */
-(void)uploadSetCallBack:(NSString *)callbackUrl success:(vcHttpSuccess)success fail:(vcHttpFail)fail;
@end
