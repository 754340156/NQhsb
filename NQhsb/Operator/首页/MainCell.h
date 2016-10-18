//
//  MainCell.h
//  Operator
//
//  Created by 白小田 on 16/9/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCell : UITableViewCell

/**
 *  大讲堂
 */
@property (weak, nonatomic) IBOutlet UIButton *kBxtBigForum;

/**
 *  话术本
 */
@property (weak, nonatomic) IBOutlet UIButton *kBxtOperation;


/**
 *  录音库
 */
@property (weak, nonatomic) IBOutlet UIButton *kBxtRecording;


/**
 *  工作日志
 */
@property (weak, nonatomic) IBOutlet UIButton *kBxtJobLog;


/**
 *  学习计划
 */
@property (weak, nonatomic) IBOutlet UIButton *kBxtLearningPlan;


/**
 *  音乐分析
 */
@property (weak, nonatomic) IBOutlet UIButton *kBxtMusicAnalysis;


@end
