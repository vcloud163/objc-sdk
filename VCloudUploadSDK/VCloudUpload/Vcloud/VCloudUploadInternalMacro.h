//
//  VCloudUploadInternalMacro.h
//  VCloudUploadSDK
//
//  Created by taojinliang on 16/8/24.
//  Copyright © 2016年 taojinliang. All rights reserved.
//

#ifndef VCloudUploadInternalMacro_h
#define VCloudUploadInternalMacro_h

//内部使用
#ifdef DEBUG
#ifndef DLog
#define DLog(format, ...) NSLog((format), ##__VA_ARGS__);
#endif
#else
# define DLog(...);
#endif

#endif /* VCloudUploadInternalMacro_h */
