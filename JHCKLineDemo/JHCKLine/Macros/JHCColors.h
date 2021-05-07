//
//  JHCColors.h
//  JHCKLineDemo
//
//  Created by mac on 2020/12/31.
//

#ifndef JHCColors_h
#define JHCColors_h
#import "JHCKLineTheme.h"
#import "JHCKLineStateManager.h"


// 是否是浅色主题
#define JHCColorThemeWhite  [JHCKLineStateManager sharedManager].isThemeWhite
// 是否是闪电交易
#define JHCIsFlashKLine  [JHCKLineStateManager sharedManager].isFlashKLine


// 颜色相关
//#define kRGB(r, g, b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
//#define kRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 十六进制设置颜色
#define kHex(rgbValue)       [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kHexA(rgbValue, a)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

/** 主标题颜色, 浅色模式下0x14191F, 深色模式0xCED2EB */
#define JHC_Main_Title_Color  ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x14191F) : kHex(0xCED2EB))
/** 副标题颜色 ，浅色模式下0x8B9EAC, 深色模式0x6D87A8 */
#define JHC_Sub_Title_Color  ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x8B9EAC) : kHex(0x6D87A8))

/** 买入按钮颜色 ，浅色模式下绿涨0x05AD93, 深色模式0x05AD93 */
#define JHC_BuyButton_Color_Normal ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x1FCAAA) : kHex(0x1FCAAA))
/** 卖出按钮颜色 ，浅色模式下红跌0xD14B64, 深色模式0xD14B64 */
#define JHC_SellButton_Color_Normal  ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xFF255F) : kHex(0xFF255F))

// K线主题背景颜色
#define JHCKLineColors_bgColor  ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xFFFFFF) : kHex(0x131E30))
// K线背景渐变颜色
#define JHCKLineColors_upShadowColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xFFFFFF) : kHex(0x0F1927))
#define JHCKLineColors_downShadowColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xFFFFFF) : kHex(0x0F1A34))
// 网格线颜色
#define JHCKLineColors_gridColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xE7E7E7) : kHex(0x4C5C74))
#define JHCKLineColors_kLineColor  ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x14191F) : kHex(0xCED2EB))

#define JHCKLineColors_ma5Color   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xC9B885) : kHex(0xffC9B885))
//#define JHCKLineColors_ma7Color   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xC9B885) : kHex(0xC9B885))
#define JHCKLineColors_ma10Color   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x6CB0A6) : kHex(0x6CB0A6))
//#define JHCKLineColors_ma20Color   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x6CB0A6) : kHex(0x6CB0A6))
#define JHCKLineColors_ma30Color   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x9979C6) : kHex(0x9979C6))
#define JHCKLineColors_upColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x03AD90) : kHex(0x03AD90))
#define JHCKLineColors_dnColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xD14B64) : kHex(0xD14B64))
#define JHCKLineColors_volColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x4729AE) : kHex(0x4729AE))

#define JHCKLineColors_macdColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x4729AE) : kHex(0x4729AE))
#define JHCKLineColors_difColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xC9B885) : kHex(0xC9B885))
#define JHCKLineColors_deaColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x6CB0A6) : kHex(0x6CB0A6))

#define JHCKLineColors_kColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xC9B885) : kHex(0xC9B885))
#define JHCKLineColors_dColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x6CB0A6) : kHex(0x6CB0A6))
#define JHCKLineColors_jColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x9979C6) : kHex(0x9979C6))
#define JHCKLineColors_rsiColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xC9B885) : kHex(0xC9B885))
#define JHCKLineColors_wrColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xD2D2B4) : kHex(0xD2D2B4))

#define JHCKLineColors_yAxisTextColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x70839E) : kHex(0x70839E))  //右边y轴刻度
#define JHCKLineColors_xAxisTextColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x60738E) : kHex(0x60738E))  //下方时间刻度

#define JHCKLineColors_maxMinTextColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x14191F) : kHex(0xCED2EB))  //最大最小值的颜色

//选中后显示值边框颜色
#define JHCKLineColors_markerBorderColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x14191F) : kHex(0xCED2EB))

//选中后显示值背景的填充颜色
#define JHCKLineColors_markerBgColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0xFFFFFF) : kHex(0x0D1722))

//实时线颜色等
#define JHCKLineColors_realTimeTextColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x14191F) : kHex(0xCED2EB))
#define JHCKLineColors_realTimeLongLineColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x4C86CD) : kHex(0x4C86CD))


//表格右边文字颜色
#define JHCKLineColors_rightTextColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x70839E) : kHex(0x70839E))
#define JHCKLineColors_bottomDateTextColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHex(0x70839E) : kHex(0x70839E))

#define JHCKLineColors_crossHlineColor   ((JHCColorThemeWhite && JHCIsFlashKLine) ? kHexA(0xCED2EB, 0.4) : kHexA(0xCED2EB, 0.4))





#endif /* JHCColors_h */
