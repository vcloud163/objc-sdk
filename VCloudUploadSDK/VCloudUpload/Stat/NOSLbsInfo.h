//
//  NOSLbsInfo.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/23.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

//LBS 基于位置服务
@interface NOSLbsInfo : NSObject
//lbs ip地址
@property (nonatomic) NSString *lbsIP;
//上传主机数组
@property (nonatomic) NSArray *uploaderHosts;
//获取上传加速节点地址：lbs请求时间
@property (nonatomic) long long lbsUseTime;
//获取上传加速节点地址：0为成功，1为失败
@property (nonatomic) NSInteger lbsSucc;
//lbs http状态码
@property (nonatomic) NSInteger lbsHttpCode;
//网络
@property (nonatomic) NSString *net;
//最后修改时间戳
@property (nonatomic) long long lastModified;

@property (nonatomic) BOOL hasPushed;

//初始化
- (instancetype) init;
//克隆复制一个LBS信息对象
- (NOSLbsInfo *) clone;

@end
