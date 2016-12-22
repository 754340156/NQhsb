//
//  DeleteNoteHintView.m
//  Operator
//
//  Created by zhaozhe on 16/12/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "DeleteNoteHintView.h"

@interface DeleteNoteHintView ()
/**  backView */
@property(nonatomic,strong) UIView * backView;
/**  title */
@property(nonatomic,strong) UILabel * titleLabel;
/**  cancel */
@property(nonatomic,strong) UIButton * cancelButton;
/**  sure */
@property(nonatomic,strong) UIButton * sureButton;

@end

@implementation DeleteNoteHintView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
        [self setup];
        [self setLayout];
    }
    return self;
}
#pragma mark - setup
- (void)setup
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5.0f;
    self.backView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        self.backView.alpha = 1;
    }];
    [self addSubview:self.backView];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel sizeToFit];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"确定要删除吗?";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.titleLabel];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:KTabBarColor];
    [self.cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.cancelButton];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitle:@"确认" forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sureButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.sureButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.sureButton];
}
- (void)setLayout
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.offset(0);
        make.size.mas_offset(CGSizeMake(235, 130));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40  );
        make.centerX.offset(0);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.offset(-10);
        make.size.mas_offset(CGSizeMake(100, 24));
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(-10);
        make.size.mas_offset(CGSizeMake(100, 24));
    }];
}
#pragma mark - custom method

#pragma mark - handle action
- (void)buttonAction:(UIButton *)sender
{
    if (self.clickIsSureBlock) {
        self.clickIsSureBlock([sender isEqual:self.sureButton]);
    }
}
#pragma mark - setter model


@end
