//
//  NOSMd5.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/19.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject

+ (NSData *)decodeBase64String:(NSString *)base64String;
+ (NSString *)getSubDomain:(NSString *)domain;

@end
