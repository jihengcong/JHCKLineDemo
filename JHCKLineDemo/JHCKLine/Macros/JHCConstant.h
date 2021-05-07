//
//  JHCConstant.h
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#ifndef JHCConstant_h
#define JHCConstant_h


// K线的显示方向
typedef NS_ENUM(NSUInteger, JHCKLineDirection)
{
    JHCKLineDirection_Vertical  =  0,
    JHCKLineDirection_Horizontal,
};

// K线主图显示类型
typedef NS_ENUM(NSUInteger, JHCKLineMainState)
{
    JHCKLineMainState_NONE  =  0,
    JHCKLineMainState_MA,
    JHCKLineMainState_BOLL,
};

// K线副图显示类型
typedef NS_ENUM(NSUInteger, JHCKLineSecondaryState)
{
    JHCKLineSecondaryState_NONE  =  0,
    JHCKLineSecondaryState_MACD,
    JHCKLineSecondaryState_KDJ,
    JHCKLineSecondaryState_RSI,
    JHCKLineSecondaryState_WR,
};

// K线成交量图显示类型
typedef NS_ENUM(NSUInteger, JHCKLineVolState)
{
    JHCKLineVolState_NONE  =  0,
    JHCKLineVolState_VOL,
};


static CGFloat dd = 11.0;

//点与点的距离（）不用这种方式实现
static CGFloat JHCKLineStyle_pointWidth = 11.0;

//蜡烛之间的间距
static CGFloat JHCKLineStyle_canldeMargin =  2;

//蜡烛默认宽度
static CGFloat JHCKLineStyle_defaultcandleWidth =  8.5;

//蜡烛宽度
static CGFloat JHCKLineStyle_candleWidth  = 8.5;

//蜡烛中间线的宽度
static CGFloat JHCKLineStyle_candleLineWidth =  1;

//vol柱子宽度
static CGFloat JHCKLineStyle_volWidth = 8.5;

//macd柱子宽度
static CGFloat JHCKLineStyle_macdWidth = 3.0;

//垂直交叉线宽度
static CGFloat JHCKLineStyle_vCrossWidth  = 8.5;

//水平交叉线宽度
static CGFloat JHCKLineStyle_hCrossWidth = 0.5;

//网格
static CGFloat JHCKLineStyle_gridRows = 4;

static CGFloat JHCKLineStyle_gridColumns = 5;

static CGFloat JHCKLineStyle_topPadding = 20.0;

static CGFloat JHCKLineStyle_bottomDateHigh = 20.0;

static CGFloat JHCKLineStyle_childPadding = 25.0;

static CGFloat JHCKLineStyle_defaultTextSize = 10;

static CGFloat JHCKLineStyle_bottomDatefontSize = 10;

//表格右边文字价格
static CGFloat JHCKLineStyle_reightTextSize = 10;


/**
 * @brief 弱引用
 */
#define kWeakSelf(weakSelf) __weak __typeof(&*self) weakSelf = self;






#endif /* JHCConstant_h */
