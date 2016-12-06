//
//  HWMusicAnswerTableViewCell.m
//  Operator
//
//  Created by NeiQuan on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicAnswerTableViewCell.h"

@implementation HWMusicAnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLable.numberOfLines=0;
    // Initialization code
    _rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-28, (self.height-20)*0.5, 20, 20)];
    [self.contentView addSubview:_rightImageView];//添加子类视图
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
