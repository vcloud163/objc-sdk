//
//  NOSVcloudHttpManager.m
//  NOSSDK
//
//  Created by taojinliang on 16/8/22.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NOSVcloudHttpManager.h"
#import "NOSTimeUtils.h"

//200	操作成功
//400	请求报文格式错误，报文构造不正确或者没有完整发送
//700	服务器内部出现错误，请稍后重试或者将完整错误信息发送给客服人员帮忙解决
//710	权限认证失败，请参考文档中的接口鉴权部分
//720	访问失败，余额不足
//721	服务未开通，请前往开通页面申请服务开通
//722	服务开通审核中，请联系客服人员开通服务
//723	请求的次数超过了配额限制
typedef enum{
    RequestSuccess = 200,
    RequestFormatError = 400,
    RequestInternalError = 700,
    RequestPermissionError = 710,
    RequestVisitError = 720,
    RequestServerNotOpenError = 721,
    RequestServerVerifyingError = 722,
    RequestCountMoreError = 723
}RequestState;

#define NOSFORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]


//域名
//static NSString *hostName = @"http://vcloud.163.com";
//测试地址
static NSString *hostName = @"http://106.2.44.248";
//文件上传初始化接口名
static NSString *uploadInit = @"/app/vod/upload/init";
//上传完成根据对象名查询视频或水印图片主Id
static NSString *videoQuery = @"/app/vod/video/query";
//设置上传回调地址接口
static NSString *setCallBack = @"/app/vod/upload/setcallback";


@implementation NOSVcloudHttpManager

+(instancetype)sharedInstance{
    static NOSVcloudHttpManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _xNosToken = @"";
        _bucketName = @"";
        _objectName = @"";
    }
    return self;
}


-(void)requestPost:(NSString *)url body:(NSString *)body success:(vcHttpSuccess)success fail:(vcHttpFail)fail
{
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
//    [mdict setObject:NOSFORMAT(@"%lld",[NOSTimeUtils currentMil])forKey:@"CurTime"];
//    [mdict setObject:NOSFORMAT(@"%d",arc4random()%128) forKey:@"Nonce"];
    [mdict setObject:@"1465723418" forKey:@"CurTime"];
    [mdict setObject:NOSFORMAT(@"%d",1) forKey:@"Nonce"];
    
    [mdict setObject:@"application/json" forKey:@"Content-Type"];
    
    if (_delegate && [_delegate respondsToSelector:@selector(NOSVcloudAppKey)]) {
       [mdict setObject:[_delegate NOSVcloudAppKey] forKey:@"AppKey"];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(NOSVcloudAppAccid)]) {
        [mdict setObject:[_delegate NOSVcloudAppAccid] forKey:@"Accid"];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(NOSVcloudAppToken)]) {
        [mdict setObject:[_delegate NOSVcloudAppToken] forKey:@"Token"];
    }
    
    NSURL *requestUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:mdict];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NOSAFHTTPRequestOperation *httpRequest = [[NOSAFHTTPRequestOperation alloc] initWithRequest:request];
    httpRequest.responseSerializer = [NOSAFJSONResponseSerializer serializer];
    [httpRequest setCompletionBlockWithSuccess:success failure:fail];
    [httpRequest start];
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
              success:(vcHttpSuccess)success
                 fail:(vcHttpFail)fail
{
    NSString *url = [NSString stringWithFormat:@"%@%@",hostName,uploadInit];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (originFileName == nil) {
        return;
    }
    [dict setObject:originFileName forKey:@"originFileName"];
    if (userFileName != nil) {
        [dict setObject:originFileName forKey:@"originFileName"];
    }
    if (typeId != nil) {
        [dict setObject:typeId forKey:@"typeId"];
    }
    if (presetId != nil) {
        [dict setObject:presetId forKey:@"presetId"];
    }
    if (uploadCallbackUrl != nil) {
        [dict setObject:uploadCallbackUrl forKey:@"uploadCallbackUrl"];
    }
    if (callbackUrl != nil) {
        [dict setObject:callbackUrl forKey:@"callbackUrl"];
    }
    if (description != nil) {
        [dict setObject:description forKey:@"description"];
    }
    if (watermarkId != nil) {
        [dict setObject:watermarkId forKey:@"watermarkId"];
    }
    if (userDefInfo != nil) {
        [dict setObject:userDefInfo forKey:@"userDefInfo"];
    }

    //字典转json字符串
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    if (data == nil)
    {
        return;
    }
    NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self requestPost:url body:body success:^(NOSAFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == RequestSuccess) {
            NSDictionary *resDict = [responseObject objectForKey:@"ret"];
            _xNosToken = [resDict objectForKey:@"xNosToken"];
            _bucketName = [resDict objectForKey:@"bucket"];
            _objectName = [resDict objectForKey:@"object"];
        }
        success(operation, responseObject);
    } fail:fail];
}

-(void)videoQuery:(NSArray *)list success:(vcHttpSuccess)success fail:(vcHttpFail)fail
{
    NSString *url = [NSString stringWithFormat:@"%@%@",hostName,videoQuery];
    
    if ([list count] == 0) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:list forKey:@"objectNames"];
    
    //字典数组转json字符串
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    if (data == nil)
    {
        return;
    }
    NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self requestPost:url body:body success:success fail:fail];
}

-(void)uploadSetCallBack:(NSString *)callbackUrl success:(vcHttpSuccess)success fail:(vcHttpFail)fail
{
    NSString *url = [NSString stringWithFormat:@"%@%@",hostName,setCallBack];
    
    if (callbackUrl == nil || [callbackUrl isEqualToString:@""]) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:callbackUrl forKey:@"callbackUrl"];
    
    //字典转json字符串
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    if (data == nil)
    {
        return;
    }
    NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self requestPost:url body:body success:success fail:fail];
}
@end
