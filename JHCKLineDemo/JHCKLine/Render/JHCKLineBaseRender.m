//
//  JHCKLineBaseRender.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import "JHCKLineBaseRender.h"
#import "JHCConstant.h"
#import "JHCColors.h"
#import "NSString+JHCDigit.h"


@implementation JHCKLineBaseRender

- (void)setPriceDigitNum:(NSInteger)priceDigitNum
{
    _priceDigitNum = priceDigitNum;
}

- (void)setAmountDigitNum:(NSInteger)amountDigitNum
{
    _amountDigitNum = amountDigitNum;
}

/**
 * 创建K线图
 * maxValue: 最大值
 * minValue: 最小值
 * candleWidth: 柱状宽度
 * topPadding: 顶部间隙
 * klineRect: K线的frame
 */
- (instancetype)initWithMaxValue:(CGFloat)maxValue
                        minValue:(CGFloat)minValue
                     candleWidth:(CGFloat)candleWidth
                      topPadding:(CGFloat)topPadding
                       klineRect:(CGRect)klineRect
{
    self = [super init];
    if (self)
    {
        _maxValue = maxValue;
        _minValue = minValue;
        _candleWidth = candleWidth;
        _topPadding = topPadding;
        _klineRect = klineRect;
        
        // Y轴上的每个单位值所占用的尺寸大小
        _scaleY = (klineRect.size.height - topPadding) / (maxValue - minValue);
    }
    return self;
}

/**
 * 绘制背景
 */
- (void)drawBackground:(CGContextRef)context
{
    CGContextClearRect(context, _klineRect);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0, 1};
    NSArray *colors = @[(__bridge id)JHCKLineColors_upShadowColor.CGColor, (__bridge id)JHCKLineColors_downShadowColor.CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint = CGPointMake(_klineRect.size.width / 2, CGRectGetMinY(_klineRect));
    CGPoint endPoint = CGPointMake(_klineRect.size.width / 2, CGRectGetMaxY(_klineRect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextResetClip(context);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

/**
 * 绘制网格
 * gridRows: 行数
 * gridColums: 列数
 */
- (void)drawGrid:(CGContextRef)context
        gridRows:(NSUInteger)gridRows
      gridColums:(NSUInteger)gridColums
{
    
}

/**
 * 绘制右侧文字, 即价格或成交量等
 * gridRows: 行数
 * gridColums: 列数
 */
- (void)drawRightText:(CGContextRef)context
            gridRows:(NSUInteger)gridRows
          gridColums:(NSUInteger)gridColums
{
    
}

/**
 * 绘制顶部文字, 即价格或成交量等
 */
- (void)drawTopText:(CGContextRef)context
       currentModel:(JHCKLineModel *)currentModel
{
    
}

- (void)drawChart:(CGContextRef)context
        lastModel:(JHCKLineModel *)lastModel
     currentModel:(JHCKLineModel *)currentModel
         currentX:(CGFloat)currentX
{
    
}

- (void)drawLine:(CGContextRef)context
       lastValue:(CGFloat)lastValue
    currentValue:(CGFloat)currentValue
        currentX:(CGFloat)currentX
           color:(UIColor *)color
{
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1);
    CGFloat x1 = currentX;
    CGFloat y1 = [self getY:currentValue];
    CGFloat x2 = currentX + _candleWidth + JHCKLineStyle_canldeMargin;
    CGFloat y2 = [self getY:lastValue];
    CGContextMoveToPoint(context, x1, y1);
    CGContextAddLineToPoint(context, x2, y2);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (CGFloat)getY:(CGFloat)value
{
    return _scaleY * (_maxValue - value) + CGRectGetMinY(_klineRect) + _topPadding;
}

//下列提供给子类的工具方法
- (void)drawText:(NSString *)text
         atPoint:(CGPoint)point
        fontSize:(CGFloat)size
       textColor:(UIColor *)color
{
    [text drawAtPoint:point withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size],NSForegroundColorAttributeName: color}];
}

- (NSString *)volFormat:(CGFloat)value
{
    if (value > 10000 && value < 999999) {
         CGFloat d = value / 1000;
         return  [NSString stringWithFormat:@"%.2fK",d];
       } else if (value > 1000000) {
         CGFloat d = value / 1000000;
         return [NSString stringWithFormat:@"%.2fM",d];
       }
//       return [NSString stringWithFormat:@"%.2f",value];
    return [NSString getValueStringWithCGFloat:value digit:self.amountDigitNum];
}


@end
