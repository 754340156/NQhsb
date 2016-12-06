//
//  LiuXSegmentView.m
//  LiuXSegment
//
//  Created by liuxin on 16/3/18.
//  Copyright © 2016年 liuxin. All rights reserved.
//

#define windowContentWidth  ([[UIScreen mainScreen] bounds].size.width)
#define SFQRedColor [UIColor colorWithRed:255/255.0 green:92/255.0 blue:79/255.0 alpha:1]
#define MAX_TitleNumInWindow 5

#import "LiuXSegmentView.h"

@interface LiuXSegmentView()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSMutableArray *btns;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIView *selectLine;
@property (nonatomic,assign) CGFloat btn_w;
@end

@implementation LiuXSegmentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickBlick:(btnClickBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.shadowColor=[UIColor blackColor].CGColor;
        self.layer.shadowOffset=CGSizeMake(2, 2);
        self.layer.shadowRadius=2;
        self.layer.shadowOpacity=.2;
        
        _btn_w=0.0;
        if (titleArray.count<MAX_TitleNumInWindow) {
            _btn_w=windowContentWidth/titleArray.count;
        }else{
            _btn_w=windowContentWidth/MAX_TitleNumInWindow;
        }
        
        _titles =titleArray;
        [self  setSetting];
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, windowContentWidth, self.frame.size.height)];
        _bgScrollView.backgroundColor=[UIColor whiteColor];
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.contentSize=CGSizeMake(_btn_w*titleArray.count, self.frame.size.height);
//        _bgScrollView.gestureRecognizers = 
        [self addSubview:_bgScrollView];
        
        _selectLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, _btn_w, 2)];
        _selectLine.backgroundColor=_titleSelectColor;
        [_bgScrollView addSubview:_selectLine];
        _selectLine.hidden = _isShowLine;
        
#warning 要显示下滑线请把Btn高度减2  同时设置_isShowLine为YES
        
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(_btn_w*i, 0, _btn_w, self.frame.size.height);
            btn.tag=i+1;
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
            [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage createImageWithColor:_backGroudColorNormal] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage createImageWithColor:_backGroudSelectColor] forState:UIControlStateSelected];
            [btn setBackgroundColor:[UIColor redColor]];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            btn.titleLabel.font=_titleFont;
            [_bgScrollView addSubview:btn];
            [_btns addObject:btn];
            if (i==0) {
                _titleBtn=btn;
                btn.selected=YES;
            }
            self.block=block;
            
        }
    }
    
    return self;
}
-(void)setSetting
{
    _defaultIndex     =1;
    _titleFont        =[UIFont systemFontOfSize:15];
    _btns             =[[NSMutableArray alloc] initWithCapacity:0];
    _titleNomalColor  =[UIColor blackColor];
    _titleSelectColor =[UIColor redColor];
    _isShowLine       = YES;
    _backGroudSelectColor = [UIColor whiteColor];
    _backGroudColorNormal = [UIColor lightGrayColor];
}

-(void)btnClick:(UIButton *)btn{
    
    btn.backgroundColor = [UIColor whiteColor];
    if (self.block) {
        self.block(btn.tag);
    }
    
    if (btn.tag==_defaultIndex) {
        return;
    }else{
        _titleBtn.selected=!_titleBtn.selected;
        _titleBtn=btn;
        _titleBtn.selected=YES;
        _defaultIndex=btn.tag;
    }
    
    //计算偏移量
    CGFloat offsetX=btn.frame.origin.x - 2*_btn_w;
    if (offsetX<0) {
        offsetX=0;
    }
    CGFloat maxOffsetX= _bgScrollView.contentSize.width-windowContentWidth;
    if (offsetX>maxOffsetX) {
        offsetX=maxOffsetX;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        
        [_bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _selectLine.frame=CGRectMake(btn.frame.origin.x, self.frame.size.height-2, btn.frame.size.width, 2);
        
    } completion:^(BOOL finished) {
        
    }];
    
}



-(void)setTitleNomalColor:(UIColor *)titleNomalColor{
    _titleNomalColor=titleNomalColor;
    [self updateView];
}

-(void)setTitleSelectColor:(UIColor *)titleSelectColor{
    _titleSelectColor=titleSelectColor;
    [self updateView];
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont=titleFont;
    [self updateView];
}

-(void)setDefaultIndex:(NSInteger)defaultIndex{
    _defaultIndex=defaultIndex;
    [self updateView];
}
-(void)setIsShowLine:(BOOL)isShowLine
{
    _isShowLine = isShowLine;
    [self updateView];
}
-(void)setBackGroudSelectColor:(UIColor *)backGroudSelectColor
{
    _backGroudSelectColor = backGroudSelectColor;
    [self updateView];
}
-(void)setBackGroudColorNormal:(UIColor *)backGroudColorNormal
{
    _backGroudColorNormal = backGroudColorNormal;
    [self updateView];
}

-(void)updateView{
    for (UIButton *btn in _btns) {
        [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage createImageWithColor:_backGroudColorNormal] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage createImageWithColor:_backGroudSelectColor] forState:UIControlStateSelected];
        btn.titleLabel.font=_titleFont;
        _selectLine.backgroundColor=_titleSelectColor;
        
        if (btn.tag-1==_defaultIndex-1) {
            _titleBtn=btn;
            btn.selected=YES;
            if(_isShowLine)_selectLine.frame=CGRectMake(btn.frame.origin.x, self.frame.size.height-2, btn.frame.size.width, 2);
            else _selectLine.hidden = YES;
        }else{
            btn.selected=NO;
        }
    }
    if (self.block) {
        self.block(_defaultIndex);
    }
}

@end
