//
//  HWMusicAnswerController.h
//  Operator
//
//  Created by NeiQuan on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "NavViewController.h"

@interface HWMusicAnswerController : NavViewController

/**
 *  题库数据 （上个页面传过来）
 */
@property(nonatomic,retain)NSMutableArray *dataListArray;

/**
 *  模版id
 */
@property(nonatomic,retain)NSString       *selectId;

/**
 * 未生成的录音分析id （从录音分析首页传过来）
 */
@property(nonatomic,retain)NSString       *questionlogId;

@property(nonatomic,retain)NSString       *urlIds;
@end
