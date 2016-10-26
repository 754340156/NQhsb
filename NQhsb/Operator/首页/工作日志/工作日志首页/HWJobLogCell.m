//
//  HWJobLogCell.m
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWJobLogCell.h"
#import "HWJobLogModel.h"
@interface HWJobLogCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HWJobLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setModel:(HWJobLogModel *)model
{
    _model = model;
    self.contentLabel.text = model.title;
    self.timeLabel.text = model.dtCreat;
}


@end
