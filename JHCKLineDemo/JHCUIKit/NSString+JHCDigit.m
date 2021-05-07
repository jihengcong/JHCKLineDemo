//
//  NSString+JHCDigit.m
//  btex
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import "NSString+JHCDigit.h"


@implementation NSString (JHCDigit)

/** 根据指定的小数位数生成字符串 **/
+ (NSString *)getValueStringWithCGFloat:(CGFloat)number digit:(NSInteger)digit
{
    return [self getValueStringWithCGFloat:number digit:digit roundingMode:NSRoundPlain];
}

/** 根据指定的小数位数生成字符串 */
+ (double)getValueWithNumber:(NSString *)number digit:(NSInteger)digit
{
    return [self getValueWithNumber:number digit:digit roundingMode:NSRoundPlain];
}

/** 根据指定的小数位数生成字符串 */
+ (NSString *)getValueStringWithNumber:(NSString *)number digit:(NSInteger)digit
{
    return [self getValueStringWithNumber:number digit:digit roundingMode:NSRoundPlain];
}
 
/** 数字求和 */
+ (NSString *)number:(NSString *)number1 add:(NSString *)number2 digit:(NSInteger)digit
{
    return [self number:number1 add:number2 digit:digit roundingMode:NSRoundPlain];
}

/** 数字求差 */
+ (NSString *)number:(NSString *)number1 subtract:(NSString *)number2 digit:(NSInteger)digit
{
    return [self number:number1 subtract:number2 digit:digit roundingMode:NSRoundPlain];
}

/** 数字求积 */
+ (NSString *)number:(NSString *)number1 mutiply:(NSString *)number2 digit:(NSInteger)digit
{
    return [self number:number1 mutiply:number2 digit:digit roundingMode:NSRoundPlain];
}

/** 数字求商 */
+ (NSString *)number:(NSString *)number1 division:(NSString *)number2 digit:(NSInteger)digit
{
    return [self number:number1 division:number2 digit:digit roundingMode:NSRoundPlain];
}

/** 根据指定的小数位数生成字符串 */
+ (NSString *)getValueStringWithCGFloat:(CGFloat)number digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode
{
    NSDecimalNumber *num = [[NSDecimalNumber alloc] initWithDouble:number];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:digit raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *afterNum = [num decimalNumberByRoundingAccordingToBehavior:roundUp];
    NSString *string = [afterNum stringValue];
    if ([string rangeOfString:@"."].length==0&&digit>0) {
        NSMutableString *suffString = [[NSMutableString alloc] initWithString:@"."];
        for (int index =0; index<digit; index++) {
            [suffString appendString:@"0"];
        }
        return [NSString stringWithFormat:@"%@%@",string,suffString];
    }else if ([string rangeOfString:@"."].length!=0&&digit>0){
        NSArray *array = [string componentsSeparatedByString:@"."];
        NSString *smallStr = [array lastObject];
        if (smallStr.length<digit) {
            NSUInteger count = digit-smallStr.length;
            for (int index = 0; index<count; index++) {
                smallStr = [smallStr stringByAppendingString:@"0"];
            }
            return [NSString stringWithFormat:@"%@.%@",array.firstObject,smallStr];
        }
    }
    return string;
}

/** 根据指定的小数位数生成字符串 **/
+ (double)getValueWithNumber:(NSString *)number digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode
{
    if (!number||number.length==0||[number hasSuffix:@"-"]) {
        number = @"0";
    }
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:number];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:digit raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *afterNum = [num decimalNumberByRoundingAccordingToBehavior:roundUp];
    return [afterNum doubleValue];
}

/** 根据指定的小数位数生成字符串 **/
+ (NSString *)getValueStringWithNumber:(NSString *)number digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode
{
    if (!number||number.length==0||[number hasSuffix:@"-"]) {
        number = @"0";
    }
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:number];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:digit raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *afterNum = [num decimalNumberByRoundingAccordingToBehavior:roundUp];
    NSString *string = [afterNum stringValue];
    if ([string rangeOfString:@"."].length==0&&digit>0) {
        NSMutableString *suffString = [[NSMutableString alloc] initWithString:@"."];
        for (int index =0; index<digit; index++) {
            [suffString appendString:@"0"];
        }
        return [NSString stringWithFormat:@"%@%@",string,suffString];
    }else if ([string rangeOfString:@"."].length!=0&&digit>0){
        NSArray *array = [string componentsSeparatedByString:@"."];
        NSString *smallStr = [array lastObject];
        if (smallStr.length<digit) {
            NSInteger count = digit-(int)smallStr.length;
            for (int index = 0; index<count; index++) {
                smallStr = [smallStr stringByAppendingString:@"0"];
            }
            return [NSString stringWithFormat:@"%@.%@",array.firstObject,smallStr];
        }
    }
    return string;
}


// 数字求和
+(NSString *)number:(NSString *)number1 add:(NSString *)number2 digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode
{
    if (!number1||number1.length==0||[number1 hasSuffix:@"-"]) {
        number1 = @"0";
    }
    if (!number2||number2.length==0||[number2 hasSuffix:@"-"]) {
        number2 = @"0";
    }
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:number1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:number2];
    
     NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:digit raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *afterNum =[num1 decimalNumberByAdding:num2 withBehavior:roundUp];
    
    NSString *string = [afterNum stringValue];
    if ([string rangeOfString:@"."].length==0&&digit>0) {
        NSMutableString *suffString = [[NSMutableString alloc] initWithString:@"."];
        for (int index =0; index<digit; index++) {
            [suffString appendString:@"0"];
        }
        return [NSString stringWithFormat:@"%@%@",string,suffString];
    }else if ([string rangeOfString:@"."].length!=0&&digit>0){
        NSArray *array = [string componentsSeparatedByString:@"."];
        NSString *smallStr = [array lastObject];
        if (smallStr.length<digit) {
            NSInteger count = digit-(int)smallStr.length;
            for (int index = 0; index<count; index++) {
                smallStr = [smallStr stringByAppendingString:@"0"];
            }
            return [NSString stringWithFormat:@"%@.%@",array.firstObject,smallStr];
        }
    }
    return string;
}

// 数字求差
+ (NSString *)number:(NSString *)number1 subtract:(NSString *)number2 digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode
{
    if (!number1||number1.length==0||[number1 hasSuffix:@"-"]) {
        number1 = @"0";
    }
    if (!number2||number2.length==0||[number2 hasSuffix:@"-"]) {
        number2 = @"0";
    }
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:number1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:number2];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:digit raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *afterNum =[num1 decimalNumberBySubtracting:num2 withBehavior:roundUp];
    NSString *string = [afterNum stringValue];
    if ([string rangeOfString:@"."].length==0&&digit>0) {
        NSMutableString *suffString = [[NSMutableString alloc] initWithString:@"."];
        for (int index =0; index<digit; index++) {
            [suffString appendString:@"0"];
        }
        return [NSString stringWithFormat:@"%@%@",string,suffString];
    }else if ([string rangeOfString:@"."].length!=0&&digit>0){
        NSArray *array = [string componentsSeparatedByString:@"."];
        NSString *smallStr = [array lastObject];
        if (smallStr.length<digit) {
            NSInteger count = digit-(int)smallStr.length;
            for (int index = 0; index<count; index++) {
                smallStr = [smallStr stringByAppendingString:@"0"];
            }
            return [NSString stringWithFormat:@"%@.%@",array.firstObject,smallStr];
        }
    }
    return string;
}

/** 数字求积 */
+(NSString *)number:(NSString *)number1 mutiply:(NSString *)number2 digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode
{
    if (!number1||number1.length==0||[number1 hasSuffix:@"-"]) {
        number1 = @"0";
    }
    if (!number2||number2.length==0||[number2 hasSuffix:@"-"]) {
        number2 = @"0";
    }
    
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:number1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:number2];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:digit raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *afterNum =[num1 decimalNumberByMultiplyingBy:num2 withBehavior:roundUp];
    
    NSString *string = [afterNum stringValue];
    if ([string rangeOfString:@"."].length==0&&digit>0) {
        NSMutableString *suffString = [[NSMutableString alloc] initWithString:@"."];
        for (int index =0; index<digit; index++) {
            [suffString appendString:@"0"];
        }
        return [NSString stringWithFormat:@"%@%@",string,suffString];
    }else if ([string rangeOfString:@"."].length!=0&&digit>0){
        NSArray *array = [string componentsSeparatedByString:@"."];
        NSString *smallStr = [array lastObject];
        if (smallStr.length<digit) {
            NSInteger count = digit-(int)smallStr.length;
            for (int index = 0; index<count; index++) {
                smallStr = [smallStr stringByAppendingString:@"0"];
            }
            return [NSString stringWithFormat:@"%@.%@",array.firstObject,smallStr];
        }
    }
    return string;
}

/** 数字求商 */
+(NSString *)number:(NSString *)number1 division:(NSString *)number2 digit:(NSInteger)digit roundingMode:(NSRoundingMode)roundingMode
{
    if (!number1||number1.length==0||[number1 hasSuffix:@"-"]) {
        number1 = @"0";
    }
    if (!number2||number2.length==0||[number2 hasSuffix:@"-"]) {
        number2 = @"0";
    }
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:number1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:number2];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:digit raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *afterNum =[num1 decimalNumberByDividingBy:num2 withBehavior:roundUp];
    
    NSString *string = [afterNum stringValue];
    if ([string rangeOfString:@"."].length==0&&digit>0) {
        NSMutableString *suffString = [[NSMutableString alloc] initWithString:@"."];
        for (int index =0; index<digit; index++) {
            [suffString appendString:@"0"];
        }
        return [NSString stringWithFormat:@"%@%@",string,suffString];
    }else if ([string rangeOfString:@"."].length!=0&&digit>0){
        NSArray *array = [string componentsSeparatedByString:@"."];
        NSString *smallStr = [array lastObject];
        if (smallStr.length<digit) {
            NSInteger count = digit-(NSInteger)smallStr.length;
            for (int index = 0; index<count; index++) {
                smallStr = [smallStr stringByAppendingString:@"0"];
            }
            return [NSString stringWithFormat:@"%@.%@",array.firstObject,smallStr];
        }
    }
    return string;
}

/** 获取小数点位数, 用于计算 */
+ (NSInteger)getStringDigitForCalculate:(NSString *)number
{
    if ([number rangeOfString:@"."].length == 0) {
        return 0;
    }
    if (!number || number.length==0 || [number hasSuffix:@"-"]) {
        return 2;
    }
    NSUInteger length = number.length - [number rangeOfString:@"."].location-1;
    return (NSInteger)length;
}

/** 获取小数点位数, 用于显示，如果没有小数位则保留2位 */
+ (NSInteger)getStringDigit:(NSString *)number
{
    if (!number || number.length==0 || [number hasSuffix:@"-"] || [number rangeOfString:@"."].length == 0) {
        return 2;
    }
    NSUInteger length = number.length - [number rangeOfString:@"."].location-1;
    return (NSInteger)length;
}

// 根据计算的浮动盈亏取小数位
+ (NSInteger)getProfitDigitNumWithRiseAmount:(double)riseAmount
{
    NSInteger digit = 2;
    if (fabs(riseAmount) >= 0.1) digit = 2;
    else if (fabs(riseAmount) < 0.01) digit = 6;
    else digit = 4;
    return digit;
}






- (BOOL)isNSC:(JHCTextFieldStringType)stringType
{
    return [self matchRegularWith:stringType];
}
- (BOOL)isSpecialLetter
{
    if ([self isNSC:JHCTextFieldStringTypeNumber] || [self isNSC:JHCTextFieldStringTypeLetter] || [self isNSC:JHCTextFieldStringTypeChinese]) {
        return NO;
    }
    return YES;
}
#pragma mark --- 用正则判断条件
- (BOOL)matchRegularWith:(JHCTextFieldStringType)type
{
    NSString *regularStr = @"";
    switch (type) {
        case JHCTextFieldStringTypeNumber:      //数字
            regularStr = @"^[0-9]*$";
            break;
        case JHCTextFieldStringTypeLetter:      //字母
            regularStr = @"^[A-Za-z]+$";
            break;
        case JHCTextFieldStringTypeChinese:     //汉字
            regularStr = @"^[\u4e00-\u9fa5]{0,}$";
            break;
        default:
            break;
    }
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularStr];
    
    if ([regextestA evaluateWithObject:self] == YES){
        return YES;
    }
    return NO;
}
- (int)getStrLengthWithCh2En1
{
    int strLength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strLength++;
        }else {
            p++;
        }
    }
    return strLength;
}

- (NSString *)removeSpecialLettersExceptLetters:(NSArray<NSString *> *)exceptLetters
{
    if (self.length > 0) {
        NSMutableString *resultStr = [[NSMutableString alloc]init];
        for (int i = 0; i<self.length; i++) {
            NSString *indexStr = [self substringWithRange:NSMakeRange(i, 1)];
            
            if (![indexStr isSpecialLetter] || (exceptLetters && [exceptLetters containsObject:indexStr])) {
                [resultStr appendString:indexStr];
            }
        }
        if (resultStr.length > 0) {
            return resultStr;
        }else{
            return @"";
        }
    }else{
        return @"";
    }
}





@end
