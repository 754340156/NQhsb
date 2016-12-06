//
//  HWMusicquestionReportViewController.h
//  Operator
//
//  Created by 白小田 on 2016/11/4.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWMusicquestionReportViewController : NavViewController

/**
 *  h5
 */
kBxtPropertyStrong NSString *loadUrl;

/**
 *  录音分析ID
 */
kBxtPropertyStrong NSString *questionlogId;

/**
 *  入口判断 YES 第一个录音分析页  NO 
 */
kBxtPropertyNonatomic BOOL isMain;
@end
