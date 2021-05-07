//
//  JHCNetServerConfig.m
//  btex
//
//  Created by mac on 2020/4/9.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import "JHCNetServerConfig.h"


static NSString *ConfigEnv = @"";

@implementation JHCNetServerConfig

/**
 * 配置环境参数
 * 00~正式环境          01~预生产             02~测试环境
 */
+ (void)setConfigEnv:(NSString *)value
{
    ConfigEnv = value;
}

/**
 * 获取Api接口服务器地址
 */
+ (NSString *)getServerURL
{
    return [self generateNativeApiServer];
}

/**
 * 获取H5服务器地址
 */
+ (NSString *)getH5ServerURL
{
    if([ConfigEnv isEqualToString:@"00"]){
        // 正式环境
        return @"";
    }else if ([ConfigEnv isEqualToString:@"01"]){
        // 预生产环境
        return @"";
    } else if ([ConfigEnv isEqualToString:@"02"]){
        // 测试环境
        return @"";
    }
    return @"";
}

#pragma mark - 私有方法
/**
 * 生成Native服务器地址
 */
+ (NSString *)generateNativeApiServer
{
    if([ConfigEnv isEqualToString:@"00"]){
        // 正式环境
        return @"";
    }else if ([ConfigEnv isEqualToString:@"01"]){
        // 预生产环境
        return @"";
    }else if ([ConfigEnv isEqualToString:@"02"]){
        // 测试环境
        return @"";
    }
    return @"";
}

@end
