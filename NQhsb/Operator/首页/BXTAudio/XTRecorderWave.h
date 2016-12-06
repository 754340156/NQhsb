//
//  XTRecorderWave.h
//  Operator
//
//  Created by 白小田 on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTRecorderWave : UIView
IBInspectable @property float sampleWidth;
IBInspectable @property float intervalTime;
@property (nonatomic, strong) NSMutableArray *samples;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addSamples:(NSNumber *)value;
@end
