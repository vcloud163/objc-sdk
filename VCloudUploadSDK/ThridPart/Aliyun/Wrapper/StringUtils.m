//
//  NOSMd5.m
//  NOSSDK
//
//  Created by NetEase on 2015/1/19.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "StringUtils.h"
#include <CommonCrypto/CommonDigest.h>

@implementation StringUtil

+ (NSData *)decodeBase64String:(NSString *)base64String {
    // 将 Base64 字符串转换为 NSData
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    return data;
}

+ (NSString *)getSubDomain:(NSString *)host {
    // 分割主机名
    NSArray *components = [host componentsSeparatedByString:@"."];

    // 检查分割后的数组长度
    if ([components count] > 2) {
        // 提取最后三个部分并重新组合
        NSString *subdomain = [NSString stringWithFormat:@"%@.%@.%@", components[components.count - 3], components[components.count - 2], components[components.count - 1]];

        // 打印结果
        NSLog(@"Subdomain: %@", subdomain);
        
        return subdomain;
    } else {
        NSLog(@"Invalid host format.");
    }
    
    return host;
}

@end
