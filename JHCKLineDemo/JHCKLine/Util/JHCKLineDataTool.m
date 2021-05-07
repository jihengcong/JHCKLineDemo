//
//  JHCKLineDataTool.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import "JHCKLineDataTool.h"
#import <UIKit/UIKit.h>


static NSString *const kDefaultValue = @"0.00";

@implementation JHCKLineDataTool

// 计算K线数据，如MA,BOOL,MACD等
+ (void)calculate:(NSArray <JHCKLineModel *> *)dataList
{
    if (dataList.count == 0) return;
    dataList = [[dataList reverseObjectEnumerator] allObjects];
    
    [self calculateMA:dataList isAddLast:NO];
    [self calculateBOLL:dataList isAddLast:NO];
    [self calculateVolumeMA:dataList isAddLast:NO];
    
    [self calculateMACD:dataList isAddLast:NO];
    [self calculateKDJ:dataList isAddLast:NO];
    [self calculateRSI:dataList isAddLast:NO];
    [self calculateWR:dataList isAddLast:NO];
}

// 添加最近的model到数据源
+ (void)addLastData:(NSArray <JHCKLineModel *> *)dataList model:(JHCKLineModel *)model
{
    if (dataList.count == 0) return;
    
    [self calculateMA:dataList isAddLast:YES];
    [self calculateBOLL:dataList isAddLast:YES];
    [self calculateVolumeMA:dataList isAddLast:YES];
    
    [self calculateMACD:dataList isAddLast:YES];
    [self calculateKDJ:dataList isAddLast:YES];
    [self calculateRSI:dataList isAddLast:YES];
    [self calculateWR:dataList isAddLast:YES];
}


// 计算MA
+ (void)calculateMA:(NSArray <JHCKLineModel *> *)dataList isAddLast:(BOOL)isAddLast
{
    double ma5 = 0;
//    double ma7 = 0;
    double ma10 = 0;
    double ma20 = 0;
    double ma30 = 0;
    NSInteger i = 0;
    
    // 如果是新增加的数据，i从倒数第一个开始遍历
    if (isAddLast && dataList.count > 1) {
        i = dataList.count - 1;
        JHCKLineModel *model = dataList[dataList.count - 2];
        ma5 = model.MA5Price.doubleValue * 5;
//        ma7 = model.MA7Price.doubleValue * 7;
        ma10 = model.MA10Price.doubleValue * 10;
        ma20 = model.MA20Price.doubleValue * 20;
        ma30 = model.MA30Price.doubleValue * 30;
    }
    for (; i < dataList.count; i++)
    {
        JHCKLineModel *model = dataList[i];
        double closePrice = model.Close.doubleValue;
        ma5 += closePrice;
//        ma7 += closePrice;
        ma10 += closePrice;
        ma20 += closePrice;
        ma30 += closePrice;
        
        // 求MA5价格
        if (i == 4) {
            model.MA5Price = @(ma5 / 5).stringValue;
        } else if (i >= 5) {
            ma5 -= dataList[i - 5].Close.doubleValue;
            model.MA5Price = @(ma5 / 5).stringValue;
        } else {
            model.MA5Price = kDefaultValue;
        }
        
        // 求MA7价格
//        if (i == 6) {
//            model.MA7Price = @(ma7 / 7).stringValue;
//        } else if (i >= 7) {
//            ma7 -= dataList[i - 7].Close.doubleValue;
//            model.MA7Price = @(ma7 / 7).stringValue;
//        } else {
//            model.MA7Price = kDefaultValue;
//        }
        
        // 求MA10价格
        if (i == 9) {
            model.MA10Price = @(ma10 / 10).stringValue;
        } else if (i >= 10) {
            ma10 -= dataList[i - 10].Close.doubleValue;
            model.MA10Price = @(ma10 / 10).stringValue;
        } else {
            model.MA10Price = kDefaultValue;
        }
        
        // 求MA20价格
        if (i == 19) {
            model.MA20Price = @(ma20 / 20).stringValue;
        } else if (i >= 20) {
            ma20 -= dataList[i - 20].Close.doubleValue;
            model.MA20Price = @(ma20 / 20).stringValue;
        } else {
            model.MA20Price = kDefaultValue;
        }
        
        // 求MA30价格
        if (i == 29) {
            model.MA30Price = @(ma30 / 30).stringValue;
        } else if (i >= 30) {
            ma30 -= dataList[i - 30].Close.doubleValue;
            model.MA30Price = @(ma30 / 30).stringValue;
        } else {
            model.MA30Price = kDefaultValue;
        }
    }
}

// 计算BOLL
+ (void)calculateBOLL:(NSArray <JHCKLineModel *> *)dataList isAddLast:(BOOL)isAddLast
{
    NSInteger i = 0;
    
    // 如果是新增加的数据，i从倒数第一个开始遍历
    if (isAddLast && dataList.count > 1) {
        i = dataList.count - 1;
    }
    for (; i < dataList.count; i ++)
    {
        JHCKLineModel *model = dataList[i];
        if (i < 19) {
            model.mb = kDefaultValue;
            model.up = kDefaultValue;
            model.dn = kDefaultValue;
        } else {
            int n = 20;
            double md = 0;
            for (NSInteger j = i - n + 1; j <= i; j ++) {
                double c = dataList[j].Close.doubleValue;
                double m = model.MA20Price.doubleValue;
                double value = c - m;
                md += value * value;
            }
            md = md / (n - 1);
            md = sqrt(md);
            model.mb = model.MA20Price;
            model.up = @(model.mb.doubleValue + 2.0 * md).stringValue;
            model.dn = @(model.mb.doubleValue - 2.0 * md).stringValue;
        }
    }
}

// 计算VolumeMA
+ (void)calculateVolumeMA:(NSArray <JHCKLineModel *> *)dataList isAddLast:(BOOL)isAddLast
{
    double VolMA5 = 0;
//    double VolMA7 = 0;
    double VolMA10 = 0;
    NSInteger i = 0;
    
    if (isAddLast && dataList.count > 1)
    {
        i = dataList.count - 1;
        JHCKLineModel *model = dataList[dataList.count - 2];
        VolMA5 = model.MA5Volume.doubleValue * 5;
//        VolMA7 = model.MA7Volume.doubleValue * 7;
        VolMA10 = model.MA10Volume.doubleValue * 10;
    }
    for (; i < dataList.count; i ++)
    {
        JHCKLineModel *model = dataList[i];
        VolMA5 += model.Vol.doubleValue;
//        VolMA7 += model.Vol.doubleValue;
        VolMA10 += model.Vol.doubleValue;
        
        // 计算MA5Vol
        if (i == 4) {
            model.MA5Volume = @(VolMA5 / 5).stringValue;
        } else if (i > 4) {
            VolMA5 -= dataList[i - 5].Vol.doubleValue;
            model.MA5Volume = @(VolMA5 / 5).stringValue;
        } else {
            model.MA5Volume = kDefaultValue;
        }
        
        // 计算MA7Vol
//        if (i == 6) {
//            model.MA7Volume = @(VolMA7 / 7).stringValue;
//        } else if (i > 6) {
//            VolMA7 -= dataList[i - 7].Vol.doubleValue;
//            model.MA7Volume = @(VolMA7 / 7).stringValue;
//        } else {
//            model.MA7Volume = kDefaultValue;
//        }
        
        // 计算MA10Vol
        if (i == 9) {
            model.MA10Volume = @(VolMA10 / 10).stringValue;
        } else if (i > 9) {
            VolMA10 -= dataList[i - 10].Vol.doubleValue;
            model.MA10Volume = @(VolMA10 / 10).stringValue;
        } else {
            model.MA10Volume = kDefaultValue;
        }
    }
}

// 计算KDJ
+ (void)calculateKDJ:(NSArray <JHCKLineModel *> *)dataList isAddLast:(BOOL)isAddLast
{
    double K = 0;
    double D = 0;
    NSInteger i = 0;
    
    if (isAddLast && dataList.count > 1)
    {
        i = dataList.count - 1;
        JHCKLineModel *model = dataList[dataList.count - 2];
        K = model.K.doubleValue;
        D = model.D.doubleValue;
    }
    
    for (; i < dataList.count; i ++)
    {
        JHCKLineModel *model = dataList[i];
        double closePrice = model.Close.doubleValue;
        
        NSInteger startIndex = i - 13;
        if (startIndex < 0) startIndex = 0;
        double max14 = -CGFLOAT_MAX;
        double min14 = CGFLOAT_MAX;
        for (NSInteger index = startIndex; index <= i; index ++)
        {
            max14 = MAX(max14, dataList[index].High.doubleValue);
            min14 = MIN(min14, dataList[index].Low.doubleValue);
        }
        double rsv = 100 * (closePrice - min14) / (max14 - min14);
        
        if (i == 0) {
            K = 50;
            D = 50;
        } else {
            K = (rsv + 2 * K) / 3;
            D = (K + 2 * D) / 3;
        }
        if (i < 13) {
            model.K = kDefaultValue;
            model.D = kDefaultValue;
            model.J = kDefaultValue;
        } else if (i == 13 || i == 14) {
            model.K = @(K).stringValue;
            model.D = kDefaultValue;
            model.J = kDefaultValue;
        } else {
            model.K = @(K).stringValue;
            model.D = @(D).stringValue;
            model.J = @(3 * K - 2 * D).stringValue;
        }
    }
}

// 计算MACD
+ (void)calculateMACD:(NSArray <JHCKLineModel *> *)dataList isAddLast:(BOOL)isAddLast
{
    double EMA12 = 0;
    double EMA26 = 0;
    double dif = 0;
    double dea = 0;
    double MACD = 0;
    NSInteger i = 0;
    
    if (isAddLast && dataList.count > 1)
    {
        i = dataList.count - 1;
        JHCKLineModel *model = dataList[dataList.count - 2];
        dif = model.dif.doubleValue;
        dea = model.dea.doubleValue;
        MACD = model.MACD.doubleValue;
        EMA12 = model.EMA12.doubleValue;
        EMA26 = model.EMA26.doubleValue;
    }
    
    for (; i < dataList.count; i ++)
    {
        JHCKLineModel *model = dataList[i];
        double closePrice = model.Close.doubleValue;
        if (i == 0) {
            EMA12 = closePrice;
            EMA26 = closePrice;
        } else {
            // EMA（12） = 前一日EMA（12） X 11/13 + 今日收盘价 X 2/13
            EMA12 = EMA12 * 11 / 13 + closePrice * 2 / 13;
            // EMA（26） = 前一日EMA（26） X 25/27 + 今日收盘价 X 2/27
            EMA26 = EMA26 * 25 / 27 + closePrice * 2 / 27;
        }
        // DIF = EMA（12） - EMA（26） 。
        // 今日DEA = （前一日DEA X 8/10 + 今日DIF X 2/10）
        // 用（DIF-DEA）*2即为MACD柱状图。
        dif = EMA12 - EMA26;
        dea = dea * 8 / 10 + dif * 2 / 10;
        MACD = (dif - dea) * 2;
        model.dif = @(dif).stringValue;
        model.dea = @(dea).stringValue;
        model.MACD = @(MACD).stringValue;
        model.EMA12 = @(EMA12).stringValue;
        model.EMA26 = @(EMA26).stringValue;
    }
    
}

// 计算RSI
+ (void)calculateRSI:(NSArray <JHCKLineModel *> *)dataList isAddLast:(BOOL)isAddLast
{
    double RSI = 0;
    double RSI_ABSEMA = 0;
    double RSI_MaxEMA = 0;
    NSInteger i = 0;
    
    if (isAddLast && dataList.count > 1)
    {
        i = dataList.count - 1;
        JHCKLineModel *model = dataList[dataList.count - 2];
        RSI = model.RSI.doubleValue;
        RSI_ABSEMA = model.RSI_ABSEMA.doubleValue;
        RSI_MaxEMA = model.RSI_MaxEMA.doubleValue;
    }
    
    for (; i < dataList.count; i ++)
    {
        JHCKLineModel *model = dataList[i];
        double closePrice = model.Close.doubleValue;
        if (i == 0) {
            RSI = 0;
            RSI_ABSEMA = 0;
            RSI_MaxEMA = 0;
        } else {
            double Rmax = MAX(0, closePrice - dataList[i - 1].Close.doubleValue);
            double RAbs = ABS(closePrice - dataList[i - 1].Close.doubleValue);
            RSI_MaxEMA = (Rmax + (14 - 1) * RSI_MaxEMA) / 14;
            RSI_ABSEMA = (RAbs + (14 - 1) * RSI_ABSEMA) / 14;
            RSI = (RSI_MaxEMA / RSI_ABSEMA) * 100;
        }
        if (i < 13) RSI = 0;
        model.RSI = @(RSI).stringValue;
        model.RSI_ABSEMA = @(RSI_ABSEMA).stringValue;
        model.RSI_ABSEMA = @(RSI_MaxEMA).stringValue;
    }
}

// 计算WR
+ (void)calculateWR:(NSArray <JHCKLineModel *> *)dataList isAddLast:(BOOL)isAddLast
{
    NSInteger i = 0;
    if (isAddLast && dataList.count > 1)
    {
        i = dataList.count - 1;
    }
    
    for (; i < dataList.count; i ++)
    {
        JHCKLineModel *model = dataList[i];
        NSInteger startIndex = i - 14;
        if (startIndex < 0) startIndex = 0;
        double max14 = -CGFLOAT_MAX;
        double min14 = CGFLOAT_MAX;
        for (NSInteger index = startIndex; index <= i; index ++)
        {
            max14 = MAX(max14, dataList[index].High.doubleValue);
            min14 = MIN(min14, dataList[index].Low.doubleValue);
        }
        if (i < 13) {
            model.R = kDefaultValue;
        } else {
            if (max14 - min14 == 0) {
                model.R = kDefaultValue;
            } else {
                model.R = @(100 * (max14 - dataList[i].Close.doubleValue) / (max14 - min14)).stringValue;
            }
        }
    }
}



@end
