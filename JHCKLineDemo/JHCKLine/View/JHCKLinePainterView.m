//
//  JHCKLinePainterView.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import "JHCKLinePainterView.h"
#import "JHCKLineMainRender.h"
#import "JHCKLineSecondaryRender.h"
#import "JHCKLineVolRender.h"
#import "NSString+JHCDigit.h"


@interface JHCKLinePainterView ()

@property (nonatomic, assign) double displayHeight;
// 柱状宽度
@property (nonatomic, assign) double candleWidth;

// 主图绘制
@property (nonatomic, strong) JHCKLineMainRender *mainRender; // 主图
@property (nonatomic, strong) JHCKLineVolRender *volRenderer; // 成交量图
@property (nonatomic, strong) JHCKLineSecondaryRender *secondaryRender; // 副图

@property (nonatomic, assign) CGRect mainRect; // 主图frame
@property (nonatomic, assign) CGRect volRect; // 成交量fraem
@property (nonatomic, assign) CGRect secondaryRect; // 副图frame
@property (nonatomic, assign) CGRect dateRect; // 日期frame

@property (nonatomic, assign) NSUInteger startIndex; // 开始的下标
@property (nonatomic, assign) NSUInteger stopIndex; // 结束的下标

@property (nonatomic, assign) NSUInteger mainMaxIndex; // 主图最大值下标
@property (nonatomic, assign) NSUInteger mainMinIndex; // 主图最小值下标

@property (nonatomic, assign) double mainMaxValue; // 主图最大值
@property (nonatomic, assign) double mainMinValue; // 主图最小值

@property (nonatomic, assign) double volMaxValue; // 成交量图最大值
@property (nonatomic, assign) double volMinValue; // 成交量图最小值

@property (nonatomic, assign) double secondaryMaxValue; // 副图最大值
@property (nonatomic, assign) double secondaryMinValue; // 副图最小值

@property (nonatomic, assign) double mainHighMaxValue; // 主图最高值, 用于K线中显示
@property (nonatomic, assign) double mainLowMinValue; // 主图最低值, 用于K线中显示

//var fromat: String = "yyyy-MM-dd"
@property (nonatomic, copy) NSString *format;

@end


@implementation JHCKLinePainterView

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    [self setFrame:self.frame];
//}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//
//    [self setNeedsDisplay];
//}

#pragma mark -- Setter 方法
- (void)setDatas:(NSArray<JHCKLineModel *> *)datas
{
    _datas = datas;
    [self setNeedsDisplay];
}

-(void)setScrollOffsetX:(CGFloat)scrollOffsetX
{
    _scrollOffsetX = scrollOffsetX;
    [self setNeedsDisplay];
}

-(void)setIsTimeLine:(BOOL)isTimeLine
{
    _isTimeLine = isTimeLine;
    [self setNeedsDisplay];
}
-(void)setScaleRatio:(CGFloat)scaleRatio
{
    _scaleRatio = scaleRatio;
    self.candleWidth = scaleRatio * JHCKLineStyle_candleWidth;
    [self setNeedsDisplay];
}
- (void)setIsLongPress:(BOOL)isLongPress
{
    _isLongPress = isLongPress;
    [self setNeedsDisplay];
}

-(void)setMainState:(JHCKLineMainState)mainState
{
    if (_mainState != mainState) {
        _mainState = mainState;
        [self setNeedsDisplay];
    }
}

- (void)setSecondaryState:(JHCKLineSecondaryState)secondaryState
{
    if (_secondaryState != secondaryState) {
        _secondaryState = secondaryState;
        [self setNeedsDisplay];
    }
}

- (void)setVolState:(JHCKLineVolState)volState
{
    if (_volState != volState) {
        _volState = volState;
        [self setNeedsDisplay];
    }
}

- (void)setIsThemeWhite:(BOOL)isThemeWhite
{
    _isThemeWhite = isThemeWhite;
    [self setNeedsDisplay];
}

- (void)setPriceDigitNum:(NSInteger)priceDigitNum
{
    _priceDigitNum = priceDigitNum;
    [self setNeedsDisplay];
}

- (void)setAmountDigitNum:(NSInteger)amountDigitNum
{
    _amountDigitNum = amountDigitNum;
    [self setNeedsDisplay];
}


#pragma mark -- 初始化K线
- (instancetype)initWithFrame:(CGRect)frame
                        datas:(NSArray <JHCKLineModel *> *)datas
                      scrollOffsetX:(CGFloat)scrollOffsetX
                       scaleRatio:(CGFloat)scaleRatio
                      isTimeLine:(BOOL)isTimeLine
                  isLongPress:(BOOL)isLongPress
                    mainState:(JHCKLineMainState)mainState
               secondaryState:(JHCKLineSecondaryState)secondaryState
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _datas = datas;
        _scrollOffsetX = scrollOffsetX;
        _scaleRatio = scaleRatio;
        _isTimeLine = isTimeLine;
        _isLongPress = isLongPress;
        _mainState = mainState;
        _secondaryState = secondaryState;
        _candleWidth = JHCKLineStyle_candleWidth * scaleRatio;
        
        _priceDigitNum = _amountDigitNum = 2;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _displayHeight = rect.size.height - JHCKLineStyle_topPadding - JHCKLineStyle_bottomDateHigh;
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context != NULL)
    {
        // 分割视图
        [self divisionRect];
        // 计算各种值
        [self calculateValue];
        // 规范日期格式
        [self formatDataStyle];
        // 初始化画笔
        [self initRenderer];
        // 画背景
        [self drawBgColor:context rect:rect];
        // 画背景网格
        [self drawGrid:context];
        
        if (_datas.count == 0) return;
        
        // 画K线图
        [self drawChart:context];
        // 画右侧文字
        [self drawRightText:context];
        // 画日期
        [self drawDate:context];
        // 画最大值最小值
        [self drawMaxAndMin:context];
        // 画顶部文字
        if (_isLongPress) {
            // 长按时顶部显示的是长按的model信息
            [self drawLongPressCrossLine:context];
        } else {
            [self drawTopText:context currentModel:_datas.firstObject];
        }
        // 画实时价格
        [self drawRealTimePrice:context];
    }
}


#pragma mark -- 绘制视图元素
// 分割视图
- (void)divisionRect
{
    CGFloat mainHeight = _displayHeight * 0.6;
    CGFloat volHeight = _displayHeight * 0.2;
    CGFloat secondaryHeight = _displayHeight * 0.2;
        
    if (_volState == JHCKLineVolState_NONE && _secondaryState == JHCKLineSecondaryState_NONE)
    {
        mainHeight = _displayHeight;
        volHeight = 0;
        secondaryHeight = 0;
    }
    else if (_volState == JHCKLineVolState_NONE & _secondaryState != JHCKLineSecondaryState_NONE)
    {
        mainHeight = _displayHeight * 0.8;
        secondaryHeight = _displayHeight * 0.2;
        volHeight = 0;
    }
    else if (_volState != JHCKLineVolState_NONE && _secondaryState == JHCKLineSecondaryState_NONE)
    {
        mainHeight = _displayHeight * 0.8;
        volHeight = _displayHeight * 0.2;
        secondaryHeight = 0;
    }
    _mainRect = CGRectMake(0, JHCKLineStyle_topPadding, self.bounds.size.width, mainHeight);
    if (_direction == JHCKLineDirection_Horizontal)
    {
        _dateRect = CGRectMake(0, CGRectGetMaxY(_mainRect), self.bounds.size.width, JHCKLineStyle_bottomDateHigh);
        _volRect = CGRectMake(0, CGRectGetMaxY(_dateRect), self.bounds.size.width, volHeight);
        _secondaryRect = CGRectMake(0, CGRectGetMaxY(_volRect), self.bounds.size.width, secondaryHeight);
        
        if (volHeight == 0) {
            _volRect = CGRectZero;
            _volRenderer = nil;
        }
        if (secondaryHeight == 0) {
            _secondaryRect = CGRectZero;
            _secondaryRender = nil;
        }
    }
    else
    {
        _volRect = CGRectMake(0, CGRectGetMaxY(_mainRect), self.bounds.size.width, volHeight);
        _secondaryRect = CGRectMake(0, CGRectGetMaxY(_volRect), self.bounds.size.width, secondaryHeight);
        if (volHeight == 0) {
            _volRect = CGRectZero;
            _volRenderer = nil;
        }
        if (secondaryHeight == 0) {
            _secondaryRect = CGRectZero;
            _secondaryRender = nil;
        }
        _dateRect = CGRectMake(0, _displayHeight + JHCKLineStyle_topPadding, self.bounds.size.width, JHCKLineStyle_bottomDateHigh);
    }
}

// 计算各种值
- (void)calculateValue
{
    if (_datas.count == 0) return;
    
    CGFloat itemWidth = _candleWidth + JHCKLineStyle_canldeMargin;
    if (_scrollOffsetX <= 0) {
        _startOffsetX = -_scrollOffsetX;
        _startIndex = 0;
    } else {
        CGFloat start = _scrollOffsetX / itemWidth;
        CGFloat offsetX = 0;
        if (floor(start) == ceil(start)) {
            _startIndex = (NSUInteger)floor(start);
        } else {
            _startIndex = (NSUInteger)(floor(_scrollOffsetX / itemWidth));
            offsetX = _startIndex * itemWidth - _scrollOffsetX;
        }
        _startOffsetX = offsetX;
    }
    // 当前屏幕总共多少个柱状
    NSUInteger diffIndex = (NSUInteger)(ceil(self.bounds.size.width - _startOffsetX) / itemWidth);
    _stopIndex = MIN(_startIndex + diffIndex, _datas.count - 1);
    _mainMaxValue = -CGFLOAT_MAX;
    _mainMinValue = CGFLOAT_MAX;
    _mainHighMaxValue = -CGFLOAT_MAX;
    _mainLowMinValue = CGFLOAT_MAX;
    _volMaxValue = -CGFLOAT_MAX;
    _volMinValue = CGFLOAT_MAX;
    _secondaryMaxValue = -CGFLOAT_MAX;
    _secondaryMinValue = CGFLOAT_MAX;
    
    for (NSUInteger index = _startIndex; index <= _stopIndex; index ++)
    {
        JHCKLineModel *model = _datas[index];
        // 获取主图最大最小值
        [self getMainMaxAndMinWithModel:model index:index];
        // 获取成交量最大最小值
        [self getVolMaxAndMinWithModel:model];
        // 获取副图最大最小值
        [self getSecondaryMaxAndMinWithModel:model];
    }
}

// 获取主图最大最小值
- (void)getMainMaxAndMinWithModel:(JHCKLineModel *)model index:(NSUInteger)index
{
    if (_isTimeLine)
    {
        _mainMaxValue = MAX(_mainMaxValue, model.Close.doubleValue);
        _mainMinValue = MIN(_mainMinValue, model.Close.doubleValue);
    }
    else
    {
        CGFloat maxPrice = model.High.doubleValue;
        CGFloat minPrice = model.Low.doubleValue;
        if (_mainState == JHCKLineMainState_MA)
        {
            if (model.MA5Price.doubleValue != 0)
            {
                maxPrice = MAX(maxPrice, model.MA5Price.doubleValue);
                minPrice = MIN(minPrice, model.MA5Price.doubleValue);
            }
//            if (model.MA7Price.doubleValue != 0)
//            {
//                maxPrice = MAX(maxPrice, model.MA7Price.doubleValue);
//                minPrice = MAX(minPrice, model.MA7Price.doubleValue);
//            }
            if (model.MA10Price.doubleValue != 0)
            {
                maxPrice = MAX(maxPrice, model.MA10Price.doubleValue);
                minPrice = MIN(minPrice, model.MA10Price.doubleValue);
            }
//            if (model.MA20Price.doubleValue != 0)
//            {
//                maxPrice = MAX(maxPrice, model.MA20Price.doubleValue);
//                minPrice = MIN(minPrice, model.MA20Price.doubleValue);
//            }
            if (model.MA30Price.doubleValue != 0)
            {
                maxPrice = MAX(maxPrice, model.MA30Price.doubleValue);
                minPrice = MIN(minPrice, model.MA30Price.doubleValue);
            }
        }
        else if (_mainState == JHCKLineMainState_BOLL)
        {
            if (model.up.doubleValue != 0) {
                maxPrice = MAX(model.up.doubleValue, model.High.doubleValue);
            }
            if (model.dn.doubleValue != 0) {
                minPrice = MIN(model.dn.doubleValue, model.Low.doubleValue);
            }
        }
        _mainMaxValue = MAX(_mainMaxValue, maxPrice);
        _mainMinValue = MIN(_mainMinValue, minPrice);
        if (_mainHighMaxValue < model.High.doubleValue)
        {
            _mainHighMaxValue = model.High.doubleValue;
            _mainMaxIndex = index;
        }
        if (_mainLowMinValue > model.Low.doubleValue)
        {
            _mainLowMinValue = model.Low.doubleValue;
            _mainMinIndex = index;
        }
    }
}

// 获取成交量最大最小值
- (void)getVolMaxAndMinWithModel:(JHCKLineModel *)model
{
//    _volMaxValue = MAX(_volMaxValue, MAX(model.Vol.doubleValue, MAX(model.MA5Volume.doubleValue, MAX(model.MA7Volume.doubleValue, model.MA10Volume.doubleValue))));
//    _volMinValue = MIN(_volMinValue, MIN(model.Vol.doubleValue, MIN(model.MA5Volume.doubleValue, MIN(model.MA7Volume.doubleValue, model.MA10Volume.doubleValue))));
    
    _volMaxValue = MAX(_volMaxValue, MAX(model.Vol.doubleValue, MAX(model.MA5Volume.doubleValue, model.MA10Volume.doubleValue)));
    _volMinValue = MIN(_volMinValue, MIN(model.Vol.doubleValue, MIN(model.MA5Volume.doubleValue, model.MA10Volume.doubleValue)));
}

// 获取副图最大最小值
- (void)getSecondaryMaxAndMinWithModel:(JHCKLineModel *)model
{
    if (_secondaryState == JHCKLineSecondaryState_MACD)
    {
        _secondaryMaxValue = MAX(_secondaryMaxValue, MAX(model.MACD.doubleValue, MAX(model.dif.doubleValue, model.dea.doubleValue)));
        _secondaryMinValue = MIN(_secondaryMinValue, MIN(model.MACD.doubleValue, MIN(model.dif.doubleValue, model.dea.doubleValue)));
    }
    else if (_secondaryState == JHCKLineSecondaryState_KDJ)
    {
        _secondaryMaxValue = MAX(_secondaryMaxValue, MAX(model.K.doubleValue, MAX(model.D.doubleValue, model.J.doubleValue)));
        _secondaryMinValue = MIN(_secondaryMinValue, MIN(model.K.doubleValue, MIN(model.D.doubleValue, model.J.doubleValue)));
    }
    else if (_secondaryState == JHCKLineSecondaryState_RSI)
    {
      _secondaryMaxValue = MAX(_secondaryMaxValue, model.RSI.doubleValue);
      _secondaryMinValue = MIN(_secondaryMinValue, model.RSI.doubleValue);
    }
    else
    {
      _secondaryMaxValue = MAX(_secondaryMaxValue, model.R.doubleValue);
      _secondaryMinValue = MIN(_secondaryMinValue, model.R.doubleValue);
    }
}

// 规范日期格式
- (void)formatDataStyle
{
    if(_datas.count < 2) return;
    
    NSTimeInterval fristtime = 0;
    NSTimeInterval secondTime = 0;
    NSTimeInterval time = ABS(fristtime - secondTime);
    
    if(time >= 24 * 60 * 60 * 28) {
        _format = @"yyyy-MM";
    } else if(time >= 24 * 60 * 60) {
        _format = @"yyyy-MM-dd";
    } else {
        _format = @"MM-dd HH:mm";
    }
}

// 初始化画笔
- (void)initRenderer
{
    _mainRender = [[JHCKLineMainRender alloc] initWithMaxValue:_mainMaxValue minValue:_mainMinValue candleWidth:_candleWidth topPadding:JHCKLineStyle_topPadding klineRect:_mainRect isTimeLine:_isTimeLine mainState:_mainState];
    _mainRender.priceDigitNum = _priceDigitNum;
    _mainRender.amountDigitNum = _amountDigitNum;
    
    if(_volState != JHCKLineVolState_NONE)
    {
        _volRenderer = [[JHCKLineVolRender alloc] initWithMaxValue:_volMaxValue minValue:_volMinValue candleWidth:_candleWidth topPadding:JHCKLineStyle_childPadding klineRect:_volRect];
        _volRenderer.priceDigitNum = _priceDigitNum;
        _volRenderer.amountDigitNum = _amountDigitNum;
    }
    if(_secondaryState != JHCKLineSecondaryState_NONE)
    {
        _secondaryRender = [[JHCKLineSecondaryRender alloc] initWithMaxValue:_secondaryMaxValue minValue:_secondaryMinValue candleWidth:_candleWidth topPadding:JHCKLineStyle_childPadding klineRect:_secondaryRect secondaryState:_secondaryState];
        _secondaryRender.priceDigitNum = _priceDigitNum;
        _secondaryRender.amountDigitNum = _amountDigitNum;
    }
}

// 画背景
- (void)drawBgColor:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSetFillColorWithColor(context, JHCKLineColors_bgColor.CGColor);
    CGContextFillRect(context, rect);
    // 画主图背景
    [_mainRender drawBackground:context];
    
    if(_volRenderer) {
        [_volRenderer drawBackground:context];
    }
    if(_secondaryRender) {
        [_secondaryRender drawBackground:context];
    }
}

// 画背景网格
- (void)drawGrid:(CGContextRef)context
{
    [_mainRender drawGrid:context gridRows:JHCKLineStyle_gridRows gridColums:JHCKLineStyle_gridColumns];
    
    if(_volRenderer) {
        [_volRenderer drawGrid:context gridRows:JHCKLineStyle_gridRows gridColums:JHCKLineStyle_gridColumns];
    }
    if(_secondaryRender) {
        [_secondaryRender drawGrid:context gridRows:JHCKLineStyle_gridRows gridColums:JHCKLineStyle_gridColumns];
    }
    
    CGContextSetLineWidth(context, 1);
    CGContextAddRect(context, self.bounds);
    CGContextDrawPath(context, kCGPathStroke);
}

// 画K线表
- (void)drawChart:(CGContextRef)context
{
    // 从右往左绘制
    for (NSUInteger index = _startIndex; index <= _stopIndex; index++)
    {
        JHCKLineModel *currentModel = _datas[index];
        CGFloat itemWidth = _candleWidth + JHCKLineStyle_canldeMargin;
        CGFloat currentOffsetX = (index - _startIndex) * itemWidth + _startOffsetX;
        CGFloat drawOffsetX = self.frame.size.width - currentOffsetX - _candleWidth / 2;
        JHCKLineModel *lastModel;
        if(index != _startIndex) {
            lastModel = _datas[index - 1];
        }
        
        [_mainRender drawChart:context lastModel:lastModel currentModel:currentModel currentX:drawOffsetX];
        if(_volRenderer) {
            [_volRenderer drawChart:context lastModel:lastModel currentModel:currentModel currentX:drawOffsetX];
        }
        if(_secondaryRender) {
            [_secondaryRender drawChart:context lastModel:lastModel currentModel:currentModel currentX:drawOffsetX];
        }
    }
}

// 画右侧文字信息
- (void)drawRightText:(CGContextRef)context
{
    [_mainRender drawRightText:context gridRows:JHCKLineStyle_gridRows gridColums:JHCKLineStyle_gridColumns];
    if (_volRenderer) {
        [_volRenderer drawRightText:context gridRows:JHCKLineStyle_gridRows gridColums:JHCKLineStyle_gridColumns];
    }
    if (_secondaryRender) {
        [_secondaryRender drawRightText:context gridRows:JHCKLineStyle_gridRows gridColums:JHCKLineStyle_gridColumns];
    }
}

// 画日期
- (void)drawDate:(CGContextRef)context
{
    // 间隔
    CGFloat columSpace = self.frame.size.width / JHCKLineStyle_gridColumns;
    for (int i = 0; i < JHCKLineStyle_gridColumns; i ++)
    {
        // 根据当前竖线的位置计算出需要显示的文字在第几个柱子上
        NSUInteger index = [self calculateIndexWithCurrentX:columSpace * i];
        if ([self isOutRangeIndex:index]) continue;
        
        JHCKLineModel *model = _datas[index];
//        NSString *dateStr = [self formatDateText:model.date.doubleValue];
        NSString *dateStr = model.date;
        
        CGRect rect = [JHCKLineTheme getRectWithString:dateStr font:[UIFont systemFontOfSize:JHCKLineStyle_bottomDatefontSize]];
        CGFloat y = CGRectGetMinY(_dateRect) + (JHCKLineStyle_bottomDateHigh - rect.size.height) / 2;
        [_mainRender drawText:dateStr atPoint:CGPointMake(columSpace * i - rect.size.width / 2, y) fontSize:JHCKLineStyle_bottomDatefontSize textColor:JHCKLineColors_bottomDateTextColor];
    }
}

// 画最大值和最小值
- (void)drawMaxAndMin:(CGContextRef)context
{
    if (_isTimeLine) return;
    CGFloat itemWidth = _candleWidth + JHCKLineStyle_canldeMargin;
    
    // 绘制最大值
    // 坐标x = 屏幕宽度 - (第N个下标对应位置的最大X - 起始偏移量 - 1/2个柱宽)
    CGFloat maxX = self.frame.size.width - ((_mainMaxIndex - _startIndex) * itemWidth + _startOffsetX + _candleWidth / 2.0);
    CGFloat maxY = [_mainRender getY:_mainHighMaxValue];
    
    if (maxX < self.frame.size.width / 2) // 最大值在左边
    {
        NSString *text = [NSString stringWithFormat:@"——%@", [NSString getValueStringWithCGFloat:_mainHighMaxValue digit:_priceDigitNum]];
        CGRect rect = [JHCKLineTheme getRectWithString:text font:[UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize]];
        [_mainRender drawText:text atPoint:CGPointMake(maxX, maxY - rect.size.height / 2) fontSize:JHCKLineStyle_defaultTextSize textColor:JHCKLineColors_maxMinTextColor];
    }
    else // 最大值在右边
    {
        NSString *text = [NSString stringWithFormat:@"%@——", [NSString getValueStringWithCGFloat:_mainHighMaxValue digit:_priceDigitNum]];
        CGRect rect = [JHCKLineTheme getRectWithString:text font:[UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize]];
        [_mainRender drawText:text atPoint:CGPointMake(maxX - rect.size.width, maxY - rect.size.height / 2) fontSize:JHCKLineStyle_defaultTextSize textColor:JHCKLineColors_maxMinTextColor];
    }
    
    // 绘制最小值
    // 坐标x = 屏幕宽度 - (第N个下标对应位置的最小X - 起始偏移量 - 1/2个柱宽)
    CGFloat minX = self.frame.size.width - ((_mainMinIndex - _startIndex) * itemWidth + _startOffsetX + _candleWidth / 2.0);
    CGFloat minY = [_mainRender getY:_mainLowMinValue];
    
    if (minX < self.frame.size.width / 2) // 最大值在左边
    {
        NSString *text = [NSString stringWithFormat:@"——%@", [NSString getValueStringWithCGFloat:_mainLowMinValue digit:_priceDigitNum]];
        CGRect rect = [JHCKLineTheme getRectWithString:text font:[UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize]];
        [_mainRender drawText:text atPoint:CGPointMake(minX, minY - rect.size.height / 2) fontSize:JHCKLineStyle_defaultTextSize textColor:JHCKLineColors_maxMinTextColor];
    }
    else // 最大值在右边
    {
        NSString *text = [NSString stringWithFormat:@"%@——", [NSString getValueStringWithCGFloat:_mainLowMinValue digit:_priceDigitNum]];
        CGRect rect = [JHCKLineTheme getRectWithString:text font:[UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize]];
        [_mainRender drawText:text atPoint:CGPointMake(minX - rect.size.width, minY - rect.size.height / 2) fontSize:JHCKLineStyle_defaultTextSize textColor:JHCKLineColors_maxMinTextColor];
    }
}

// 画长按时的十字线, 长按时顶部显示的是长按的model信息
- (void)drawLongPressCrossLine:(CGContextRef)context
{
    // 计算当前长按的是第几个柱子
    NSUInteger index = [self calculateIndexWithCurrentX:_longPressX];
    if ([self isOutRangeIndex:index]) return;
    
    CGFloat itemWidth = _candleWidth + JHCKLineStyle_canldeMargin;
    CGFloat currentX = self.frame.size.width - ((index - _startIndex) * itemWidth + _startOffsetX + _candleWidth / 2.0);
        
    // 画竖线
    CGContextSetStrokeColorWithColor(context, JHCKLineColors_crossHlineColor.CGColor);
    CGContextSetLineWidth(context, _candleWidth);
    CGContextMoveToPoint(context, currentX, 0);
    CGContextAddLineToPoint(context, currentX, self.frame.size.height);
    CGContextDrawPath(context, kCGPathStroke);
        
    JHCKLineModel *model = _datas[index];
    CGFloat currentY = [_mainRender getY:model.Close.doubleValue];
    
    // 画横线
    CGContextSetStrokeColorWithColor(context, JHCKLineColors_maxMinTextColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, currentY);
    CGContextAddLineToPoint(context, self.frame.size.width, currentY);
    CGContextDrawPath(context, kCGPathStroke);
    
    // 画交差圆点
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddArc(context, currentX, currentY, 2, 0, M_PI_2, YES);
    CGContextDrawPath(context, kCGPathFill);
    
    [self drawLongPressCrossLineText:context currentModel:model currentX:currentX currentY:currentY];
}

// 画长按时的顶部文字
- (void)drawLongPressCrossLineText:(CGContextRef)context currentModel:(JHCKLineModel *)currentModel currentX:(CGFloat)currentX currentY:(CGFloat)currentY
{
    NSString *text = [NSString getValueStringWithNumber:currentModel.Close digit:_priceDigitNum];
    CGRect rect = [JHCKLineTheme getRectWithString:text font:[UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize]];
    CGFloat padding = 3;
    CGFloat textHeight = rect.size.height + padding * 2;
    CGFloat textWidth = rect.size.width;
    CGFloat viewWidth = self.frame.size.width;
    
    BOOL isLeft = NO;
    if (currentX > self.frame.size.width / 2.0) // 价格提示文字右边
    {
        isLeft = YES;
        // 画实时价格的箭头边框
        CGContextMoveToPoint(context, viewWidth, currentY - textHeight / 2);
        CGContextAddLineToPoint(context, viewWidth, currentY + textHeight / 2);
        CGContextAddLineToPoint(context, viewWidth - textWidth, currentY + textHeight / 2);
        CGContextAddLineToPoint(context, viewWidth - textWidth - 10, currentY);
        CGContextAddLineToPoint(context, viewWidth - textWidth, currentY - textHeight / 2);
        CGContextAddLineToPoint(context, viewWidth, currentY - textHeight / 2);
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, JHCKLineColors_markerBorderColor.CGColor);
        CGContextSetFillColorWithColor(context, JHCKLineColors_markerBgColor.CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        [_mainRender drawText:text atPoint:CGPointMake(viewWidth - textWidth - 2, currentY - rect.size.height / 2) fontSize:JHCKLineStyle_defaultTextSize textColor:JHCKLineColors_maxMinTextColor];
    }
    else // 价格提示文字左边
    {
        isLeft = NO;
        // 画实时价格的箭头边框
        CGContextMoveToPoint(context, 0, currentY - textHeight / 2);
        CGContextAddLineToPoint(context, 0, currentY + textHeight / 2);
        CGContextAddLineToPoint(context, textWidth, currentY + textHeight / 2);
        CGContextAddLineToPoint(context, textWidth + 10, currentY);
        CGContextAddLineToPoint(context, textWidth, currentY - textHeight / 2);
        CGContextAddLineToPoint(context, 0, currentY - textHeight / 2);
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, JHCKLineColors_markerBorderColor.CGColor);
        CGContextSetFillColorWithColor(context, JHCKLineColors_markerBgColor.CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        [_mainRender drawText:text atPoint:CGPointMake(2, currentY - rect.size.height / 2) fontSize:JHCKLineStyle_defaultTextSize textColor:JHCKLineColors_maxMinTextColor];
    }
    
    // 绘制底部日期文字
//    NSString *dateText = [self formatDateText:currentModel.date.doubleValue];
    NSString *dateText = currentModel.date;
    CGRect dateRect = [JHCKLineTheme getRectWithString:dateText font:[UIFont systemFontOfSize:JHCKLineStyle_defaultTextSize]];
    CGFloat datePadding = 3;
    CGContextSetStrokeColorWithColor(context, JHCKLineColors_maxMinTextColor.CGColor);
    CGContextSetFillColorWithColor(context, JHCKLineColors_bgColor.CGColor);
    CGContextAddRect(context, CGRectMake(currentX - dateRect.size.width / 2 - datePadding, CGRectGetMinY(_dateRect), dateRect.size.width + datePadding * 2, dateRect.size.height + datePadding * 2));
    CGContextDrawPath(context, kCGPathFillStroke);
    
    [_mainRender drawText:dateText atPoint:CGPointMake(currentX - dateRect.size.width / 2, CGRectGetMinY(_dateRect) + datePadding) fontSize:JHCKLineStyle_defaultTextSize textColor:JHCKLineColors_maxMinTextColor];
    [self drawTopText:context currentModel:currentModel];
    
    self.showInfoBlock(currentModel, isLeft);
}

// 画常态下顶部文字
- (void)drawTopText:(CGContextRef)context currentModel:(JHCKLineModel *)currentModel
{
    [_mainRender drawTopText:context currentModel:currentModel];
    if (_volRenderer) {
        [_volRenderer drawTopText:context currentModel:currentModel];
    }
    if (_secondaryRender) {
        [_secondaryRender drawTopText:context currentModel:currentModel];
    }
}

// 画实时价格
- (void)drawRealTimePrice:(CGContextRef)context
{
    JHCKLineModel *model = _datas.firstObject;
    NSString *text = [NSString stringWithFormat:@"%@", [NSString getValueStringWithNumber:model.Close digit:_priceDigitNum]];
    CGFloat fontSize = 10;
    CGRect rect = [JHCKLineTheme getRectWithString:text font:[UIFont systemFontOfSize:fontSize]];
    CGFloat y = [_mainRender getY:model.Close.doubleValue];
    CGFloat viewWidth = self.frame.size.width;
    
    if (model.Close.doubleValue > _mainMaxValue)
    {
        y = [_mainRender getY:_mainMaxValue];
    }
    else if (model.Close.doubleValue < _mainMinValue)
    {
        y = [_mainRender getY:_mainMinValue];
    }
    
    // 当前的实时价格显示在屏幕内
    if (-_scrollOffsetX - rect.size.width > 0)
    {
        CGContextSetStrokeColorWithColor(context, JHCKLineColors_realTimeTextColor.CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGFloat locations[] = {5, 5};
        CGContextSetLineDash(context, 0, locations, 2);
        CGContextMoveToPoint(context, viewWidth + _scrollOffsetX, y);
        CGContextAddLineToPoint(context, viewWidth, y);
        CGContextDrawPath(context, kCGPathStroke);
        CGContextAddRect(context, CGRectMake(viewWidth - rect.size.width, y - rect.size.height / 2, rect.size.width, rect.size.height));
        CGContextSetFillColorWithColor(context, JHCKLineColors_bgColor.CGColor);
        CGContextDrawPath(context, kCGPathFill);
        
        [_mainRender drawText:text atPoint:CGPointMake(viewWidth - rect.size.width, y - rect.size.height / 2) fontSize:fontSize textColor:JHCKLineColors_maxMinTextColor];
        if (_isTimeLine) {
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextAddArc(context, viewWidth + _scrollOffsetX - _candleWidth / 2, y, 2, 0, M_PI_2, YES);
            CGContextDrawPath(context, kCGPathFill);
        }
    }
    else // 当前的实时价格未显示在屏幕内
    {
        CGContextSetStrokeColorWithColor(context, JHCKLineColors_realTimeLongLineColor.CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGFloat locations[] = {5,5};
        CGContextSetLineDash(context, 0, locations, 2);
        CGContextMoveToPoint(context,0, y);
        CGContextAddLineToPoint(context, viewWidth, y);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGFloat r = 8;
        CGFloat w = rect.size.width + 16;
        CGContextSetLineWidth(context, 0.5);
        CGFloat locations1[] = {};
        CGContextSetLineDash(context, 0, locations1, 0);
        CGContextSetFillColorWithColor(context, JHCKLineColors_bgColor.CGColor);
        CGContextMoveToPoint(context, viewWidth * 0.8, y - r);
        
        CGFloat curX = viewWidth * 0.8;
        CGRect arcRect = CGRectMake(curX - w / 2, y - r, w, 2 * r);
        CGFloat minX = CGRectGetMinX(arcRect);
        CGFloat midX = CGRectGetMidX(arcRect);
        CGFloat maxX = CGRectGetMaxX(arcRect);
        
        CGFloat minY = CGRectGetMinY(arcRect);
        CGFloat midY = CGRectGetMidY(arcRect);
        CGFloat maxY = CGRectGetMaxY(arcRect);
        
        CGContextMoveToPoint(context,minX, midY);
        CGContextAddArcToPoint(context, minX, minY, midX, minY, r);
        CGContextAddArcToPoint(context, maxX, minY, maxX, midY, r);
        CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, r);
        CGContextAddArcToPoint(context, minX, maxY, minX, midY, r);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        // 右侧三角
        CGFloat startX = CGRectGetMaxX(arcRect) - 4;
        CGContextSetFillColorWithColor(context, JHCKLineColors_maxMinTextColor.CGColor);
        CGContextMoveToPoint(context,startX, y);
        CGContextAddLineToPoint(context, startX - 3, y - 3);
        CGContextAddLineToPoint(context, startX - 3, y + 3);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        
        [_mainRender drawText:text atPoint:CGPointMake(curX - rect.size.width / 2 - 4, y - rect.size.height / 2) fontSize:fontSize textColor:JHCKLineColors_maxMinTextColor];
    }
}


#pragma mark -- 私有方法
// 根据当前竖线的位置计算出需要显示的文字在第几个柱子上
- (NSUInteger)calculateIndexWithCurrentX:(CGFloat)currentX
{
    NSInteger index = (self.frame.size.width - _startOffsetX - currentX) / (_candleWidth + JHCKLineStyle_canldeMargin) + _startIndex;
    return index;
}

// 判断当前柱子下标是否超出范围
- (BOOL)isOutRangeIndex:(NSUInteger)index
{
    if (index < 0 || index >= _datas.count) return YES;
    return NO;
}

// 格式化日期显示
- (NSString *)formatDateText:(NSTimeInterval)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = _format;
    return [formatter stringFromDate:date];
}


@end
