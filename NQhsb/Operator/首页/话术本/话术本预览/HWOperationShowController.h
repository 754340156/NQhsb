//
//  HWOperationShowController.h
//  Operator
//
//  Created by hai on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "NavViewController.h"

@interface HWOperationShowController : NavViewController
/*
 *  1大讲堂(销售职) 2大讲堂(管理职) 3话术本 4大咖讲话术
 */
@property (nonatomic, copy) NSString *selectType;
/*
 *  recordinglist   or  checklist
 */
@property (nonatomic, copy) NSString *apiStr;
/**  title */
@property (nonatomic, copy) NSString * titleText;
@end
