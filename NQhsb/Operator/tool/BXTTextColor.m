//
//  BXTTextColor.m
//  Hippo
//
//  Created by 白小田 on 16/8/27.
//  Copyright © 2016年 jock. All rights reserved.
//

#import "BXTTextColor.h"
#import <CoreText/CTStringAttributes.h>

@implementation BXTTextColor

+ (NSMutableAttributedString *)getAcolorfulStringWithText1:(NSString *)text1 Color1:(UIColor *)color1 Font1:(UIFont *)font1 Text2:(NSString *)text2 Color2:(UIColor *)color2 Font2:(UIFont *)font2 AllText:(NSString *)allText
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allText];
    [str beginEditing];
    if (text1) {
        NSRange range1 = [allText rangeOfString:text1];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color1 range:range1];
        if (font1) {
            [str addAttribute:NSFontAttributeName value:font1 range:range1];
        }
    }
    
    if (text2) {
        NSRange range2 = [allText rangeOfString:text2];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color2 range:range2];
        if (font2) {
            [str addAttribute:NSFontAttributeName value:font2 range:range2];
        }
    }
    
    [str endEditing];
    
    return str;
}

+ (NSMutableAttributedString *)ls_changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    long number = space;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    return attributedStr;
}

+ (NSMutableAttributedString *)ls_changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    return attributedStr;
}

+ (NSMutableAttributedString *)ls_changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    long number = textSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    return attributedStr;
}

+ (NSMutableAttributedString *)ls_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    for (NSString *rangeStr in subArray) {
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    return attributedStr;
}




@end
