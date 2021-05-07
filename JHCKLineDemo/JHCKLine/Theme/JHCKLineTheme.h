//
//  JHCKLineTheme.h
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface JHCKLineTheme : NSObject

// 根据文字的字体计算大小
+ (CGRect)getRectWithString:(NSString *)string font:(UIFont *)font;

// 根据RGBA返回颜色
+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;

// 根据十六进制返回颜色
+ (UIColor *)colorWithHex:(NSUInteger)hexValue;


@end

NS_ASSUME_NONNULL_END
