//
//  JHCKLineBaseRender.h
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JHCKLineModel.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * K线绘制的基类
 */
@interface JHCKLineBaseRender : NSObject

@property (nonatomic, assign) CGFloat maxValue; // 最大值
@property (nonatomic, assign) CGFloat minValue; // 最小值
@property (nonatomic, assign) CGFloat scaleY; // Y轴上的拉伸比例
@property (nonatomic, assign) CGFloat topPadding; // 顶部间隙
@property (nonatomic, assign) CGFloat candleWidth; // 柱状宽度
@property (nonatomic, assign) CGRect klineRect; // K线的frame

@property (nonatomic, assign) NSInteger priceDigitNum;
@property (nonatomic, assign) NSInteger amountDigitNum; 


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
                       klineRect:(CGRect)klineRect;

/**
 * 绘制背景
 */
- (void)drawBackground:(CGContextRef)context;

/**
 * 绘制网格
 * gridRows: 行数
 * gridColums: 列数
 */
- (void)drawGrid:(CGContextRef)context
        gridRows:(NSUInteger)gridRows
      gridColums:(NSUInteger)gridColums;

/**
 * 绘制右侧文字, 即价格或成交量等
 * gridRows: 行数
 * gridColums: 列数
 */
- (void)drawRightText:(CGContextRef)context
            gridRows:(NSUInteger)gridRows
          gridColums:(NSUInteger)gridColums;

/**
 * 绘制顶部文字, 即价格或成交量等
 */
- (void)drawTopText:(CGContextRef)context
       currentModel:(JHCKLineModel *)currentModel;

/**
 * 画K线
 */
- (void)drawChart:(CGContextRef)context
        lastModel:(JHCKLineModel *)lastModel
     currentModel:(JHCKLineModel *)currentModel
         currentX:(CGFloat)currentX;

/**
 * 画线, 包括MA5,MA10等
 */
- (void)drawLine:(CGContextRef)context
       lastValue:(CGFloat)lastValue
    currentValue:(CGFloat)currentValue
        currentX:(CGFloat)currentX
           color:(UIColor *)color;

- (CGFloat)getY:(CGFloat)value;

//下列提供给子类的工具方法
- (void)drawText:(NSString *)text
         atPoint:(CGPoint)point
        fontSize:(CGFloat)size
       textColor:(UIColor *)color;

- (NSString *)volFormat:(CGFloat)value;


@end


NS_ASSUME_NONNULL_END
