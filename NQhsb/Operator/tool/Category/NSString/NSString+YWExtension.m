//
//  NSString+YWExtension.m
//  YWBaseFrameWork
//
//  Created by mac on 16/7/17.
//  Copyright © 2016年 NeiQuan. All rights reserved.
//

#import "NSString+YWExtension.h"

@implementation NSString (YWExtension)
/// 验证字符串为空 ,为空:YES, 不为空:NO
+ (BOOL)StringIsNULL:(NSString *)string
{
    if (string == nil || string == NULL || [string  isEqual:NULL]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}
/// 验证手机号码, 正确:YES , 错误: 提示
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    //NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[06-8]|8[0-9])\\d{8}$";
    NSString *MOBILE = @"^((13[0-9])|(15[0-9])|(18[0-9])|(17[0-9])|(14[0-9]))\\d{8}$";
    //NSString *MOBILE = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    return NO;
}

//判断某个字符串的长度是否在某个范围内0除外
- (BOOL)RangeMinNum:(int) minNum maxNum:(int) maxNum
{
    if ((self.length>=minNum)&&(self.length<=maxNum)&&(self.length!=0))
    {
        return YES;
    }
    return NO;
}
//判断是否只有数字或字母
- (BOOL)isOnlyNumAndLetter;
{
    NSString *regex = @"[a-z][A-Z][0-9]";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:self] == YES) {
        return YES;
    }
    return NO;
}
//判断是否全为中文
+(BOOL)isValidateHomePhoneNum:(NSString *)string
{
    // 只需要不是中文即可
    NSString *regex = @".{0,}[\u4E00-\u9FA5].{0,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    BOOL res = [predicate evaluateWithObject:string];
    if (res == TRUE) {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

+ (BOOL)isWheatNumber:(NSString *)str
{
    
    NSString *regex = @"^[a-zA-Zd_]{5,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    BOOL res = [predicate evaluateWithObject:str];
    if (res) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

/* 判断文本是否包含emoji */
+ (BOOL)isContainsEmoji:(NSString *)string{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             
             if (0x2100 <= hs && hs <= 0x27ff /*&& hs != 0x263b*/) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 /*|| hs == 0x231a*/ ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}
//银行卡判断  -——>不适合16位以上信用卡的判断
+ (BOOL)isValidCreditNumber:(NSString*)value
{
    BOOL result = TRUE;
    NSInteger length = [value length];
    if (length >= 13)
    {
        result = [NSString  isPureNumandCharacters:value];
        if (result)
        {
            NSInteger twoDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 2)] integerValue];
            NSInteger threeDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 3)] integerValue];
            NSInteger fourDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 4)] integerValue];
            //Diner's Club
            if (((threeDigitBeginValue >= 300 && threeDigitBeginValue <= 305)||
                 fourDigitBeginValue == 3095||twoDigitBeginValue==36||twoDigitBeginValue==38) && (14 != length))
            {
                result = FALSE;
            }
            //VISA
            else if([value  hasPrefix :@"4"] && !(13 == length||16 == length))
            {
                result = FALSE;
            }
            //MasterCard
            else if((twoDigitBeginValue >= 51||twoDigitBeginValue <= 55) && (16 != length))
            {
                result = FALSE;
            }
            //American Express
            else if(([value  hasPrefix :@"34"]||[value hasPrefix:@"37"]) && (15 != length))
            {
                result = FALSE;
            }
            //Discover
            else if([value hasPrefix:@"6011"] && (16 != length))
            {
                result = FALSE;
            }
            else
            {
                NSInteger begin = [[value substringWithRange:NSMakeRange(0, 6)] integerValue];
                //CUP
                if ((begin >= 622126 && begin <= 622925) && (16 != length))
                {
                    result = FALSE;
                }
                //other
                else
                {
                    result = TRUE;
                }
            }
        }
        if (result)
        {
            NSInteger digitValue;
            NSInteger checkSum = 0;
            NSInteger index = 0;
            NSInteger leftIndex;
            //even length, odd index
            if (0 == length%2)
            {
                index = 0;
                leftIndex = 1;
            }
            //odd length, even index
            else
            {
                index = 1;
                leftIndex = 0;
            }
            while (index < length)
            {
                digitValue = [[value substringWithRange:NSMakeRange(index, 1)] integerValue];
                digitValue = digitValue*2;
                if (digitValue >= 10)
                {
                    checkSum += digitValue/10 + digitValue%10;
                }
                else
                {
                    checkSum += digitValue;
                }
                digitValue = [[value substringWithRange:NSMakeRange(leftIndex, 1)] integerValue];
                checkSum += digitValue;
                index += 2;
                leftIndex += 2;
            }
            result = (0 == checkSum%10) ? TRUE:FALSE;
        }
    }
    else
    {
        result = FALSE;
    }
    return result;

}
#pragma mark - 计算文本
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width{
    

        UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
        
        CGSize textSize;
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
        if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
        {
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                         NSParagraphStyleAttributeName: paragraph};
            textSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                            options:(NSStringDrawingUsesLineFragmentOrigin |
                                                     NSStringDrawingTruncatesLastVisibleLine)
                                         attributes:attributes
                                            context:nil].size;
        } else
        {
            textSize = [string sizeWithFont:textFont
                          constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                              lineBreakMode:NSLineBreakByWordWrapping];
        }
#else
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:(NSStringDrawingUsesLineFragmentOrigin |
                                                 NSStringDrawingTruncatesLastVisibleLine)
                                     attributes:attributes
                                        context:nil].size;
#endif
        
        return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
 
}
// 去除尾部space, /n, /t
+(NSString*)trimWithstring:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
