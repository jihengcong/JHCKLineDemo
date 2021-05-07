//
//  JHCKLineSecondaryRender.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/29.
//

#import "JHCKLineSecondaryRender.h"
#import "JHCKLineTheme.h"
#import "JHCColors.h"
#import "NSString+JHCDigit.h"


@interface JHCKLineSecondaryRender ()

@property (nonatomic, assign) JHCKLineSecondaryState secondaryState;
@property (nonatomic, assign) CGFloat MACDWidth;

@end

@implementation JHCKLineSecondaryRender

- (instancetype)initWithMaxValue:(CGFloat)maxValue
                        minValue:(CGFloat)minValue
                     candleWidth:(CGFloat)candleWidth
                      topPadding:(CGFloat)topPadding
                       klineRect:(CGRect)klineRect
                  secondaryState:(JHCKLineSecondaryState)secondaryState
{
    self = [super initWithMaxValue:maxValue minValue:minValue candleWidth:candleWidth topPadding:topPadding klineRect:klineRect];
    if (self)
    {
        _secondaryState = secondaryState;
        _MACDWidth = 5;
    }
    return self;
}

// 重写父类，绘制网格
- (void)drawGrid:(CGContextRef)context gridRows:(NSUInteger)gridRows gridColums:(NSUInteger)gridColums
{
    CGContextSetStrokeColorWithColor(context, JHCKLineColors_gridColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGFloat columSpace = self.klineRect.size.width / gridColums;
    for (int index = 0; index < gridColums; index ++)
    {
        CGContextMoveToPoint(context, index * columSpace, 0);
        CGContextAddLineToPoint(context, index * columSpace, CGRectGetMaxY(self.klineRect));
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    CGContextAddRect(context, self.klineRect);
    CGContextDrawPath(context, kCGPathStroke);
}

// 重写父类
- (void)drawChart:(CGContextRef)context lastModel:(JHCKLineModel *)lastModel currentModel:(JHCKLineModel *)currentModel currentX:(CGFloat)currentX
{
    if (_secondaryState == JHCKLineSecondaryState_MACD)
    {
        [self drawMACD:context lastModel:lastModel currentModel:currentModel currentX:currentX];
    }
    else if (_secondaryState == JHCKLineSecondaryState_KDJ)
    {
        if (lastModel)
        {
            if (currentModel.K.doubleValue != 0)
            {
                [self drawLine:context lastValue:lastModel.K.doubleValue currentValue:currentModel.K.doubleValue currentX:currentX color:JHCKLineColors_kColor];
            }
            if (currentModel.D.doubleValue != 0)
            {
                [self drawLine:context lastValue:lastModel.D.doubleValue currentValue:currentModel.D.doubleValue currentX:currentX color:JHCKLineColors_dColor];
            }
            if (currentModel.J.doubleValue != 0)
            {
                [self drawLine:context lastValue:lastModel.J.doubleValue currentValue:currentModel.J.doubleValue currentX:currentX color:JHCKLineColors_jColor];
            }
        }
    }
    else if (_secondaryState == JHCKLineSecondaryState_RSI)
    {
        if (lastModel)
        {
            if (currentModel.RSI.doubleValue != 0)
            {
                [self drawLine:context lastValue:lastModel.RSI.doubleValue currentValue:currentModel.RSI.doubleValue currentX:currentX color:JHCKLineColors_rsiColor];
            }
        }
    }
    else if (_secondaryState == JHCKLineSecondaryState_WR)
    {
        if (lastModel)
        {
            if (currentModel.R.doubleValue != 0)
            {
                [self drawLine:context lastValue:lastModel.R.doubleValue currentValue:currentModel.R.doubleValue currentX:currentX color:JHCKLineColors_rsiColor];
            }
        }
    }
}

// 画线MACD
- (void)drawMACD:(CGContextRef)context lastModel:(JHCKLineModel *)lastModel currentModel:(JHCKLineModel *)currentModel currentX:(CGFloat)currentX
{
    CGFloat maxdY = [self getY:currentModel.MACD.doubleValue];
    CGFloat zeroy = [self getY:0];
    if(currentModel.MACD.doubleValue > 0) {
         CGContextSetStrokeColorWithColor(context, JHCKLineColors_upColor.CGColor);
    } else {
        CGContextSetStrokeColorWithColor(context, JHCKLineColors_dnColor.CGColor);
    }
    CGContextSetLineWidth(context, _MACDWidth);
    CGContextMoveToPoint(context, currentX, maxdY);
    CGContextAddLineToPoint(context, currentX, zeroy);
    CGContextDrawPath(context, kCGPathStroke);
    
    if(lastModel) {
        if(lastModel.dif.doubleValue != 0) {
            [self drawLine:context lastValue:lastModel.dif.doubleValue currentValue:currentModel.dif.doubleValue currentX:currentX color:JHCKLineColors_difColor];
        }
        if(lastModel.dea.doubleValue != 0) {
            [self drawLine:context lastValue:lastModel.dea.doubleValue currentValue:currentModel.dea.doubleValue currentX:currentX color:JHCKLineColors_deaColor];
        }
    }
}

// 重写父类，绘制顶部文字
- (void)drawTopText:(CGContextRef)context currentModel:(JHCKLineModel *)currentModel
{
    NSMutableAttributedString *topAttributeText = [[NSMutableAttributedString alloc] init];
    switch (_secondaryState)
    {
        case JHCKLineSecondaryState_MACD:
        {
            NSString *originStr = @"MACD(12,26,9)   ";
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:originStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_yAxisTextColor}];
            [topAttributeText appendAttributedString:attributeStr];
            
            if (currentModel.MACD.doubleValue != 0)
            {
                NSString *str = [NSString stringWithFormat:@"MACD:%@   ", [NSString getValueStringWithNumber:currentModel.MACD digit:self.priceDigitNum]];
                NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_macdColor}];
                [topAttributeText appendAttributedString:attStr];
            }
            if (currentModel.dif.doubleValue != 0)
            {
                NSString *str = [NSString stringWithFormat:@"DIF:%@   ", [NSString getValueStringWithNumber:currentModel.dif digit:self.priceDigitNum]];
                NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_difColor}];
                [topAttributeText appendAttributedString:attStr];
            }
            if (currentModel.dea.doubleValue != 0)
            {
                NSString *str = [NSString stringWithFormat:@"DEA:%@   ", [NSString getValueStringWithNumber:currentModel.dea digit:self.priceDigitNum]];
                NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_deaColor}];
                [topAttributeText appendAttributedString:attStr];
            }
        }
            break;
        case JHCKLineSecondaryState_KDJ:
        {
            NSString *originStr = @"KDJ(14,1,3)   ";
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:originStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_yAxisTextColor}];
            [topAttributeText appendAttributedString:attributeStr];
            
            if (currentModel.K.doubleValue != 0)
            {
                NSString *str = [NSString stringWithFormat:@"K:%@   ", [NSString getValueStringWithNumber:currentModel.K digit:self.priceDigitNum]];
                NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_kColor}];
                [topAttributeText appendAttributedString:attStr];
            }
            if (currentModel.D.doubleValue != 0)
            {
                NSString *str = [NSString stringWithFormat:@"D:%@   ", [NSString getValueStringWithNumber:currentModel.D digit:self.priceDigitNum]];
                NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_dColor}];
                [topAttributeText appendAttributedString:attStr];
            }
            if (currentModel.J.doubleValue != 0)
            {
                NSString *str = [NSString stringWithFormat:@"J:%@   ", [NSString getValueStringWithNumber:currentModel.J digit:self.priceDigitNum]];
                NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_jColor}];
                [topAttributeText appendAttributedString:attStr];
            }
        }
            break;
        case JHCKLineSecondaryState_RSI:
        {
            NSString *originStr = [NSString stringWithFormat:@"RSI(14):%@   ", [NSString getValueStringWithNumber:currentModel.RSI digit:self.priceDigitNum]];
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:originStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_rsiColor}];
            [topAttributeText appendAttributedString:attributeStr];
        }
            break;
        case JHCKLineSecondaryState_WR:
        {
            NSString *originStr = [NSString stringWithFormat:@"WR(14):%@   ", [NSString getValueStringWithNumber:currentModel.R digit:self.priceDigitNum]];
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:originStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_wrColor}];
            [topAttributeText appendAttributedString:attributeStr];
        }
            break;
        default:
            break;
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
