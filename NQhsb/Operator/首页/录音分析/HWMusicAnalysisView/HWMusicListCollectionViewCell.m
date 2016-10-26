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
   
}
#pragma mark --set方法
-(void)setQuestionModel:(HWMusicquestionListModel *)questionModel
{
    _questionModel=questionModel;
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:_questionModel.onPic] placeholderImage:[UIImage imageNamed:@"BJ_BANNER"]];
    _titleLable.text=_questionModel.title;
    _describeLable.text=_questionModel.remark;

    
}
@end
