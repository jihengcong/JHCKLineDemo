//
//  JHCKLineMainRender.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/29.
//

#import "JHCKLineMainRender.h"
#import "NSString+JHCDigit.h"


#define kContentPadding  20

@interface JHCKLineMainRender ()

@property (nonatomic, assign) BOOL isTimeLine; // 是否是分时线
@property (nonatomic, assign) JHCKLineMainState mainState;
@property (nonatomic, assign) CGFloat contentPadding;

@end

@implementation JHCKLineMainRender

- (instancetype)initWithMaxValue:(CGFloat)maxValue
                        minValue:(CGFloat)minValue
                     candleWidth:(CGFloat)candleWidth
                      topPadding:(CGFloat)topPadding
                       klineRect:(CGRect)klineRect
                         isTimeLine:(BOOL)isTimeLine
                       mainState:(JHCKLineMainState)mainState
{
    self = [super initWithMaxValue:maxValue minValue:minValue candleWidth:candleWidth topPadding:topPadding klineRect:klineRect];
    if (self)
    {
        _contentPadding = kContentPadding;
        _isTimeLine = isTimeLine;
        _mainState = mainState;
        
        CGFloat diff = maxValue - minValue;
        CGFloat newScaleY = (klineRect.size.height - _contentPadding) / diff;
        CGFloat newDiff = klineRect.size.height / newScaleY;
        CGFloat value = (newDiff - diff) / 2;
        if (newDiff > diff) {
            self.scaleY = newScaleY;
            self.maxValue += value;
            self.minValue -= value;
        }
    }
    return self;
}

// 绘制网格
- (void)drawGrid:(CGContextRef)context gridRows:(NSUInteger)gridRows gridColums:(NSUInteger)gridColums
{
    CGContextSetStrokeColorWithColor(context, JHCKLineColors_gridColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGFloat columsSpace = self.klineRect.size.width / gridColums;
    for (int index = 0; index < gridColums; index ++)
    {
        CGContextMoveToPoint(context, index * columsSpace, 0);
        CGContextAddLineToPoint(context, index * columsSpace, CGRectGetMaxY(self.klineRect));
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    CGFloat rowSpace = self.klineRect.size.height / gridRows;
    for (int index = 0; index < gridRows; index ++)
    {
        CGContextMoveToPoint(context, 0, index * rowSpace + JHCKLineStyle_topPadding);
        CGContextAddLineToPoint(context, CGRectGetMaxX(self.klineRect), index * rowSpace + JHCKLineStyle_topPadding);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    CGContextAddRect(context, self.klineRect);
    CGContextDrawPath(context, kCGPathStroke);
}

// 重写父类方法，绘图
- (void)drawChart:(CGContextRef)context lastModel:(JHCKLineModel *)lastModel currentModel:(JHCKLineModel *)currentModel currentX:(CGFloat)currentX
{
    if (!_isTimeLine) {
        // 画柱状K线数据
        [self drawCandle:context currentModel:currentModel currentX:currentX];
    }
    if (lastModel) {
        if (_isTimeLine)
        {
            // 画分时K线数据
            [self drawTimeKLine:context lastValue:lastModel.Close.doubleValue currentValue:currentModel.Close.doubleValue currentX:currentX];
        }
        else if (_mainState == JHCKLineMainState_MA)
        {
            [self drawMaLine:context lastModel:lastModel currentModel:currentModel currentX:currentX];
        }
        else if (_mainState == JHCKLineMainState_BOLL)
        {
            [self drawBollLine:context lastModel:lastModel currentModel:currentModel currentX:currentX];
        }
    }
}

// 画分时K线数据
- (void)drawTimeKLine:(CGContextRef)context lastValue:(double)lastValue currentValue:(double)currenValue currentX:(CGFloat)currentX
{
    CGFloat x1 = currentX;
    CGFloat y1 = [self getY:currenValue];
    CGFloat x2 = currentX + self.candleWidth + JHCKLineStyle_canldeMargin;
    CGFloat y2 = [self getY:lastValue];
    
    // 分时线线条
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, JHCKLineColors_kLineColor.CGColor);
    CGContextMoveToPoint(context, x1, y1);
    CGContextAddCurveToPoint(context, (x1 + x2) / 2.0, y1,  (x1 + x2) / 2.0, y2, x2, y2);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // 分时线阴影部分
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, x1, CGRectGetMaxY(self.klineRect));
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, x1, y1);
    CGPathAddCurveToPoint(path, &CGAffineTransformIdentity, (x1 + x2) / 2.0, y1, (x1 + x2) / 2.0, y2, x2, y2);
    CGPathAddLineToPoint(path,  &CGAffineTransformIdentity, x2, CGRectGetMaxY(self.klineRect));
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    
    CGContextClip(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0,1};
    NSArray *colors = @[(__bridge id)[JHCKLineTheme colorWithR:0x4c G:0x86 B:0xCD A:1].CGColor, (__bridge id)[JHCKLineTheme colorWithR:0x00 G:0x00 B:0x00 A:0].CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    CGColorSpaceRelease(colorSpace);
    CGPoint start = CGPointMake((x1 + x2) / 2, CGRectGetMinY(self.klineRect));
    CGPoint end = CGPointMake((x1 + x2) / 2, CGRectGetMaxY(self.klineRect));
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    CGContextResetClip(context);
    
    CGColorSpaceRelease(colorSpace);
    CGPathRelease(path);
    CGGradientRelease(gradient);
    
}

// 画柱状K线数据
- (void)drawCandle:(CGContextRef)context currentModel:(JHCKLineModel *)currentModel currentX:(CGFloat)currentX
{
    CGFloat high = [self getY:currentModel.High.doubleValue];
    CGFloat low = [self getY:currentModel.Low.doubleValue];
    CGFloat open = [self getY:currentModel.Open.doubleValue];
    CGFloat close = [self getY:currentModel.Close.doubleValue];
    UIColor *color = open > close ? JHCKLineColors_upColor : JHCKLineColors_dnColor;
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, JHCKLineStyle_candleLineWidth);
    CGContextMoveToPoint(context, currentX, high);
    CGContextAddLineToPoint(context, currentX, low);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, self.candleWidth);
    CGContextMoveToPoint(context, currentX, open);
    CGContextAddLineToPoint(context, currentX, close);
    CGContextDrawPath(context, kCGPathFillStroke);
}

// 画MA线
- (void)drawMaLine:(CGContextRef)context lastModel:(JHCKLineModel *)lastModel currentModel:(JHCKLineModel *)currentModel currentX:(CGFloat)currentX
{
    if(currentModel.MA5Price.doubleValue != 0) {
        [self drawLine:context lastValue:lastModel.MA5Price.doubleValue currentValue:currentModel.MA5Price.doubleValue currentX:currentX color:JHCKLineColors_ma5Color];
    }
//    if(currentModel.MA7Price.doubleValue != 0) {
//        [self drawLine:context lastValue:lastModel.MA7Price.doubleValue currentValue:currentModel.MA7Price.doubleValue currentX:currentX color:JHCKLineColors_ma7Color];
//    }
    if(currentModel.MA10Price.doubleValue != 0) {
        [self drawLine:context lastValue:lastModel.MA10Price.doubleValue currentValue:currentModel.MA10Price.doubleValue currentX:currentX color:JHCKLineColors_ma10Color];
    }
//    if(currentModel.MA20Price.doubleValue != 0) {
//        [self drawLine:context lastValue:lastModel.MA20Price.doubleValue currentValue:currentModel.MA20Price.doubleValue currentX:currentX color:JHCKLineColors_ma20Color];
//    }
    if(currentModel.MA30Price.doubleValue != 0) {
        [self drawLine:context lastValue:lastModel.MA30Price.doubleValue currentValue:currentModel.MA30Price.doubleValue currentX:currentX color:JHCKLineColors_ma30Color];
    }
}

// 画BOOL线
- (void)drawBollLine:(CGContextRef)context lastModel:(JHCKLineModel *)lastModel currentModel:(JHCKLineModel *)currentModel currentX:(CGFloat)currentX
{
    if(currentModel.up.doubleValue != 0) {
        [self drawLine:context lastValue:lastModel.up.doubleValue currentValue:currentModel.up.doubleValue currentX:currentX color:JHCKLineColors_ma5Color];
    }
    if(currentModel.mb.doubleValue != 0) {
        [self drawLine:context lastValue:lastModel.mb.doubleValue currentValue:currentModel.mb.doubleValue currentX:currentX color:JHCKLineColors_ma10Color];
    }
    if(currentModel.dn.doubleValue != 0) {
        [self drawLine:context lastValue:lastModel.dn.doubleValue currentValue:currentModel.dn.doubleValue currentX:currentX color:JHCKLineColors_ma30Color];
    }
}

// 重写父类, 绘制顶部文字
- (void)drawTopText:(CGContextRef)context currentModel:(JHCKLineModel *)currentModel
{
    NSMutableAttributedString *topAttributeText = [[NSMutableAttributedString alloc] init];
    if(currentModel.MA5Price.doubleValue != 0)
    {
        NSString *str = [NSString stringWithFormat:@"MA5:%@   ", [NSString getValueStringWithNumber:currentModel.MA5Price digit:self.priceDigitNum]];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_ma5Color}];
        [topAttributeText appendAttributedString:attr];
    }
//    if(currentModel.MA7Price.doubleValue != 0)
//    {
//        NSString *str = [NSString stringWithFormat:@"MA7:%.2f   ", currentModel.MA7Price.doubleValue];
//        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_ma7Color}];
//        [topAttributeText appendAttributedString:attr];
//    }
    if(currentModel.MA10Price.doubleValue != 0)
    {
        NSString *str = [NSString stringWithFormat:@"MA10:%@    ", [NSString getValueStringWithNumber:currentModel.MA10Price digit:self.priceDigitNum]];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: JHCKLineStyle_defaultTextSize],NSForegroundColorAttributeName: JHCKLineColors_ma10Color}];
        [topAttributeText appendAttributedString:attr];
    }
//    if(currentModel.MA20Price.doubleValue != 0)
//    {
//        NSString *str = [NSString stringWithFormat:@"MA20:%.2f   ", currentModel.MA20Price.doubleValue];
//        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize], NSForegroundColorAttributeName: JHCKLineColors_ma20Color}];
//        [topAttributeText appendAttributedString:attr];
//    }
    if(currentModel.MA30Price.doubleValue != 0)
    {
        NSString *str = [NSString stringWithFormat:@"MA30:%@   ", [NSString getValueStringWithNumber:currentModel.MA30Price digit:self.priceDigitNum]];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: JHCKLineStyle_defaultTextSize],NSForegroundColorAttributeName: JHCKLineColors_ma30Color}];
        [topAttributeText appendAttributedString:attr];
    }
    [topAttributeText drawAtPoint:CGPointMake(5, 6)];
}

// 重写父类, 绘制右侧文字
- (void)drawRightText:(CGContextRef)context gridRows:(NSUInteger)gridRows gridColums:(NSUInteger)gridColums
{
    CGFloat rowSpace = self.klineRect.size.height / (CGFloat)gridRows;
    for (int i = 0; i <= gridRows; i++)
    {
        CGFloat position = 0;
        position = (CGFloat)(gridRows - i) * rowSpace;
        CGFloat value = position / self.scaleY + self.minValue;
        NSString *valueStr = [NSString getValueStringWithCGFloat:value digit:self.priceDigitNum];
        
        CGRect rect = [JHCKLineTheme getRectWithString:valueStr font:[UIFont systemFontOfSize:JHCKLineStyle_reightTextSize]];
        CGFloat y = 0;
        if(i == 0) {
            y = [self getY:value];
        } else {
            y = [self getY:value] - rect.size.height;
        }
        [self drawText:valueStr atPoint:CGPointMake(self.klineRect.size.width - rect.size.width, y) fontSize:JHCKLineStyle_reightTextSize textColor:JHCKLineColors_rightTextColor];
    }
}


- (CGFloat)getY:(CGFloat)value
{
    return self.scaleY * (self.maxValue - value) + CGRectGetMinY(self.klineRect);
}



@end
