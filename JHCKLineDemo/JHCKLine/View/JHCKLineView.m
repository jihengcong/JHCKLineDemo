//
//  JHCKLineView.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import "JHCKLineView.h"
#import "JHCKLinePainterView.h"
#import "JHCKLineInfoView.h"
#import "JHCConstant.h"


@interface JHCKLineView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) JHCKLinePainterView *painterView;
@property (nonatomic, strong) JHCKLineInfoView *infoView;

@property (nonatomic, assign) CGFloat maxScroll; // 可滚动的最大偏移量
@property (nonatomic, assign) CGFloat minScroll; // 可滚动的最小偏移量
@property (nonatomic, assign) CGFloat lastScrollOffsetX; // 上次滚动的位置
@property (nonatomic, assign) CGFloat dragSpeedX; // 拖拽速度, 小于0: 往左拖拽, 即向左滑动, 大于0: 往右拖拽, 即向右滑动
@property (nonatomic, assign) CGFloat dragBeginX; // 拖拽的起始位置

@property (nonatomic, assign) BOOL isScale; // 是否是拉伸状态
@property (nonatomic, assign) CGFloat lastScaleRatio; // 上次拉伸的位置

@property (nonatomic, strong) CADisplayLink *displayLink;

@end


@implementation JHCKLineView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setFrame:self.frame];
}

#pragma mark -- Setter 方法, 适用于masonary约束
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    // K线X向滚动量
    _scrollOffsetX = -self.frame.size.width / 5 + JHCKLineStyle_candleWidth / 2;
    
    [self fetchPainterView];
    [self initIndicators];
    
//    self.painterView.frame = self.bounds;
//    [self initIndicators];
}

- (void)setDatas:(NSArray<JHCKLineModel *> *)datas
{
    _datas = datas;
    
    [self initIndicators];
    self.painterView.datas = datas;
}

- (void)setIsTimeLine:(BOOL)isTimeLine
{
    _isTimeLine = isTimeLine;
    self.painterView.isTimeLine = isTimeLine;
}

- (void)setIsLongPress:(BOOL)isLongPress
{
    _isLongPress = isLongPress;
    
    self.painterView.isLongPress = isLongPress;
//    if (!isLongPress) {
//        [self.infoView removeFromSuperview];
//    }
    self.infoView.hidden = !isLongPress;
}

- (void)setScrollOffsetX:(CGFloat)scrollOffsetX
{
    _scrollOffsetX = scrollOffsetX;
    self.painterView.scrollOffsetX = scrollOffsetX;
}

- (void)setScaleRatio:(CGFloat)scaleRatio
{
    _scaleRatio = scaleRatio;
    
    [self initIndicators];
    self.painterView.scaleRatio = scaleRatio;
}

- (void)setMainState:(JHCKLineMainState)mainState
{
    _mainState = mainState;
    self.painterView.mainState = mainState;
}

- (void)setVolState:(JHCKLineVolState)volState
{
    _volState = volState;
    self.painterView.volState = volState;
}

- (void)setSecondaryState:(JHCKLineSecondaryState)secondaryState
{
    _secondaryState = secondaryState;
    self.painterView.secondaryState = secondaryState;
}

- (void)setLongPressX:(CGFloat)longPressX
{
    _longPressX = longPressX;
    self.painterView.longPressX = longPressX;
}

- (void)setDirection:(JHCKLineDirection)direction
{
    _direction = direction;
    self.painterView.direction = direction;
}

- (void)setIsThemeWhite:(BOOL)isThemeWhite
{
    _isThemeWhite = isThemeWhite;
    self.painterView.isThemeWhite = isThemeWhite;
}

- (void)setPriceDigitNum:(NSInteger)priceDigitNum
{
    _priceDigitNum = priceDigitNum;
    self.painterView.priceDigitNum = priceDigitNum;
}

- (void)setAmountDigitNum:(NSInteger)amountDigitNum
{
    _amountDigitNum = amountDigitNum;
    self.painterView.amountDigitNum = amountDigitNum;
}


#pragma mark -- init 初始化方法, 适用于frame约束
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 蜡烛的拉伸比例
        _scaleRatio = 1;
        _mainState = JHCKLineMainState_MA;
        _secondaryState = JHCKLineSecondaryState_MACD;
//        // K线X向滚动量
//        _scrollOffsetX = -self.frame.size.width / 5 + JHCKLineStyle_candleWidth / 2;
//
//        [self fetchPainterView];
//        [self initIndicators];
        
        _priceDigitNum = _amountDigitNum = 2;
    }
    return self;
}


#pragma mark -- Private Methods 私有方法
- (void)initIndicators
{
    // 数据的长度
    CGFloat dataLength = _datas.count * (JHCKLineStyle_candleWidth * _scaleRatio + JHCKLineStyle_canldeMargin) - JHCKLineStyle_canldeMargin;
    // 可滚动的最大偏移量
    _maxScroll = dataLength - self.frame.size.width;
    // 正常状态下的滚动偏移量
    CGFloat normalMinScroll = -self.frame.size.width / 5.0 + (JHCKLineStyle_candleWidth * _scaleRatio) / 2.0;
    
    self.minScroll = MIN(normalMinScroll, _maxScroll);
    self.scrollOffsetX = [self clamp:_scrollOffsetX max:_maxScroll min:_minScroll];
    self.lastScrollOffsetX = _scrollOffsetX;
}

- (CGFloat)clamp:(CGFloat)value max:(CGFloat)max min:(CGFloat)min
{
    if (value < min) {
        return min;
    } else if (value > max) {
        return max;
    } else {
        return value;
    }
}


#pragma mark -- Gesture Methods 手势方法
// 拖拽手势
- (void)dragKlineEvent:(UIPanGestureRecognizer *)gesture
{
    // 长按时不滚动
    if (_isLongPress) return;
    
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [gesture locationInView:_painterView];
            _dragBeginX = point.x;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:_painterView];
            CGFloat dragX = point.x - _dragBeginX;
            self.scrollOffsetX = [self clamp:_lastScrollOffsetX + dragX max:_maxScroll min:_minScroll];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            // 拖动速度
            CGPoint point = [gesture velocityInView:_painterView];
            self.dragSpeedX = point.x;
            self.lastScrollOffsetX = _scrollOffsetX;
            if (_dragSpeedX != 0) {
                _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshEvent:)];
                [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            }
        }
            break;
        default:
            break;
    }
}

- (void)refreshEvent:(CADisplayLink *)link
{
    CGFloat space = 100;
    CGFloat margin = 5;
    if (_dragSpeedX < 0) // 往左拖拽, 即向左滑动
    {
        self.dragSpeedX = MIN(self.dragSpeedX + space, 0);
        self.scrollOffsetX = [self clamp:self.scrollOffsetX - margin max:_maxScroll min:_minScroll];
        self.lastScrollOffsetX = _scrollOffsetX;
    }
    else if (_dragSpeedX > 0) // 往右拖拽, 即向右滑动
    {
        self.dragSpeedX = MAX(self.dragSpeedX - space, 0);
        self.scrollOffsetX = [self clamp:self.scrollOffsetX + margin max:_maxScroll min:_minScroll];
        self.lastScrollOffsetX = _scrollOffsetX;
    }
    else
    {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    if (self.scrollOffsetX == self.minScroll)
    {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

// 长按手势
- (void)longPressKlineEvent:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [gesture locationInView:_painterView];
            self.longPressX = point.x;
            self.isLongPress = YES;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:_painterView];
            self.longPressX = point.x;
            self.isLongPress = YES;
        }
            break;
        case UIGestureRecognizerStateEnded:
            self.isLongPress = NO;
            break;
        default:
            break;
    }
}

// 拉伸手势
- (void)secalXEvent:(UIPinchGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            _isScale = YES;
            break;
        case UIGestureRecognizerStateChanged:
        {
            _isScale = true;
            self.scaleRatio = [self clamp:_lastScaleRatio * gesture.scale max:2 min:0.5];
        }
        case UIGestureRecognizerStateEnded:
        {
            _isScale = false;
            self.lastScaleRatio = _scaleRatio;
        }
        default:
            break;
    }
}


#pragma mark -- 懒加载
- (JHCKLinePainterView *)fetchPainterView
{
    if (_painterView && _painterView.frame.size.height > 0) return _painterView;
    
    _painterView = [[JHCKLinePainterView alloc] initWithFrame:self.bounds datas:_datas scrollOffsetX:_scrollOffsetX scaleRatio:_scaleRatio isTimeLine:_isTimeLine isLongPress:_isLongPress mainState:_mainState secondaryState:_secondaryState];
    _painterView.userInteractionEnabled = YES;
    [self addSubview:self.painterView];
    
    kWeakSelf(weakSelf)
    _painterView.showInfoBlock = ^(JHCKLineModel * _Nonnull model, BOOL isLeft) {
        model.priceDigitNum = weakSelf.priceDigitNum;
        model.amountDigitNum = weakSelf.amountDigitNum;
        weakSelf.infoView.model = model;
        CGFloat padding = 5;
        if (isLeft) {
            weakSelf.infoView.frame = CGRectMake(padding, 30, 120, 160);
        } else {
            weakSelf.infoView.frame = CGRectMake(weakSelf.frame.size.width - 120 - padding, 30, 120, 160);
        }
    };
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragKlineEvent:)];
    panGesture.delegate = self;
    UILongPressGestureRecognizer *longGresture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressKlineEvent:)];
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(secalXEvent:)];
    [_painterView addGestureRecognizer:panGesture];
    [_painterView addGestureRecognizer:longGresture];
    [_painterView addGestureRecognizer:pinGesture];

    return _painterView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

- (JHCKLineInfoView *)infoView
{
    if (_infoView) return _infoView;
    _infoView = [[JHCKLineInfoView alloc] init];
    [self addSubview:_infoView];
    return _infoView;
}


@end
