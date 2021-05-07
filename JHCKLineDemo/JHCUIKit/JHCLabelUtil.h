//
//  JHCLabelUtil.h
//  btex
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCLabelUtil : UILabel

/**
 设置UILable的左右间隙
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 设置UILable的左右对齐
 注意点：
 要在设置了UILabel的frame和text后使用
 */
@property (nonatomic, assign) BOOL alignmentRightAndLeft;

/**
 * 创建label
 **/
+ (JHCLabelUtil *)createLabelWithFrame:(CGRect)frame labelText:(NSString * _Nullable)labelText textColor:(UIColor * _Nullable)textColor textFont:(UIFont * _Nullable)textFont textAligment:(NSTextAlignment)textAligment;

/**
 * 创建label, 头部带图片
 **/
+ (JHCLabelUtil *)createLabelWithFrame:(CGRect)frame labelText:(NSString * _Nullable)labelText textColor:(UIColor * _Nullable)textColor textFont:(UIFont * _Nullable)textFont textAligment:(NSTextAlignment)textAligment headerImage:(UIImage * _Nullable)headerImage;


@end

NS_ASSUME_NONNULL_END
