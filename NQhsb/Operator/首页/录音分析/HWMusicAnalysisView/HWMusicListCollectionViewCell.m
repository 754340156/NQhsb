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
//    self.layer.masksToBounds=YES;
//    self.layer.shadowColor  = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity= 1;
//    self.layer.shadowRadius = 3;
    _backImageView.layer.masksToBounds=YES;
    _backImageView.layer.cornerRadius = 3;
    _startAnsstis.layer.masksToBounds = YES;
    _startAnsstis.layer.cornerRadius  = 3;
}
#pragma mark --set方法
-(void)setQuestionModel:(HWMusicquestionListModel *)questionModel
{
    _questionModel=questionModel;
    if ([questionModel.isCache isEqualToString:@"1"])
        [_startAnsstis setTitle:@"查看详情" forState:UIControlStateNormal];
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:_questionModel.onPic] placeholderImage:[UIImage imageNamed:@"BJ_BANNER"]];
    _titleLable.text=_questionModel.title;
    _describeLable.text=_questionModel.remark;
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
