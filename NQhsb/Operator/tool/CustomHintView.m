//
//  CustomHintView.m
//  lianxi
//
//  Created by hai on 16/10/24.
//  Copyright © 2016年 neiquan. All rights reserved.
//

#import "CustomHintView.h"
#import <Masonry/Masonry.h>
@interface CustomHintView ()
/**  backView */
@property (nonatomic,strong) UIView * backView;
/**  label */
@property (nonatomic,strong) UILabel * titlelabel;
/**  确认按钮 */
@property (nonatomic,strong) UIButton * sureBtn;
/**  取消按钮 */
@property (nonatomic,strong) UIButton * cancelBtn;
@end

@implementation CustomHintView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
#pragma mark - setup
- (void)setup
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.backView = [[UIView alloc] init];
    self.backView.alpha = 0;
    [self addSubview:self.backView];

    [UIView animateWithDuration:1 animations:^{
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        self.backView.alpha = 1;
    }];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-25) ;
        make.size.mas_offset(CGSizeMake(215, 100));
    }];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    
    self.titlelabel = [[UILabel alloc] init];
    [self.backView addSubview:self.titlelabel];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(25);
    }];
    self.titlelabel.textAlignment = NSTextAlignmentCenter;
    self.titlelabel.font = [UIFont systemFontOfSize:14];
    self.titlelabel.textColor = [UIColor blackColor];
    
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.titlelabel.mas_bottom).offset(25);
        make.size.mas_offset(CGSizeMake(85, 25));
    }];
    self.cancelBtn.backgroundColor = [UIColor redColor];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelBtn.mas_right).offset(15);
        make.top.equalTo(self.titlelabel.mas_bottom).offset(25);
        make.size.mas_offset(CGSizeMake(85, 25));
    }];
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sureBtn.backgroundColor = [UIColor colorWithRed:170 /255.0 green:170 /255.0 blue:170 /255.0 alpha:0.3];
    [self.sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - target
//确认
- (void)sureAction
{
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomHintViewDelegate_clickSureBtn)]) {
        [self.delegate CustomHintViewDelegate_clickSureBtn];
    }
}
//取消
- (void)cancelAction
{
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomHintViewDelegate_clickCancelBtn)]) {
        [self.delegate CustomHintViewDelegate_clickCancelBtn];
    }
}
- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titlelabel.text = titleText;
}
@end
