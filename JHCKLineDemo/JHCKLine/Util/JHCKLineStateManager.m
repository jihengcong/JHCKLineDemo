//
//  JHCKLineStateManager.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import "JHCKLineStateManager.h"


static JHCKLineStateManager *_manater = nil;

@implementation JHCKLineStateManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mainState = JHCKLineMainState_MA;
        _secondaryState = JHCKLineSecondaryState_MACD;
        _volState = JHCKLineVolState_VOL;
        _isTimeLine = NO;
//        _isThemeWhite = YES;
        
        _flashMainState = JHCKLineMainState_MA;
        _flashSecondaryState = JHCKLineSecondaryState_NONE;
        _flashVolState = JHCKLineVolState_NONE;
    }
    return self;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manater = [[self alloc] init];
    });
    return _manater;
}

- (void)setIsFlashKLine:(BOOL)isFlashKLine
{
    _isFlashKLine = isFlashKLine;
    _flashKLineView.mainState = _flashMainState;
}

- (void)setKlineView:(JHCKLineView *)klineView
{
    _klineView = klineView;
    _klineView.mainState = _mainState;
    _klineView.secondaryState = _secondaryState;
    _klineView.volState = _volState;
    _klineView.isTimeLine = _isTimeLine;
    _klineView.datas = _models;
}

- (void)setFlashKLineView:(JHCKLineView *)flashKLineView
{
    _flashKLineView = flashKLineView;
    _flashKLineView.mainState = _flashMainState;
    _flashKLineView.secondaryState = _flashSecondaryState;
    _flashKLineView.volState = _flashVolState;
    _flashKLineView.isTimeLine = _isTimeLineForFlash;
    _flashKLineView.datas = _models;
}

- (void)setModels:(NSArray *)models
{
    _models = models;
    if (_isFlashKLine) {
        _flashKLineView.datas = _models;
    } else {
        _klineView.datas = models;
    }
}

- (void)setMainState:(JHCKLineMainState)mainState
{
    _mainState = mainState;
    _klineView.mainState = mainState;
}

- (void)setSecondaryState:(JHCKLineSecondaryState)secondaryState
{
    _secondaryState = secondaryState;
    _klineView.secondaryState = secondaryState;
}

- (void)setVolState:(JHCKLineVolState)volState
{
    _volState = volState;
    _klineView.volState = volState;
}

- (void)setIsTimeLine:(BOOL)isTimeLine
{
    _isTimeLine = isTimeLine;
    _klineView.isTimeLine = isTimeLine;
}

- (void)setIsThemeWhite:(BOOL)isThemeWhite
{
    _isThemeWhite = isThemeWhite;
    _klineView.isThemeWhite = isThemeWhite;
    _flashKLineView.isThemeWhite = isThemeWhite;
}



- (void)setFlashMainState:(JHCKLineMainState)flashMainState
{
    _flashMainState = flashMainState;
    _flashKLineView.mainState = flashMainState;
}

- (void)setFlashSecondaryState:(JHCKLineSecondaryState)flashSecondaryState
{
    _flashSecondaryState = flashSecondaryState;
    _flashKLineView.secondaryState = flashSecondaryState;
}

- (void)setFlashVolState:(JHCKLineVolState)flashVolState
{
    _flashVolState = flashVolState;
    _flashKLineView.volState = flashVolState;
}

- (void)setIsTimeLineForFlash:(BOOL)isTimeLineForFlash
{
    _isTimeLineForFlash = isTimeLineForFlash;
    _flashKLineView.isTimeLine = isTimeLineForFlash;
}



@end
