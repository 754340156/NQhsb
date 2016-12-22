//
//  HWMusicAnimationController.h
//  Operator
//
//  Created by NeiQuan on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "NavViewController.h"

@interface HWMusicAnimationController : NavViewController

//用于统计模板问题数据
@property(nonatomic,retain)NSMutableArray *questionDataArray;

/**
 *  用于传到下个页面
 */
@property(nonatomic,retain)NSString *relevanceId;
@end
