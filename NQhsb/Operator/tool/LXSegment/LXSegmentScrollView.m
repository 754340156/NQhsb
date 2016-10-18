//
//  LXSegmentScrollView.m
//  LiuXSegment
//
//  Created by liuxin on 16/5/17.
//  Copyright © 2016年 liuxin. All rights reserved.
//

#define MainScreen_W [UIScreen mainScreen].bounds.size.width

#import "LXSegmentScrollView.h"


@interface LXSegmentScrollView()<UIScrollViewDelegate>
//@property (strong,nonatomic)UIScrollView *bgScrollView;
//@property (strong,nonatomic)LiuXSegmentView *segmentToolView;
//@property (strong,nonatomic)NSArray *countArr;

@end

@implementation LXSegmentScrollView

-(instancetype)initWithFrame:(CGRect)frame
                  titleArray:(NSArray *)titleArray
            contentViewArray:(NSArray *)contentViewArray
                SuccessBlock:(void (^)(NSInteger))successBlock
{
    if (self = [super initWithFrame:frame]) {
        
        
        
        
        _segmentToolView=[[LiuXSegmentView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_W, 44) titles:titleArray clickBlick:^void(NSInteger index) {
            NSLog(@"-----%ld",index);
            [_bgScrollView setContentOffset:CGPointMake(MainScreen_W*(index-1), 0)];
            successBlock(index);
        }];
        self.countArr = titleArray;
        [self addSubview:_segmentToolView];
        [self addSubview:self.bgScrollView];
        
        for (int i=0;i<contentViewArray.count; i++ ) {
            
            UIView *contentView = (UIView *)contentViewArray[i];
            contentView.frame=CGRectMake(MainScreen_W * i, 0, MainScreen_W, _bgScrollView.frame.size.height);
            [_bgScrollView addSubview:contentView];
        }
        
        
    }
    
    return self;
}

-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentToolView.frame.size.height, MainScreen_W, self.bounds.size.height-_segmentToolView.bounds.size.height)];
        _bgScrollView.contentSize=CGSizeMake(MainScreen_W*self.countArr.count, self.bounds.size.height-_segmentToolView.bounds.size.height);
        _bgScrollView.backgroundColor=[UIColor whiteColor];
        _bgScrollView.showsVerticalScrollIndicator=NO;
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.delegate=self;
        _bgScrollView.bounces=NO;
        _bgScrollView.pagingEnabled=YES;
    }
    return _bgScrollView;
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_bgScrollView)
    {
        NSInteger p=_bgScrollView.contentOffset.x/MainScreen_W;
        _segmentToolView.defaultIndex=p+1;
        
    }
    
}
@end
