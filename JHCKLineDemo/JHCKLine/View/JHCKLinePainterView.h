//
//  JHCKLinePainterView.h
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import <UIKit/UIKit.h>
#import "JHCKLineModel.h"
#import "JHCConstant.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * K线画布层视图
 */
@interface JHCKLinePainterView : UIView

/** K线数据源 */
@property (nonatomic, strong) NSArray<JHCKLineModel *> *datas;

/** K线X向滚动量 */
@property (nonatomic, assign) CGFloat scrollOffsetX;

/** 开始的X */
@property (nonatomic, assign) CGFloat startOffsetX;

/**  蜡烛的拉伸比例 */
@property (nonatomic, assign) CGFloat scaleRatio;

/** K线主图状态 */
@property (nonatomic, assign) JHCKLineMainState mainState;

/** K线成交量图状态 */
@property (nonatomic, assign) JHCKLineVolState volState;

/** K线副图状态 */
@property (nonatomic, assign) JHCKLineSecondaryState secondaryState;

/** K线方向 */
@property (nonatomic, assign) JHCKLineDirection direction;

/** 是否是分时线 */
@property (nonatomic, assign) BOOL isTimeLine;

/** 是否在长按 */
@property (nonatomic, assign) BOOL isLongPress;

/** 长按的X */
@property (nonatomic, assign) CGFloat longPressX;

/** K线长按的回调 */
@property (nonatomic, copy) void (^showInfoBlock) (JHCKLineModel *model, BOOL isLeft);

// K线背景主题
@property (nonatomic, assign) BOOL isThemeWhite;

// K线价格小数位
@property (nonatomic, assign) NSInteger priceDigitNum;

// K线数额小数位
@property (nonatomic, assign) NSInteger amountDigitNum;

/**
 * 创建K线视图
 * frame: 布局位置
 * datas: K线数据源
 */
- (instancetype)initWithFrame:(CGRect)frame
                        datas:(NSArray <JHCKLineModel *> *)datas
                      scrollOffsetX:(CGFloat)scrollOffsetX
                       scaleRatio:(CGFloat)scaleRatio
                      isTimeLine:(BOOL)isTimeLine
                  isLongPress:(BOOL)isLongPress
                    mainState:(JHCKLineMainState)mainState
               secondaryState:(JHCKLineSecondaryState)secondaryState;



@end

NS_ASSUME_NONNULL_END
