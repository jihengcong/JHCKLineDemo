//
//  JHCLabelUtil.m
//  btex
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 btex.me. All rights reserved.
//

#import "JHCLabelUtil.h"
#import <CoreText/CoreText.h>


@implementation JHCLabelUtil

/**
 * 创建label, 头部带图片
 **/
+ (JHCLabelUtil *)createLabelWithFrame:(CGRect)frame labelText:(NSString * _Nullable)labelText textColor:(UIColor * _Nullable)textColor textFont:(UIFont * _Nullable)textFont textAligment:(NSTextAlignment)textAligment headerImage:(UIImage * _Nullable)headerImage
{
    JHCLabelUtil *label = [self createLabelWithFrame:frame labelText:labelText textColor:textColor textFont:textFont textAligment:textAligment];
    if (headerImage)
    {
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = headerImage;
        attach.bounds = CGRectMake(0, -4, 20, 20);
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:labelText];
        [attStr insertAttributedString:[NSAttributedString attributedStringWithAttachment:attach] atIndex:0];
        [attStr insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];
        label.attributedText = attStr;
    }
    return label;
}

//创建label
+ (JHCLabelUtil *)createLabelWithFrame:(CGRect)frame labelText:(NSString * _Nullable)labelText textColor:(UIColor * _Nullable)textColor textFont:(UIFont * _Nullable)textFont textAligment:(NSTextAlignment)textAligment
{
    JHCLabelUtil *label = [[JHCLabelUtil alloc] initWithFrame:frame];
    if (labelText) label.text = labelText;
    if (textColor) label.textColor = textColor;
    if (textFont) label.font = textFont;
    label.textAlignment = textAligment;
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentInset)];
}

#pragma mark - Margin相关设置
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect rect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    // 根据contentInset设置Label的bounds
    rect.origin.x -= self.contentInset.left;
    rect.origin.y -= self.contentInset.top;
    rect.size.width += self.contentInset.left + self.contentInset.right;
    rect.size.height += self.contentInset.top + self.contentInset.bottom;
    return rect;
}

#pragma mark - 设置UILabel的左右对齐
- (void)setAlignmentRightAndLeft:(BOOL)alignmentRightAndLeft
{
    _alignmentRightAndLeft = alignmentRightAndLeft;
    if(alignmentRightAndLeft){
        [self textAlignmentLeftAndRightWith:CGRectGetWidth(self.frame)];
    }
    
}

- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth{
    if(self.text==nil||self.text.length==0) {
        return;
    }
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(labelWidth,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil].size;
    NSInteger length = (self.text.length-1);
    NSString* lastStr = [self.text substringWithRange:NSMakeRange(self.text.length-1,1)];
    if([lastStr isEqualToString:@":"]||[lastStr isEqualToString:@"："]) {
        length = (self.text.length-2);
    }
    CGFloat margin = (labelWidth - size.width)/length;
    NSNumber*number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attribute addAttribute:NSKernAttributeName value:number range:NSMakeRange(0,length)];
    self.attributedText= attribute;
}

@end
