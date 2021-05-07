//
//  JHCKLineTheme.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import "JHCKLineTheme.h"


@implementation JHCKLineTheme

// 根据文字的字体计算大小
+ (CGRect)getRectWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return rect;
}

// 根据RGBA返回颜色
+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a
{
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a];
}

// 根据十六进制返回颜色
+ (UIColor *)colorWithHex:(NSUInteger)hexValue
{
    return [UIColor colorWithRed:((hexValue & 0xFF0000) >> 16)/255.f green:((hexValue & 0x00FF00) >> 8)/255.f blue:((hexValue & 0xFF) >> 0)/255.f alpha:((hexValue & 0xFF000000) >> 24)/225.f];
}



@end
