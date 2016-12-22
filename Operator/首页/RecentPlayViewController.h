//
//  RecentPlayViewController.h
//  Operator
//
//  Created by 白小田 on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "NavViewController.h"

@interface RecentPlayViewController : NavViewController

kBxtPropertyStrong NSString *selectType;

kBxtPropertyStrong NSString *api;

/**  是不是我的录音 */
@property(nonatomic,assign) BOOL isMyAudio;

@end
