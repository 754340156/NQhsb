//
//  LXSegmentScrollView.h
//  LiuXSegment
//
//  Created by liuxin on 16/5/17.
//  Copyright © 2016年 liuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiuXSegmentView.h"
@interface LXSegmentScrollView : UIView

-(instancetype)initWithFrame:(CGRect)frame
                  titleArray:(NSArray *)titleArray
            contentViewArray:(NSArray *)contentViewArray
                  SuccessBlock:(void(^)(NSInteger index))successBlock;
@property (strong,nonatomic)UIScrollView *bgScrollView;
@property (strong,nonatomic)LiuXSegmentView *segmentToolView;
@property (strong,nonatomic)NSArray *countArr;
@end
