//
//  JHCKLineVolRender.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/29.
//

#import "JHCKLineVolRender.h"
#import "JHCConstant.h"
#import "JHCColors.h"


@implementation JHCKLineVolRender

// 重写父类，绘制网格
- (void)drawGrid:(CGContextRef)context gridRows:(NSUInteger)gridRows gridColums:(NSUInteger)gridColums
{
    CGContextSetStrokeColorWithColor(context, JHCKLineColors_gridColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGFloat columsSpace = self.klineRect.size.width / gridColums;
    for (int index = 0;  index < gridColums; index++)
    {
        CGContextMoveToPoint(context, index * columsSpace, 0);
        CGContextAddLineToPoint(context, index * columsSpace, CGRectGetMaxY(self.klineRect));
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    CGContextAddRect(context, self.klineRect);
    CGContextDrawPath(context, kCGPathStroke);
    
}

// 重写父类，绘制K线
- (void)drawChart:(CGContextRef)context lastModel:(JHCKLineModel *)lastModel currentModel:(JHCKLineModel *)currentModel currentX:(CGFloat)currentX
{
    [self drawVol:context currentModel:currentModel currentX:currentX];
    
    if (lastModel)
    {
        if (currentModel.MA5Volume.doubleValue != 0) {
            [self drawLine:context lastValue:lastModel.MA5Volume.doubleValue currentValue:currentModel.MA5Volume.doubleValue currentX:currentX color:JHCKLineColors_ma5Color];
        }
        if (currentModel.MA10Volume.doubleValue != 0) {
            [self drawLine:context lastValue:lastModel.MA10Volume.doubleValue currentValue:currentModel.MA10Volume.doubleValue currentX:currentX color:JHCKLineColors_ma10Color];
        }
    }
}

- (void)drawVol:(CGContextRef)context currentModel:(JHCKLineModel *)currentModel currentX:(CGFloat)currentX
{
    CGFloat top = [self getY:currentModel.Vol.doubleValue];
    CGContextSetLineWidth(context, self.candleWidth);
    if (currentModel.Close.doubleValue > currentModel.Open.doubleValue) {
        CGContextSetStrokeColorWithColor(context, JHCKLineColors_upColor.CGColor);
    } else {
        CGContextSetStrokeColorWithColor(context, JHCKLineColors_dnColor.CGColor);
    }
    CGContextMoveToPoint(context, currentX, CGRectGetMaxY(self.klineRect));
    CGContextAddLineToPoint(context, currentX, top);
    CGContextDrawPath(context, kCGPathStroke);
}

// 重写父类，绘制顶部文字
- (void)drawTopText:(CGContextRef)context currentModel:(JHCKLineModel *)currentModel
{
    NSMutableAttributedString *topAttributeText = [[NSMutableAttributedString alloc] init];
    if (currentModel.Vol.doubleValue > 0)
    {
        NSString *str = [NSString stringWithFormat:@"VOL:%@   ", [self volFormat:currentModel.Vol.doubleValue]];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize],NSForegroundColorAttributeName: JHCKLineColors_volColor}];
        [topAttributeText appendAttributedString:attr];
    }
    if (currentModel.MA5Volume.doubleValue > 0)
    {
        NSString *str = [NSString stringWithFormat:@"MA5:%@    ", [self volFormat:currentModel.MA5Volume.doubleValue]];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize],NSForegroundColorAttributeName: JHCKLineColors_ma5Color}];
        [topAttributeText appendAttributedString:attr];
    }
    if (currentModel.MA10Volume.doubleValue > 0)
    {
        NSString *str = [NSString stringWithFormat:@"MA10:%@   ",[self volFormat:currentModel.MA10Volume.doubleValue]];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize],NSForegroundColorAttributeName: JHCKLineColors_ma10Color}];
        [topAttributeText appendAttributedString:attr];
    }
    [topAttributeText drawAtPoint:CGPointMake(5, CGRectGetMinY(self.klineRect))];
}

// 重写父类, 绘制右侧文字
- (void)drawRightText:(CGContextRef)context gridRows:(NSUInteger)gridRows gridColums:(NSUInteger)gridColums
{
    NSString *text = [self volFormat:self.maxValue];
    CGRect rect = [JHCKLineTheme getRectWithString:text font:[UIFont systemFontOfSize:JHCKLineStyle_reightTextSize]];
    [self drawText:text atPoint:CGPointMake(self.klineRect.size.width - rect.size.width, CGRectGetMinY(self.klineRect)) fontSize:JHCKLineStyle_reightTextSize textColor:JHCKLineColors_rightTextColor];
}

@end
