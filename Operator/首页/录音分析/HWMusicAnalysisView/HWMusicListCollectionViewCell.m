//
//  HWMusicListCollectionViewCell.m
//  Operator
//
//  Created by NeiQuan on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicListCollectionViewCell.h"
#import "HWMusicAnalysicModel.h"
@implementation HWMusicListCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    __weak typeof(self)weakself=self;
    [_startAnsstis addTarget:weakself action:@selector(clickstartbutton) forControlEvents:UIControlEventTouchUpInside];
    _backImageView.layer.masksToBounds=YES;
    _backImageView.layer.cornerRadius = 3;
    _startAnsstis.layer.masksToBounds = YES;
    _startAnsstis.layer.cornerRadius  = 3;
    _startAnsstis.backgroundColor = KTabBarColor;
}
#pragma mark --set方法
-(void)setQuestionModel:(HWMusicquestionListModel *)questionModel
{
    _questionModel = questionModel;

    [_startAnsstis setTitle:_questionModel.isCache.boolValue ? @"查看详情":@"开始分析" forState:UIControlStateNormal];
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:_questionModel.onPic] placeholderImage:[UIImage imageNamed:@"BJ_BANNER"]];
    _titleLable.text=_questionModel.title;
    _describeLable.text=_questionModel.remark;
    if (_questionModel.isSure) {
        _titleLable.text = @"是否生成录音分析报告";
        _backImageView.hidden = YES;
        [_startAnsstis setTitle:@"确认" forState:UIControlStateNormal];
    }else
    {
        _backImageView.hidden = NO;
    }
}
#pragma mark --开始分析
-(void)clickstartbutton
{
   
    if ([_delegate respondsToSelector:@selector(clickansitisButtonwithindexPath:)])
    {
        [_delegate clickansitisButtonwithindexPath:_indexpath];
    }
    
}
@end
