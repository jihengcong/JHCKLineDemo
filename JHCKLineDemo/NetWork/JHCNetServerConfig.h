//
//  JHCNetServerConfig.h
//  btex
//
//  Created by mac on 2020/4/9.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCNetServerConfig : NSObject

/**
 * 配置环境参数
 * 00~正式环境          01~预生产             02~测试环境
 */
+ (void)setConfigEnv:(NSString *)value;

/**
 * 获取Api接口服务器地址
 */
+ (NSString *)getServerURL;

/**
 * 获取H5服务器地址
 */
+ (NSString *)getH5ServerURL;


@end

NS_ASSUME_NONNULL_END
