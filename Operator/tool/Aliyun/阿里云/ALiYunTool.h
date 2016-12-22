//
//  ALiYunTool.h
//  Employ
//
//  Created by YuanZhiPu on 15/10/19.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliyunOSSiOS/OSSService.h"
typedef NS_ENUM(NSInteger, UploadImageState)
{
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};

@interface ALiYunTool : NSObject

/**
 *  上传阿里云（图片）
 *  @return  requestIdString
 */
+ (NSString *)upLoadImage:(UIImage *)image;

//异步上传多张图片 --->有问题--->阻塞主线程
+ (void)asyncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;

+ (NSString*)asyncUploadVideoPath:(NSString *)videoPath complete:(void(^)( UploadImageState state))complete;
@end
