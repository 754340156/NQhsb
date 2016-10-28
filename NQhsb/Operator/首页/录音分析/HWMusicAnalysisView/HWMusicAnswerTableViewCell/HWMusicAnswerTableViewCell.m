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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
