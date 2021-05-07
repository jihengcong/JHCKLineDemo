//
//  JHCKLineSecondaryRender.h
//  JHCKLineDemo
//
//  Created by mac on 2020/12/29.
//

#import "JHCKLineBaseRender.h"
#import "JHCConstant.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * K线副图绘制
 */
@interface JHCKLineSecondaryRender : JHCKLineBaseRender

- (instancetype)initWithMaxValue:(CGFloat)maxValue
                        minValue:(CGFloat)minValue
                     candleWidth:(CGFloat)candleWidth
                      topPadding:(CGFloat)topPadding
                       klineRect:(CGRect)klineRect
                  secondaryState:(JHCKLineSecondaryState)secondaryState;

@end

NS_ASSUME_NONNULL_END
