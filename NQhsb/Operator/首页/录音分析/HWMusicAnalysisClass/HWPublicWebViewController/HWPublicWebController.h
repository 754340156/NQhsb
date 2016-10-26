//
//  HWPublicWebController.h
//  Operator
//
//  Created by NeiQuan on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "NavViewController.h"

  //@param type        类型  1 大讲堂(销售职)  2 大讲堂(管理职)  3 话术本  4 大咖讲话术  5 录音库  6 工作日志  7 录音分析
@interface HWPublicWebController : NavViewController

@property(nonatomic,copy)NSString     *RelevanceId;
@property(nonatomic,copy)NSString     *type;

@end
