//
//  UIImage+YXL.h
//  Plague
//
//  Created by Yexinglong on 15/1/9.
//  Copyright (c) 2015年 Yexinglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XB)
/**
 *  将颜色变成image
 *
 *  @param color 颜色值
 *
 *  @return 返回一个带有颜色的image
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;
/**
 *  图片剪裁圆形
 *
 *  @param imageV      需要剪裁图片
 *  @param borderWidth 剪裁后的外圆线的宽度，可为0
 *  @param borderColor 外圆线的颜色，不需要可为nil
 *
 *  @return 返回一个剪裁后的图片
 */
+ (UIImage *)circleImage:(UIImage *)imageV borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/**
 *  视频截图
 *
 *  @param VideoUrl 视频的URL
 *
 *  @return 返回视频第一帧图片
 */
+(UIImage *)getVideoPreViewImage:(NSURL*)VideoUrl;
@end
