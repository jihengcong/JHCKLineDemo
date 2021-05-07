//
//  JHCKLineMainRender.h
//  JHCKLineDemo
//
//  Created by mac on 2020/12/29.
//

#import "JHCKLineBaseRender.h"
#import "JHCConstant.h"
#import "JHCColors.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * K线主图绘制
 */
@interface JHCKLineMainRender : JHCKLineBaseRender

- (instancetype)initWithMaxValue:(CGFloat)maxValue
                        minValue:(CGFloat)minValue
                     candleWidth:(CGFloat)candleWidth
                      topPadding:(CGFloat)topPadding
                       klineRect:(CGRect)klineRect
                         isTimeLine:(BOOL)isTimeLine
                       mainState:(JHCKLineMainState)mainState;

@end

NS_ASSUME_NONNULL_END
