# 视频云点播上传IOS-SDK 说明

## 1 简介

IOS-SDK 是用于移动端点播上传的软件开发工具包，提供简单、便捷的方法，方便用户开发上传视频或图片文件的功能。

## 2 功能特性

- 文件上传
- 获取进度
- 断点续传
- 查询视频


## 3 开发准备

### 3.1 下载地址

[ios sdk 的源码地址](https://github.com/vcloud163/objc-sdk "ios sdk 的源码地址")

### 3.2 环境准备

- 推荐使用xcoce 7及以上版本开发。
- 通过管理控制台->账户信息获取 AppKey ，Accid ，Token。
- 下载 ios sdk，如果安装了 git 命令行，执行 `git clone https://github.com/vcloud163/objc-sdk` 或者直接在 github 下载。
- 参照 API 说明和 sdk 中提供的 demo，开发代码。

### 3.3 sdk 依赖包

- libz.tbd

### 3.4 https 支持

默认使用 https 协议，如需修改在 Info.plist中增加NSAppTransportSecurity 中的NSAllowsArbitraryLoads为true，支持http。

## 4 使用说明

### 4.1 初始化

接入视频云点播，需要拥有一对有效的 AppKey 和 Accid ，Token 进行签名认证，可通过如下步骤获得：

- 开通视频云点播服务；
- 登陆视频云开发者平台，通过管理控制台->账户信息获取 AppKey ，Accid ，Token。

在获取到 AppKey 和 Accid ，Token 之后，可按照如下方式进行初始化：

-(NSString *)NOSUploadAppKey{
    return kNOSTestAppKey;
}

-(NSString *)NOSVcloudAppAccid{
    return kNOSTestAccid;
}

-(NSString *)NOSVcloudAppToken{
    return kNOSTestToken;
}

### 4.2 文件上传

视频云点播在全国各地覆盖大量上传节点，会选择适合用户的最优节点进行文件上传，并根据用户传入的参数做不同处理。

以下是使用示例：

    //文件上传
    if (isHttps) {
        [upManager putFileByHttps: localFileName bucket:bucket key:object
                            token: token
                         complete: ^(NOSResponseInfo *info, NSString *key, NSDictionary *resp) {
                             NSLog(@"上传完成~~");
                             NSLog(@"%@", info);
                             NSLog(@"%@", resp);
                         }
                           option: option];
    } else {
        [upManager putFileByHttp: localFileName bucket:bucket key:object
                           token: token
                        complete: ^(NOSResponseInfo *info, NSString *key, NSDictionary *resp) {
                            NSLog(@"上传完成~~");
                            NSLog(@"%@", info);
                            NSLog(@"%@", resp);
                        }
                          option: option];
    }


**注：具体使用示例详见 sdk 包中 ViewController 类文件。**

### 4.3 查询进度

视频云点播文件上传采用分片处理，可通过以下方法查询上传完成的文件进度。

以下是使用示例：

	//可选参数集合:上传进度回调
    NOSUploadOption *option = [[NOSUploadOption alloc] initWithMime: @"image/jpeg"
                                                    progressHandler: ^(NSString *key, float percent) {
                                                        NSLog(@"current progress:%f", percent);
                                                    }
                                                              metas: nil
                                                 cancellationSignal: ^BOOL{
                                                     return cancelUpload;
                                                 }];

**注：具体使用示例详见 sdk 包中 ViewController 类文件。**

### 4.4 断点续传

在上传文件中，视频云点播通过唯一标识 context 标识正在上传的文件，可通过此标识获取到已经上传视频云的文件字节数。通过此方法可实现文件的断点续传。

为防止服务中止造成文件上传信息丢失，可通过在本地存储文件信息来记录断点信息，当服务重新启动，可根据文件继续上传文件。临时文件会在上传完成后删除记录。

以下是使用示例：

	//创建断点续传目录并记录
    NOSFileRecorder *file = [NOSFileRecorder fileRecorderWithFolder:dir error:&error];
    //配置基于位置服务的参数
    NOSConfig *conf = [[NOSConfig alloc] initWithLbsHost: @"http://wanproxy.127.net"
                                           withSoTimeout: [_soTimeoutText.text intValue]
                       //withConnectionTimeout: [_connectTimeoutText.text intValue]
                                     withRefreshInterval: [_monitorInterval.text intValue]
                                           withChunkSize: [_chunkSizeText.text intValue] * 1024
                                     withMoniterInterval: [_monitorInterval.text intValue]
                                          withRetryCount: [_retryCountText.text intValue]];
    //将其设置为全局变量
    [NOSUploadManager setGlobalConf:conf];
    
    if (error) {
        NSLog(@"%@", error);
    }
    //实例化上传管理类
    upManager = [NOSUploadManager sharedInstanceWithRecorder: (id<NOSRecorderDelegate>)file
                                        recorderKeyGenerator: nil];
    //设置上传管理类的delegate
    upManager.delegate = self;

**注：具体使用示例详见 sdk 包中 ViewController 类文件。**

### 4.5 查询视频

视频上传成功后，可通过主动查询的方式获取到视频唯一标识，支持批量查询。

以下是使用示例：

	//上传完成根据对象名查询视频或水印图片主Id
    [upManager videoQuery:[NSArray arrayWithObjects:upManager.objectName, nil] success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];

**注：具体使用示例详见 sdk 包中 ViewController 类文件。**



## 5 版本更新记录

**v1.0.0**

1. IOS SDK 的初始版本，提供点播上传的基本功能。包括：文件上传、获取进度、断点续传、查询视频。

