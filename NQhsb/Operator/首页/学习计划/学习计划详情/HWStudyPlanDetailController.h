//
//  HWStudyPlanDetailController.h
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "NavViewController.h"

@interface HWStudyPlanDetailController : NavViewController
/**  展示,删除学习计划的时候传入dataId */
@property (nonatomic,copy) NSString * dataId;
/**  下面的tableView数据源 */
@property (nonatomic,strong) NSArray * dataArray;

@property (nonatomic,strong) NSString *kTitle;
@end
