//
//  AudioPlayViewController.h
//  Operator
//
//  Created by 白小田 on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "NavViewController.h"

@interface AudioPlayViewController : NavViewController
@property (nonatomic,strong) NSString *audioPath;

@property (nonatomic,strong) NSString *audioUrl;

/*
 * 5 录音本添加新录音   3 话术本添加录音话术
 */
@property (nonatomic,strong) NSString *selectType;

@property (nonatomic,strong) NSString *api;
@end
