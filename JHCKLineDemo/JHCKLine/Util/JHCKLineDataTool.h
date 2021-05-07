//
//  JHCKLineDataTool.h
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import <Foundation/Foundation.h>
#import "JHCKLineModel.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * K线数据计算工具
 */
@interface JHCKLineDataTool : NSObject

// 计算K线数据，如MA,BOOL,MACD等
+ (void)calculate:(NSArray <JHCKLineModel *> *)dataList;

// 添加最近的model到数据源
+ (void)addLastData:(NSArray <JHCKLineModel *> *)dataList model:(JHCKLineModel *)model;

@end


NS_ASSUME_NONNULL_END
