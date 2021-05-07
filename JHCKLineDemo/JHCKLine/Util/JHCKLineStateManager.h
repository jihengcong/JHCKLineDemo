//
//  JHCKLineStateManager.h
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JHCKLineView.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * K线状态工具
 */
@interface JHCKLineStateManager : NSObject

+ (instancetype)sharedManager;

// 是否是闪电交易
@property (nonatomic, assign) BOOL isFlashKLine;

// K线View
@property (nonatomic, weak) JHCKLineView *klineView;
@property (nonatomic, weak) JHCKLineView *flashKLineView;

// K线model数据
@property (nonatomic, strong) NSArray *models;
// K线主图显示状态
@property (nonatomic, assign) JHCKLineMainState mainState;
// K线成交量图显示状态
@property (nonatomic, assign) JHCKLineVolState volState;
// K线副图显示状态
@property (nonatomic, assign) JHCKLineSecondaryState secondaryState;
// 是否是分时线
@property (nonatomic, assign) BOOL isTimeLine;

// K线选中的类型，如分时，1min等
@property (nonatomic, copy) NSString *period;


// K线背景主题
@property (nonatomic, assign) BOOL isThemeWhite;



// 第二个视图
// K线主图显示状态
@property (nonatomic, assign) JHCKLineMainState flashMainState;
// K线成交量图显示状态
@property (nonatomic, assign) JHCKLineVolState flashVolState;
// K线副图显示状态
@property (nonatomic, assign) JHCKLineSecondaryState flashSecondaryState;
// 是否是分时线
@property (nonatomic, assign) BOOL isTimeLineForFlash;


@end


NS_ASSUME_NONNULL_END
