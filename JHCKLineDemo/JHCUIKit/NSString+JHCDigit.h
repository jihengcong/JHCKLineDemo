//
//  NSString+JHCDigit.h
//  btex
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, JHCTextFieldStringType) {
    JHCTextFieldStringTypeNumber,         //数字
    JHCTextFieldStringTypeLetter,         //字母
    JHCTextFieldStringTypeChinese         //汉字
};


/**
 * 按指定小数位生成字符串
 */
@interface NSString (JHCDigit)

/** 根据指定的小数位数生成字符串, 四舍五入 */
+ (NSString *)getValueStringWithCGFloat:(CGFloat)number digit:(NSInteger)digit;
/** 根据指定的小数位数生成字符串, 需注意正负数的向上/向下取整 */
+ (NSString *)getValueStringWithCGFloat:(CGFloat)number digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode;

/** 根据指定的小数位数生成字符串, 四舍五入 */
+ (double)getValueWithNumber:(NSString *)number digit:(NSInteger)digit;
/** 根据指定的小数位数生成字符串, 需注意正负数的向上/向下取整 */
+ (double)getValueWithNumber:(NSString *)number digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode;

/** 根据指定的小数位数生成字符串, 四舍五入 */
+ (NSString *)getValueStringWithNumber:(NSString *)number digit:(NSInteger)digit;
 /** 根据指定的小数位数生成字符串, 需注意正负数的向上/向下取整 */
 + (NSString *)getValueStringWithNumber:(NSString *)number digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode;

/** 数字求和, 四舍五入 */
+ (NSString *)number:(NSString *)number1 add:(NSString *)number2 digit:(NSInteger)digit;
/** 数字求和, 需注意正负数的向上/向下取整 */
+ (NSString *)number:(NSString *)number1 add:(NSString *)number2 digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode;

/** 数字求差, 四舍五入 */
+ (NSString *)number:(NSString *)number1 subtract:(NSString *)number2 digit:(NSInteger)digit;
/** 数字求差, 需注意正负数的向上/向下取整 */
+ (NSString *)number:(NSString *)number1 subtract:(NSString *)number2 digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode;

/** 数字求积, 四舍五入 */
+ (NSString *)number:(NSString *)number1 mutiply:(NSString *)number2 digit:(NSInteger)digit;
/** 数字求积, 需注意正负数的向上/向下取整 */
+ (NSString *)number:(NSString *)number1 mutiply:(NSString *)number2 digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode;

/** 数字求商, 四舍五入 */
+ (NSString *)number:(NSString *)number1 division:(NSString *)number2 digit:(NSInteger)digit;
/** 数字求商, 需注意正负数的向上/向下取整 */
+ (NSString *)number:(NSString *)number1 division:(NSString *)number2 digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode;

/** 获取小数点位数, 用于计算 */
+ (NSInteger)getStringDigitForCalculate:(NSString *)number;

/** 获取小数点位数, 用于显示，如果没有小数位则保留2位 */
+ (NSInteger)getStringDigit:(NSString *)number;

/** 根据计算的浮动盈亏取小数位 */
+ (NSInteger)getProfitDigitNumWithRiseAmount:(double)riseAmount;




/**
 某个字符串是不是数字、字母、汉字。
 */
- (BOOL)isNSC:(JHCTextFieldStringType)stringType;


/**
 字符串是不是特殊字符，此时的特殊字符就是：出数字、字母、汉字以外的。
 */
- (BOOL)isSpecialLetter;

/**
 获取字符串长度 【一个汉字算2个字符串，一个英文算1个字符串】
 */
- (int)getStrLengthWithCh2En1;

/**
 移除字符串中除exceptLetters外的所有特殊字符
 */
- (NSString *)removeSpecialLettersExceptLetters:(NSArray<NSString *> *)exceptLetters;




@end

NS_ASSUME_NONNULL_END
