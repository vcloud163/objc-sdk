//
//  NOSStatTimeTask.h
//  NOSSDK
//
//  Created by hzzhenghuabin on 2015/1/15.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOSStatisticsItems.h"

//统计时间任务
@interface NOSStatTimeTask : NSObject
//添加一个统计项
- (void) addAnStatItem:(NOSStatisticsItems *)item;
//开启定时刷新统计
+ (instancetype)sharedInstanceAndRun;
@end
